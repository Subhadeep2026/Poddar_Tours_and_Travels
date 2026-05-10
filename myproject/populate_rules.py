import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings')
django.setup()

from main.models import TourPackage, TourRule

common_rules = [
    "Valid ID proof (Aadhar Card/Voter ID) is mandatory for all travelers.",
    "Smoking and alcohol consumption are strictly prohibited during transit.",
    "Please maintain the decorum and silence in religious and heritage sites.",
    "Follow the tour guide's instructions for a safe and enjoyable experience.",
    "Any personal expenses or activities not in the itinerary will be extra.",
    "Punctuality is essential for the smooth operation of the group tour."
]

specific_rules = {
    "kashmir": [
        "Carry heavy woolens, gloves, and caps even in summer for high-altitude areas.",
        "Prepaid SIM cards from other states do not work in J&K; only postpaid works."
    ],
    "kerala": [
        "Follow the traditional dress code when visiting the Padmanabhaswamy Temple.",
        "Use eco-friendly bags; Kerala is a plastic-free zone in many areas."
    ],
    "ladakh": [
        "First 24-48 hours of complete rest is mandatory for acclimatization.",
        "Carry personal oxygen cylinders if you have respiratory issues."
    ],
    "darjeeling": [
        "Be prepared for sudden weather changes and carry a light umbrella/raincoat.",
        "Respect the local tea garden workers and avoid plucking tea leaves."
    ],
    "amritsar": [
        "Keep your head covered with a scarf or handkerchief inside the Golden Temple.",
        "Remove shoes and wash hands/feet before entering the temple complex."
    ],
    "goa": [
        "Avoid swimming in the sea during high tide or after sunset.",
        "Wear sunscreen and keep yourself hydrated throughout the day."
    ]
}

def populate_rules():
    tours = TourPackage.objects.all()
    for tour in tours:
        # Clear existing rules first to avoid duplicates if run multiple times
        TourRule.objects.filter(tour=tour).delete()
        
        # Add common rules
        for rule_text in common_rules:
            TourRule.objects.create(tour=tour, text=rule_text)
        
        # Add specific rules if any
        if tour.slug in specific_rules:
            for rule_text in specific_rules[tour.slug]:
                TourRule.objects.create(tour=tour, text=rule_text)
        
        print(f"Populated {TourRule.objects.filter(tour=tour).count()} rules for {tour.title}")

if __name__ == "__main__":
    populate_rules()
