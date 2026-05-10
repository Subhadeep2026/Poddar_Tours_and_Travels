import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings')
django.setup()

from main.models import Category, TourPackage, Review, CustomUser

# 1. Create Categories
category_data = [
    ("Honeymoon", "honeymoon"),
    ("Adventure", "adventure"),
    ("Family", "family"),
    ("Weekend", "weekend"),
    ("Pilgrimage", "pilgrimage"),
]

categories = {}
for name, slug in category_data:
    cat, _ = Category.objects.get_or_create(name=name, slug=slug)
    categories[slug] = cat

# 2. Link Categories & Set Featured
tour_mappings = {
    "kashmir": {"cats": ["honeymoon", "family"], "featured": True},
    "kerala": {"cats": ["honeymoon", "family"], "featured": True},
    "ooty": {"cats": ["weekend", "family"], "featured": False},
    "amritsar": {"cats": ["pilgrimage", "family"], "featured": False},
    "darjeeling": {"cats": ["weekend", "family"], "featured": False},
    "shimla-kullu-manali": {"cats": ["adventure", "honeymoon"], "featured": False},
    "goa": {"cats": ["weekend", "adventure"], "featured": True},
    "ladakh": {"cats": ["adventure"], "featured": False},
}

for slug, mapping in tour_mappings.items():
    try:
        tour = TourPackage.objects.get(slug=slug)
        tour.is_featured = mapping["featured"]
        tour.save()
        for c_slug in mapping["cats"]:
            tour.categories.add(categories[c_slug])
    except TourPackage.DoesNotExist:
        pass

# 3. Create Dummy Users for Reviews
users_data = [
    ("admin@example.com", "Admin", "User", "9999999991"),
    ("john@example.com", "John", "Doe", "9999999992"),
    ("jane@example.com", "Jane", "Smith", "9999999993"),
]

users = []
for email, first, last, phone in users_data:
    try:
        u = CustomUser.objects.get(email=email)
    except CustomUser.DoesNotExist:
        u = CustomUser.objects.create_user(email=email, phone_number=phone, password="password123")
        u.first_name = first
        u.last_name = last
        u.save()
    users.append(u)

# 4. Create Reviews for Testimonials
reviews_data = [
    {"user": users[0], "tour_slug": "kashmir", "rating": 5, "comment": "Absolutely breathtaking experience! The arrangements were top-notch and the views were mesmerizing. Highly recommended!"},
    {"user": users[1], "tour_slug": "kerala", "rating": 5, "comment": "God's own country indeed. The houseboats were clean, and the food was amazing. Great package by Poddar Tours."},
    {"user": users[2], "tour_slug": "goa", "rating": 5, "comment": "A perfect getaway. Everything was smoothly handled from airport pickup to hotel stays. Couldn't ask for more."},
    {"user": users[1], "tour_slug": "ladakh", "rating": 5, "comment": "The adventure of a lifetime. The tour guides were very experienced and made sure we were safe the entire trip."},
]

for r_data in reviews_data:
    try:
        tour = TourPackage.objects.get(slug=r_data["tour_slug"])
        Review.objects.get_or_create(
            user=r_data["user"],
            tour=tour,
            defaults={
                "rating": r_data["rating"],
                "comment": r_data["comment"],
                "verified_purchase": True
            }
        )
    except TourPackage.DoesNotExist:
        pass

print("Successfully seeded home page items!")
