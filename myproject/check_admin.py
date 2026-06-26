import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'myproject.settings')
django.setup()

from main.models import CustomUser

superusers = CustomUser.objects.filter(is_superuser=True)
print("SUPERUSERS FOUND:")
for su in superusers:
    print(f"- Email: {su.email} | Phone: {su.phone_number} | is_staff: {su.is_staff} | is_active: {su.is_active}")
