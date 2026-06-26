from django.shortcuts import render, redirect
from django.http import Http404, JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from django.contrib.auth import authenticate, login, logout
from django.contrib import messages
from pathlib import Path
from openai import OpenAI
from django.conf import settings
from .chatbot_engine import get_tripnova_answer

BASE_PAGE_DIR = Path(__file__).resolve().parent / 'template' / 'pages'
VALID_PAGES = {page.stem: page.name for page in BASE_PAGE_DIR.glob('*.html')}

from .models import Category, TourPackage, Review

def home(request):
    featured_tours = TourPackage.objects.filter(is_featured=True, is_active=True).prefetch_related('categories')[:3]
    # Fetch 5-star reviews for the testimonial marquee
    testimonials = Review.objects.filter(rating=5).select_related('user', 'tour').order_by('-created_at')[:10]
    categories = Category.objects.all()
    return render(request, 'pages/index.html', {
        'featured_tours': featured_tours,
        'testimonials': testimonials,
        'categories': categories
    })


def page(request, page_name):
    # Handle authentication actions on the login page
    if request.method == 'POST':
        if page_name == 'login':
            action = request.POST.get('action')
            if action == 'login':
                username = request.POST.get('username')
                password = request.POST.get('password')
                user = authenticate(request, username=username, password=password)
                if user is not None:
                    login(request, user)
                    messages.success(request, 'Welcome back, ' + (user.first_name or user.email) + '!')
                    return redirect('home')
                else:
                    messages.error(request, 'Invalid credentials. Please try again.')
            elif action == 'logout':
                logout(request)
                messages.info(request, 'You have been logged out.')
                return redirect('home')
            elif action == 'register':
                full_name = request.POST.get('full_name')
                email = request.POST.get('email')
                phone = request.POST.get('phone')
                password = request.POST.get('password')
                confirm_password = request.POST.get('confirm_password')
                
                if password != confirm_password:
                    messages.error(request, 'Passwords do not match.')
                else:
                    from .models import CustomUser
                    if CustomUser.objects.filter(email=email).exists():
                        messages.error(request, 'Email already exists. Please login.')
                    elif CustomUser.objects.filter(phone_number=phone).exists():
                        messages.error(request, 'Phone number already registered.')
                    else:
                        user = CustomUser.objects.create_user(
                            email=email, 
                            phone_number=phone, 
                            password=password, 
                            first_name=full_name
                        )
                        login(request, user, backend='django.contrib.auth.backends.ModelBackend')
                        messages.success(request, f'Account created successfully! Welcome, {full_name}.')
                        return redirect('home')
        
        # Handle Feedback and Contact submissions
        elif page_name == 'Feedback' or page_name == 'contactus':
            messages.success(request, 'Thank you! Your information has been received successfully. We will get back to you soon.')
            return redirect('page', page_name=page_name)
            
    # Dynamically check if the page exists
    page_path = BASE_PAGE_DIR / f"{page_name}.html"
    if not page_path.exists():
        raise Http404('Page not found')
        
    categories = Category.objects.all()
    context = {'categories': categories}
    
    if page_name == 'account' and request.user.is_authenticated:
        from .models import Booking
        context['bookings'] = Booking.objects.filter(user=request.user).order_by('-created_at')
        
    if page_name == 'admin_dashboard' and request.user.is_superuser:
        from .models import Booking, TourPackage
        context['bookings'] = Booking.objects.all().order_by('-created_at')
        context['all_tours'] = TourPackage.objects.filter(is_active=True)
        
    return render(request, f'pages/{page_name}.html', context)

from django.shortcuts import render, redirect, get_object_or_404
from .models import Category, TourPackage

def tour_list(request):
    try:
        category_slug = request.GET.get('category')
        tours = TourPackage.objects.filter(is_active=True).prefetch_related('categories')
        
        if category_slug:
            tours = tours.filter(categories__slug=category_slug)
            
        categories = Category.objects.all()
        return render(request, 'pages/tour_list.html', {
            'tours': tours,
            'categories': categories,
            'current_category': category_slug
        })
    except Exception as e:
        # If there is a database error, show a helpful message instead of crashing
        print(f"Error in tour_list: {e}")
        return render(request, 'pages/tour_list.html', {
            'tours': [],
            'categories': [],
            'error': "We're currently updating our tour catalog. Please check back shortly!"
        })

from .forms import ReviewForm
from django.utils import timezone
from .models import Booking

def tour_detail(request, slug):
    tour = get_object_or_404(
        TourPackage.objects.prefetch_related('highlights', 'rules', 'itineraries', 'gallery', 'reviews__user'), 
        slug=slug
    )
    
    # Check if the user has completed this tour
    has_completed_tour = False
    if request.user.is_authenticated:
        has_completed_tour = Booking.objects.filter(
            user=request.user,
            tour=tour,
            status='confirmed',
            travel_date__lte=timezone.now().date()
        ).exists()

    if request.method == 'POST':
        action = request.POST.get('action')
        
        if action == 'book_tour':
            if not request.user.is_authenticated:
                messages.error(request, 'You must be logged in to book a tour.')
                return redirect('page', page_name='login')
                
            travel_date = request.POST.get('travel_date')
            num_adults = int(request.POST.get('num_adults', 1))
            num_children = int(request.POST.get('num_children', 0))
            payment_method = request.POST.get('payment_method', 'offline')
            
            # Simple pricing logic: adults full price, children half price
            total_price = float(tour.price) * (num_adults + (num_children * 0.5))
            
            from .models import Passenger
            
            booking = Booking.objects.create(
                user=request.user,
                tour=tour,
                travel_date=travel_date,
                num_adults=num_adults,
                num_children=num_children,
                total_price=total_price,
                status='pending',
                payment_method=payment_method,
                payment_status='pending'
            )
            
            # Extract and save passengers
            total_pax = num_adults + num_children
            for i in range(1, total_pax + 1):
                pax_name = request.POST.get(f'pax_name_{i}')
                pax_age = request.POST.get(f'pax_age_{i}')
                pax_gender = request.POST.get(f'pax_gender_{i}')
                
                if pax_name and pax_age and pax_gender:
                    Passenger.objects.create(
                        booking=booking,
                        name=pax_name,
                        age=int(pax_age),
                        gender=pax_gender
                    )
            
            if payment_method == 'online':
                return redirect('mock_payment', booking_id=booking.booking_id)
            else:
                messages.success(request, 'Booking request received! You have opted to pay later.')
                return redirect('page', page_name='account')
            
        else:
            # Handle review submission
            if not request.user.is_authenticated:
                messages.error(request, 'You must be logged in to post a review.')
                return redirect('page', page_name='login')
            
            if not has_completed_tour:
                messages.error(request, 'Only customers who have completed this tour can leave a review.')
                return redirect('tour_detail', slug=slug)
    
            form = ReviewForm(request.POST)
            if form.is_valid():
                review = form.save(commit=False)
                review.tour = tour
                review.user = request.user
                review.verified_purchase = True
                review.save()
                messages.success(request, 'Thank you! Your review has been posted.')
                return redirect('tour_detail', slug=slug)
    else:
        form = ReviewForm()


    return render(request, 'pages/tour_detail.html', {
        'tour': tour,
        'form': form,
        'has_completed_tour': has_completed_tour
    })

@csrf_exempt
def chatbot_response(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)
            user_message = data.get('message', '').strip()
            
            if not user_message:
                return JsonResponse({'reply': "Please say something!"})

            # Ensure session exists and is saved
            if not request.session.session_key:
                request.session.create()
                request.session.save()
            
            # Save user message
            from .models import ChatMessage
            ChatMessage.objects.create(
                user=request.user if request.user.is_authenticated else None,
                session_id=request.session.session_key,
                message=user_message,
                is_bot=False
            )
            
            # Fetch recent conversation history (last 5 messages)
            # Evaluate the QuerySet into a list before reversing
            history_qs = ChatMessage.objects.filter(
                session_id=request.session.session_key
            ).order_by('-created_at')[:6]
            history = list(reversed(history_qs))
            
            messages_payload = [
                {"role": "system", "content": "You are TripNova AI, the official virtual assistant for Poddar Tours & Travels. You are helpful, professional, and knowledgeable about travel in India. You should encourage users to book tours with Poddar Tours & Travels. If you don't know something specific about a tour, suggest they contact support or check the website."}
            ]
            
            # Add context about available tours if relevant
            if any(word in user_message.lower() for word in ['tour', 'package', 'place', 'visit', 'go', 'booking', 'price']):
                from .models import TourPackage
                tours = TourPackage.objects.filter(is_active=True)[:5]
                tour_info = "\n".join([f"- {t.title}: {t.short_description} (Price: ₹{t.price})" for t in tours])
                messages_payload[0]["content"] += f"\n\nHere are some of our popular tours:\n{tour_info}"

            for msg in history:
                role = "assistant" if msg.is_bot else "user"
                messages_payload.append({"role": role, "content": msg.message})

            # Check for placeholder key
            if not getattr(settings, 'GEMINI_API_KEY', None) or settings.GEMINI_API_KEY == 'your-gemini-api-key-here':
                print("Chatbot Error: Gemini API Key not configured.")
                return JsonResponse({'reply': "I'm ready to help, but my Gemini API key hasn't been configured yet! Please add a valid key in your settings or .env file to enable my AI brain."})

            # Build Context about the User's Bookings
            user_context = "The user is not logged in."
            if request.user.is_authenticated:
                from .models import Booking
                user_bookings = Booking.objects.filter(user=request.user).order_by('-created_at')
                if user_bookings.exists():
                    user_context = "The user has the following bookings in their account:\n"
                    for b in user_bookings:
                        user_context += f"- Booking ID: {b.booking_id}, Tour: {b.tour.title}, Status: {b.status}, Date: {b.travel_date.strftime('%Y-%m-%d')}, Total Price: ₹{b.total_price}\n"
                else:
                    user_context = "The user is logged in, but they have no current bookings."

            # Initialize OpenAI client (now Gemini)
            bot_reply = get_tripnova_answer(user_message, user_context=user_context)

            # Save bot message
            ChatMessage.objects.create(
                user=request.user if request.user.is_authenticated else None,
                session_id=request.session.session_key,
                message=bot_reply,
                is_bot=True
            )
            
            return JsonResponse({'reply': bot_reply})
        except Exception as e:
            import traceback
            print(f"Chatbot Error: {str(e)}")
            print(traceback.format_exc())
            return JsonResponse({'reply': "I'm having a bit of trouble connecting to my brain. Please check the server logs for details!"}, status=200)
            
    return JsonResponse({'error': 'Invalid request'}, status=400)

from django.views.decorators.http import require_POST
from django.contrib.auth.decorators import login_required

@login_required
def mock_payment(request, booking_id):
    from .models import Booking
    booking = get_object_or_404(Booking, booking_id=booking_id, user=request.user)
    
    if request.method == 'POST':
        # Simulate payment success
        booking.payment_status = 'paid'
        booking.status = 'confirmed'
        booking.save()
        messages.success(request, 'Payment Successful! Your booking is confirmed.')
        return redirect('page', page_name='account')
        
    return render(request, 'pages/mock_payment.html', {'booking': booking})

@require_POST
def update_booking_status(request, booking_id):
    if not request.user.is_authenticated or not request.user.is_superuser:
        return JsonResponse({'error': 'Unauthorized'}, status=403)
        
    import json
    from .models import Booking
    
    try:
        data = json.loads(request.body)
        status = data.get('status')
        payment_status = data.get('payment_status')
        
        booking = Booking.objects.get(booking_id=booking_id)
        
        if status:
            booking.status = status
        if payment_status:
            booking.payment_status = payment_status
            
        booking.save()
        return JsonResponse({'success': True, 'message': 'Booking updated successfully'})
    except Exception as e:
        return JsonResponse({'error': str(e)}, status=400)

@login_required
@require_POST
def admin_create_booking(request):
    if not request.user.is_superuser:
        messages.error(request, 'Unauthorized')
        return redirect('page', page_name='admin_dashboard')
        
    try:
        from .models import CustomUser, TourPackage, Booking, Passenger
        from django.utils.crypto import get_random_string
        
        email = request.POST.get('customer_email')
        name = request.POST.get('customer_name')
        phone = request.POST.get('customer_phone')
        
        # 1. Resolve or Create User
        user = CustomUser.objects.filter(email=email).first()
        is_new_user = False
        password = None
        
        if not user:
            is_new_user = True
            password = get_random_string(12)
            user = CustomUser.objects.create_user(
                email=email,
                phone_number=phone,
                password=password,
                first_name=name
            )
            
        # 2. Create Booking
        tour_id = request.POST.get('tour_id')
        tour = get_object_or_404(TourPackage, id=tour_id)
        
        travel_date = request.POST.get('travel_date')
        num_adults = int(request.POST.get('num_adults', 1))
        num_children = int(request.POST.get('num_children', 0))
        payment_status = request.POST.get('payment_status', 'paid')
        
        total_price = float(tour.price) * (num_adults + (num_children * 0.5))
        
        booking = Booking.objects.create(
            user=user,
            tour=tour,
            travel_date=travel_date,
            num_adults=num_adults,
            num_children=num_children,
            total_price=total_price,
            status='confirmed',
            payment_method='offline',
            payment_status=payment_status
        )
        
        # 3. Save Passengers
        total_pax = num_adults + num_children
        for i in range(1, total_pax + 1):
            pax_name = request.POST.get(f'pax_name_{i}')
            pax_age = request.POST.get(f'pax_age_{i}')
            pax_gender = request.POST.get(f'pax_gender_{i}')
            
            if pax_name and pax_age and pax_gender:
                Passenger.objects.create(
                    booking=booking,
                    name=pax_name,
                    age=int(pax_age),
                    gender=pax_gender
                )
                
        # 4. Send Email & SMS Notification
        if is_new_user:
            msg = send_booking_notification(name, booking.booking_id, email, password, phone)
            messages.success(request, f"Successfully created booking for {email}! NEW ACCOUNT CREATED.")
            # Show the simulated email on the admin screen for demonstration
            messages.info(request, f"SIMULATED EMAIL SENT TO CUSTOMER:\n\n{msg}")
        else:
            messages.success(request, f"Successfully created booking for existing user {email}!")
            
    except Exception as e:
        messages.error(request, f"Failed to create booking: {str(e)}")
        
    return redirect('page', page_name='admin_dashboard')

def send_booking_notification(name, booking_id, email, password, phone):
    """
    Mock function to simulate sending an SMS and Email to the customer.
    In a production environment, you would hook this up to SendGrid/SMTP and Twilio.
    """
    message_text = f"""Hello {name},
Your booking has been confirmed and your booking ID is {booking_id}

you can check your booking using your id and password:
ID: {email}
Password: {password}"""
    
    # Simulating sending the Email and SMS by printing to the terminal console
    print("\n" + "="*50, flush=True)
    print(f"📧 SENDING EMAIL TO: {email}", flush=True)
    print(f"📱 SENDING SMS TO: {phone}", flush=True)
    print("-" * 50, flush=True)
    print(message_text, flush=True)
    print("=" * 50 + "\n", flush=True)
    
    return message_text

def new_page(request):
    return render(request, 'new.html')
