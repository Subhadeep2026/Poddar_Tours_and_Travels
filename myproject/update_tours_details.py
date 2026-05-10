import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings')
django.setup()

from main.models import TourPackage

tours_updates = {
    "kashmir": {"duration": "7 Days / 6 Nights", "price": 24999},
    "kerala": {"duration": "6 Days / 5 Nights", "price": 19999},
    "ooty": {"duration": "4 Days / 3 Nights", "price": 12999},
    "amritsar": {"duration": "3 Days / 2 Nights", "price": 8999},
    "darjeeling": {"duration": "5 Days / 4 Nights", "price": 15999},
    "shimla-kullu-manali": {"duration": "11 Days / 10 Nights", "price": 34999},
    "goa": {"duration": "8 Days / 7 Nights", "price": 22999},
    "ladakh": {"duration": "9 Days / 8 Nights", "price": 39999},
}

for slug, data in tours_updates.items():
    TourPackage.objects.filter(slug=slug).update(duration=data["duration"], price=data["price"])

print("Successfully updated missing durations and prices for tours!")
