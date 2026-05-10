from django.shortcuts import render, redirect
from django.http import Http404
from django.contrib.auth import authenticate, login, logout
from django.contrib import messages
from pathlib import Path

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
        
        # Handle Feedback and Contact submissions
        elif page_name == 'Feedback' or page_name == 'contactus':
            messages.success(request, 'Thank you! Your information has been received successfully. We will get back to you soon.')
            return redirect('page', page_name=page_name)
            
    # Dynamically check if the page exists
    page_path = BASE_PAGE_DIR / f"{page_name}.html"
    if not page_path.exists():
        raise Http404('Page not found')
        
    categories = Category.objects.all()
    return render(request, f'pages/{page_name}.html', {'categories': categories})

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
