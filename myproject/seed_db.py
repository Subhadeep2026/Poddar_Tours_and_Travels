import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings')
django.setup()

from main.models import Category, TourPackage

def seed_data():
    # Create Categories
    categories = [
        {'name': 'Adventure', 'slug': 'adventure'},
        {'name': 'Honeymoon', 'slug': 'honeymoon'},
        {'name': 'Family', 'slug': 'family'},
        {'name': 'Religious', 'slug': 'religious'},
        {'name': 'Beach', 'slug': 'beach'},
    ]
    
    for cat_data in categories:
        Category.objects.get_or_create(name=cat_data['name'], defaults={'slug': cat_data['slug']})
        print(f"Category {cat_data['name']} checked/created.")

    # Define the category mapping system
    tour_category_map = {
        'kashmir': ['adventure', 'family'],
        'ladakh': ['adventure'],
        'goa': ['beach', 'family', 'honeymoon'],
        'amritsar': ['religious', 'family'],
        'kerala': ['family', 'honeymoon', 'beach'],
        'ooty': ['family', 'honeymoon'],
        'darjeeling': ['family', 'adventure'],
        'shimla-kullu-manali': ['family', 'adventure'],
    }

    tours = TourPackage.objects.all()
    for tour in tours:
        if not tour.price or tour.price == 0:
            tour.price = 15000.00 
        
        # Get category slugs from map, default to 'family' if not found
        cat_slugs = tour_category_map.get(tour.slug.lower(), ['family'])
        
        # Fetch categories and sync them using .set()
        target_cats = Category.objects.filter(slug__in=cat_slugs)
        tour.categories.set(target_cats)
            
        tour.save()
        cat_names = ", ".join([c.name for c in tour.categories.all()])
        print(f"Updated Tour: {tour.title} | Categories: {cat_names}")

if __name__ == '__main__':
    seed_data()
