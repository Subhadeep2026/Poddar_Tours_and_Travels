import os
import django
import shutil

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings')
django.setup()

from main.models import Category, TourPackage, TourHighlight, TourRule, TourItinerary

# Create or get category
category, _ = Category.objects.get_or_create(name='International', defaults={'slug': 'international'})

# Copy image to media
src_image = r"C:\Users\Admin\.gemini\antigravity\brain\65b9c2e5-37b9-4566-ae85-0035d987dd75\nepal_tour_cover_1779608386143.png"
dest_dir = os.path.join(r"C:\Users\Admin\OneDrive\Desktop\poddar_django\myproject", "media", "tours")
os.makedirs(dest_dir, exist_ok=True)
dest_image = os.path.join(dest_dir, "nepal_tour.png")
shutil.copy(src_image, dest_image)

# Delete if exists to avoid duplicates during testing
TourPackage.objects.filter(slug="best-of-nepal-howrah").delete()

tour = TourPackage.objects.create(
    title="Best of Nepal Tour Package (from Howrah)",
    slug="best-of-nepal-howrah",
    duration="06 Nights 07 Days",
    short_description="Escape to the surreal surrounds of nature and seek blessings at famous temples with this 7 Days Nepal package starting from Howrah.",
    price=25000.00,
    full_description="""Our Nepal tour package is the ideal choice for those who wish to escape to the surreal surrounds of nature and seek blessings at some of the famous temples at the same time because it offers such a wealth of calming experiences. By purchasing this Nepal tour, you may discover and learn about the rich culture and legacy of Nepal and its towns, as well as the spectacular treasures of the nation. This 6 Nights 7 days tour (including train travel from Howrah) includes sightseeing as well as a pleasant place to stay and many amenities to make your trip special.""",
    image="tours/nepal_tour.png",
    is_featured=True,
    is_active=True
)

tour.categories.add(category)

highlights = [
    "Visit Bouddhanath Stupa",
    "Perform Aarati at Pashupatinath Temple",
    "Visit Chitwan National Park",
    "Visit Jungle walking & Tharu Village",
    "Enjoy Lumbini Garden",
    "Visit Buddhist Monasteries & Shrines",
    "Visit Sarankot hill",
    "Visit Bindabasini temple"
]

for h in highlights:
    TourHighlight.objects.create(tour=tour, text=h)

# Add inclusions / exclusions to TourRule
rules = [
    "✅ INCLUSION: Pick N drop Service From Kathmandu Airport / Border.",
    "✅ INCLUSION: Welcome Drink (Non-Alcoholic) on arrival.",
    "✅ INCLUSION: Accommodation in hotel.",
    "✅ INCLUSION: Daily Breakfast.",
    "❌ EXCLUSION: Any monument entry fees/camera fees.",
    "❌ EXCLUSION: Lunch and any meal not mentioned.",
    "❌ EXCLUSION: GST 5% on Bill.",
    "❌ EXCLUSION: Train fare from Howrah."
]
for r in rules:
    TourRule.objects.create(tour=tour, text=r)

itinerary = [
    {
        "day_number": 1,
        "title": "Departure from Howrah",
        "description": "Start your journey by boarding the Mithila Express (or similar) from Howrah Railway Station in the afternoon. Enjoy an overnight scenic train journey towards Raxaul, the gateway to Nepal."
    },
    {
        "day_number": 2,
        "title": "Arrival at Raxaul & Transfer to Kathmandu",
        "description": "Arrive at Raxaul in the morning. Meet our representative and cross the border to Nepal. Enjoy a scenic drive to Kathmandu. Upon arrival in Kathmandu, check-in to your hotel and relax. You will be escorted for a tour to Pashupatinath, the centre of Hindu culture in Nepal."
    },
    {
        "day_number": 3,
        "title": "Visit Boudhanath and Pokhara Transfer",
        "description": "After breakfast, visit Boudhanath, the most important Buddhist site in Nepal. Later, travel 210 kilometers to Pokhara. You can choose to pay to ride the cable cars at Manokamna Temple en route. Check into the hotel for an overnight stay when you arrive in Pokhara."
    },
    {
        "day_number": 4,
        "title": "Excursion to Sarangkot",
        "description": "Embark on an early morning excursion to Sarangkot (1590 m) for stunning sunrise views over the Annapurna and Dhaulagiri ranges. Later, visit Devi's Fall, a magnificent waterfall. Enjoy a relaxing night at the hotel in Pokhara."
    },
    {
        "day_number": 5,
        "title": "Pokhara to Kathmandu",
        "description": "Start your journey today from Pokhara back in the direction of Kathmandu. Upon reaching, you can spend the evening exploring the city and the local markets at your own leisure."
    },
    {
        "day_number": 6,
        "title": "Visit to Patan and Departure",
        "description": "After breakfast, you'll be escorted to Patan (Lalitpur), the city of beauty. Visit the Tibetan refugee centre and the Swayambhu stupa. In the evening, transfer back to the border (Raxaul) to board your return overnight train to Howrah."
    },
    {
        "day_number": 7,
        "title": "Arrival in Howrah",
        "description": "Arrive at Howrah Railway Station in the afternoon, carrying wonderful memories of your Nepal tour."
    }
]

for item in itinerary:
    TourItinerary.objects.create(
        tour=tour,
        day_number=item['day_number'],
        title=item['title'],
        description=item['description']
    )

print("Tour added successfully!")
