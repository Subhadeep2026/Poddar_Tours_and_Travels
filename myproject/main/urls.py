from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('tours/', views.tour_list, name='tour_list'),
    path('tours/<slug:slug>/', views.tour_detail, name='tour_detail'),
    path('login/', views.page, {'page_name': 'login'}, name='login_shortcut'),
    path('chatbot/', views.chatbot_response, name='chatbot_response'),
    path('payment/<str:booking_id>/', views.mock_payment, name='mock_payment'),
    path('admin-dashboard/update-booking/<str:booking_id>/', views.update_booking_status, name='update_booking_status'),
    path('admin-dashboard/create-booking/', views.admin_create_booking, name='admin_create_booking'),
    path('new/', views.new_page, name='new_page'),
    path('<slug:page_name>.html', views.page, name='page'),
]