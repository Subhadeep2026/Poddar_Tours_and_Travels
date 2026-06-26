from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.core.validators import MinValueValidator, MaxValueValidator
from django.utils.crypto import get_random_string


class CustomUserManager(BaseUserManager):
    def create_user(self, email, phone_number, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, phone_number=phone_number, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, phone_number, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True.')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True.')

        return self.create_user(email, phone_number, password, **extra_fields)


# =========================================================
# CUSTOM USER MODEL
# =========================================================

class CustomUser(AbstractUser):
    objects = CustomUserManager()

    ROLE_CHOICES = (
        ('traveler', 'Traveler'),
        ('staff', 'Staff'),
        ('manager', 'Tour Manager'),
        ('admin', 'Admin'),
    )

    username = None

    email = models.EmailField(unique=True)

    phone_number = models.CharField(
        max_length=15,
        unique=True,
        null=True,
        blank=True
    )

    role = models.CharField(
        max_length=20,
        choices=ROLE_CHOICES,
        default='traveler'
    )

    profile_picture = models.ImageField(
        upload_to='profiles/',
        null=True,
        blank=True
    )

    address = models.TextField(blank=True)

    city = models.CharField(
        max_length=100,
        blank=True
    )

    loyalty_points = models.PositiveIntegerField(default=0)

    is_email_verified = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True)

    USERNAME_FIELD = 'email'

    REQUIRED_FIELDS = ['phone_number']

    def __str__(self):
        return self.email


# =========================================================
# CATEGORY MODEL
# =========================================================

class Category(models.Model):

    name = models.CharField(max_length=100)

    slug = models.SlugField(unique=True)

    image = models.ImageField(
        upload_to='categories/',
        null=True,
        blank=True
    )

    class Meta:
        verbose_name_plural = "Categories"

    def __str__(self):
        return self.name


# =========================================================
# TOUR PACKAGE MODEL
# =========================================================

class TourPackage(models.Model):

    categories = models.ManyToManyField(
        Category,
        related_name='tours',
        blank=True
    )

    title = models.CharField(max_length=200)

    slug = models.SlugField(
        unique=True,
        help_text="URL friendly name"
    )

    duration = models.CharField(
        max_length=100,
        help_text="e.g. 8 Days / 7 Nights"
    )

    price = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        default=0.00
    )

    discount_price = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        null=True,
        blank=True
    )

    short_description = models.TextField(
        help_text="Shown on the main Tours page"
    )

    full_description = models.TextField(
        help_text="Shown on detailed tour page"
    )

    image = models.ImageField(
        upload_to='tours/'
    )

    is_featured = models.BooleanField(default=False)

    upcoming_dates = models.TextField(
        blank=True,
        null=True,
        help_text="Enter upcoming departure dates, e.g., 'May 20, June 5, July 12'"
    )

    is_active = models.BooleanField(default=True)

    created_at = models.DateTimeField(auto_now_add=True)

    @property
    def parsed_upcoming_dates_json(self):
        import datetime
        import json
        dates = []
        if self.upcoming_dates:
            parts = [p.strip() for p in self.upcoming_dates.split(',')]
            for p in parts:
                try:
                    # Parse "June 10" and append the current logical year for the project (2026)
                    dt = datetime.datetime.strptime(p + " 2026", "%B %d %Y")
                    dates.append(dt.strftime("%Y-%m-%d"))
                except ValueError:
                    pass
        return json.dumps(dates)

    def __str__(self):
        return self.title


# =========================================================
# TOUR HIGHLIGHTS
# =========================================================

class TourHighlight(models.Model):

    tour = models.ForeignKey(
        TourPackage,
        related_name='highlights',
        on_delete=models.CASCADE
    )

    text = models.CharField(max_length=200)

    def __str__(self):
        return f"{self.tour.title} - {self.text}"


# =========================================================
# TOUR RULES
# =========================================================

class TourRule(models.Model):

    tour = models.ForeignKey(
        TourPackage,
        related_name='rules',
        on_delete=models.CASCADE
    )

    text = models.CharField(max_length=500)

    def __str__(self):
        return f"{self.tour.title} - {self.text[:30]}"


# =========================================================
# TOUR ITINERARY
# =========================================================

class TourItinerary(models.Model):

    tour = models.ForeignKey(
        TourPackage,
        related_name='itineraries',
        on_delete=models.CASCADE
    )

    day_number = models.PositiveIntegerField()

    title = models.CharField(max_length=200)

    description = models.TextField()

    class Meta:
        verbose_name_plural = "Tour Itineraries"
        ordering = ['day_number']

    def __str__(self):
        return f"{self.tour.title} - Day {self.day_number}"


# =========================================================
# TOUR GALLERY
# =========================================================

class TourGallery(models.Model):

    tour = models.ForeignKey(
        TourPackage,
        related_name='gallery',
        on_delete=models.CASCADE
    )

    image = models.ImageField(
        upload_to='tours/gallery/'
    )

    caption = models.CharField(
        max_length=200,
        blank=True
    )

    class Meta:
        verbose_name_plural = "Tour Galleries"

    def __str__(self):
        return self.tour.title


# =========================================================
# BOOKING MODEL
# =========================================================

class Booking(models.Model):

    STATUS_CHOICES = (
        ('pending', 'Pending'),
        ('confirmed', 'Confirmed'),
        ('cancelled', 'Cancelled'),
        ('completed', 'Completed'),
    )

    PAYMENT_METHOD_CHOICES = (
        ('online', 'Online Payment'),
        ('offline', 'Pay Later / Offline'),
    )
    
    PAYMENT_STATUS_CHOICES = (
        ('pending', 'Pending'),
        ('paid', 'Paid'),
        ('failed', 'Failed'),
    )

    booking_id = models.CharField(
        max_length=20,
        unique=True,
        editable=False
    )

    user = models.ForeignKey(
        CustomUser,
        related_name='bookings',
        on_delete=models.CASCADE
    )

    tour = models.ForeignKey(
        TourPackage,
        related_name='bookings',
        on_delete=models.CASCADE
    )

    travel_date = models.DateField()

    num_adults = models.PositiveIntegerField(default=1)

    num_children = models.PositiveIntegerField(default=0)

    total_price = models.DecimalField(
        max_digits=10,
        decimal_places=2
    )

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default='pending'
    )

    payment_method = models.CharField(
        max_length=20,
        choices=PAYMENT_METHOD_CHOICES,
        default='offline'
    )

    payment_status = models.CharField(
        max_length=20,
        choices=PAYMENT_STATUS_CHOICES,
        default='pending'
    )

    created_at = models.DateTimeField(auto_now_add=True)

    def save(self, *args, **kwargs):
        if not self.booking_id:
            self.booking_id = f"PTT{get_random_string(8).upper()}"
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.booking_id} - {self.user.email}"


# =========================================================
# PASSENGER MODEL
# =========================================================

class Passenger(models.Model):
    GENDER_CHOICES = (
        ('M', 'Male'),
        ('F', 'Female'),
        ('O', 'Other'),
    )
    
    booking = models.ForeignKey(Booking, related_name='passengers', on_delete=models.CASCADE)
    name = models.CharField(max_length=150)
    age = models.PositiveIntegerField()
    gender = models.CharField(max_length=1, choices=GENDER_CHOICES)
    
    def __str__(self):
        return f"{self.name} ({self.age} - {self.gender})"


# =========================================================
# REVIEW MODEL
# =========================================================

class Review(models.Model):

    tour = models.ForeignKey(
        TourPackage,
        related_name='reviews',
        on_delete=models.CASCADE
    )

    user = models.ForeignKey(
        CustomUser,
        related_name='reviews',
        on_delete=models.CASCADE
    )

    rating = models.PositiveIntegerField(
        validators=[
            MinValueValidator(1),
            MaxValueValidator(5)
        ]
    )

    comment = models.TextField()

    verified_purchase = models.BooleanField(default=False)

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.user.email} - {self.tour.title}"


# =========================================================
# ENQUIRY MODEL
# =========================================================

class Enquiry(models.Model):

    name = models.CharField(max_length=100)

    email = models.EmailField()

    phone = models.CharField(max_length=15)

    tour = models.ForeignKey(
        TourPackage,
        on_delete=models.SET_NULL,
        null=True,
        blank=True
    )

    message = models.TextField()

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        verbose_name_plural = "Enquiries"
        ordering = ['-created_at']

    def __str__(self):
        return f"Enquiry from {self.name}"



# =========================================================
# NEWSLETTER MODEL
# =========================================================

class Newsletter(models.Model):
    email = models.EmailField(unique=True)
    is_active = models.BooleanField(default=True)
    subscribed_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.email


# =========================================================
# CHATBOT MODELS
# =========================================================

class ChatMessage(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, null=True, blank=True)
    session_id = models.CharField(max_length=100, null=True, blank=True)
    message = models.TextField()
    is_bot = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['created_at']

    def __str__(self):
        return f"{'Bot' if self.is_bot else 'User'}: {self.message[:50]}"