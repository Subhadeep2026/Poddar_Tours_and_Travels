import os
import django
import re

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings')
django.setup()

from main.models import TourPackage, TourHighlight

tours_data = [
    {"slug": "kashmir", "file": "Kashmir.html", "short": "Snow-capped peaks and serene valleys await you in the heart of the Himalayas.", "img": "kash2.jpg"},
    {"slug": "kerala", "file": "Kerala.html", "short": "Peaceful lagoons and lush palm groves in God’s own country.", "img": "kerala.jpeg"},
    {"slug": "ooty", "file": "Ooty.html", "short": "Escape to the cool blue mountains for a refreshing break in nature.", "img": "ooty.jpg"},
    {"slug": "amritsar", "file": "Amritsar.html", "short": "A journey of soul and culture at the iconic Golden Temple.", "img": "Amritsar.jpg"},
    {"slug": "darjeeling", "file": "Darjeeling.html", "short": "Wake up to the majestic Kanchenjunga and rolling tea gardens.", "img": "dd.jpeg"},
    {"slug": "shimla-kullu-manali", "file": "Shimla-Kullu-Manali.html", "short": "Adventure and heritage combined in these stunning mountain escapes.", "img": "shimla-manali-tour1.png"},
    {"slug": "goa", "file": "Goa.html", "short": "Relax on world-class beaches and experience the vibrant Goan spirit.", "img": "Places-to-Visit-in-South-Goa-1024x683.webp"},
    {"slug": "ladakh", "file": "Ladakh.html", "short": "Unearth the wild beauty of high passes and crystal-clear lakes.", "img": "2019102967.jpg"}
]

base_dir = r"c:\Users\Admin\OneDrive\Desktop\poddar_django\myproject\main\template\pages\backup_original"

for t in tours_data:
    filepath = os.path.join(base_dir, t["file"])
    if not os.path.exists(filepath):
        print(f"File not found: {filepath}")
        continue
        
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
        
    # Extract Title
    title_match = re.search(r'<h2 class="dest-title">(.*?)</h2>', content)
    title = title_match.group(1).strip() if title_match else t["slug"].capitalize()
    
    # Extract Duration (e.g. from "GOA TOUR PACKAGE (8 DAYS)")
    duration_match = re.search(r'\((.*?)\)', title)
    duration = duration_match.group(1) if duration_match else ""
    
    # Extract Description
    desc_match = re.search(r'<p class="dest-description">\s*(.*?)\s*</p>', content, re.DOTALL)
    full_desc = desc_match.group(1).strip() if desc_match else ""
    
    # Create Package
    tour_obj, created = TourPackage.objects.get_or_create(
        slug=t["slug"],
        defaults={
            "title": title,
            "duration": duration,
            "short_description": t["short"],
            "full_description": full_desc,
            "image": f"tours/{t['img']}" # Just string path for now
        }
    )
    
    if created:
        print(f"Created Tour: {title}")
        # Extract Highlights
        highlights = re.findall(r'<div class="highlight-item">(?:✔)?\s*(.*?)</div>', content)
        for hl in highlights:
            TourHighlight.objects.create(tour=tour_obj, text=hl.strip())
    else:
        print(f"Tour already exists: {title}")

print("Database population complete!")
