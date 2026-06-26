from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import Category, TourPackage, TourHighlight, TourRule, TourItinerary, TourGallery, Booking, Review, Enquiry, Newsletter, CustomUser

# Custom User Admin
class CustomUserAdmin(BaseUserAdmin):
    ordering = ('email',)
    list_display = ('email', 'role', 'is_staff', 'is_superuser')
    search_fields = ('email', 'phone_number')
    fieldsets = (
        (None, {'fields': ('email', 'password')}),
        ('Personal info', {'fields': ('phone_number', 'role', 'profile_picture', 'address', 'city', 'loyalty_points')}),
        ('Permissions', {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
        ('Important dates', {'fields': ('last_login', 'created_at')}),
    )
    readonly_fields = ('created_at',)

# Re-register CustomUserAdmin
admin.site.register(CustomUser, CustomUserAdmin)

@admin.register(Newsletter)
class NewsletterAdmin(admin.ModelAdmin):
    list_display = ('email', 'is_active', 'subscribed_at')
    list_filter = ('is_active', 'subscribed_at')
    search_fields = ('email',)

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('name', 'slug')
    prepopulated_fields = {'slug': ('name',)}

class TourHighlightInline(admin.TabularInline):
    model = TourHighlight
    extra = 1

class TourRuleInline(admin.TabularInline):
    model = TourRule
    extra = 1

class TourItineraryInline(admin.TabularInline):
    model = TourItinerary
    extra = 1

class TourGalleryInline(admin.TabularInline):
    model = TourGallery
    extra = 1

@admin.register(TourPackage)
class TourPackageAdmin(admin.ModelAdmin):
    list_display = ('title', 'get_categories', 'price', 'is_featured', 'is_active')
    list_filter = ('categories', 'is_featured', 'is_active')
    search_fields = ('title', 'short_description')
    prepopulated_fields = {'slug': ('title',)}
    inlines = [TourHighlightInline, TourRuleInline, TourItineraryInline, TourGalleryInline]

    def get_categories(self, obj):
        return ", ".join([c.name for c in obj.categories.all()])
    get_categories.short_description = 'Categories'

@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = ('booking_id', 'user', 'tour', 'travel_date', 'status', 'total_price')
    list_filter = ('status', 'travel_date')
    search_fields = ('booking_id', 'user__email', 'tour__title')
    readonly_fields = ('booking_id', 'created_at')

@admin.register(Review)
class ReviewAdmin(admin.ModelAdmin):
    list_display = ('tour', 'user', 'rating', 'created_at')
    list_filter = ('rating', 'created_at')

@admin.register(Enquiry)
class EnquiryAdmin(admin.ModelAdmin):
    list_display = ('name', 'email', 'phone', 'tour', 'created_at')
    list_filter = ('created_at',)
    search_fields = ('name', 'email', 'message')
