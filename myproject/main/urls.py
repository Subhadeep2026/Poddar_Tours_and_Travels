from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('tours/', views.tour_list, name='tour_list'),
    path('tours/<slug:slug>/', views.tour_detail, name='tour_detail'),
    path('login/', views.page, {'page_name': 'login'}, name='login_shortcut'),
    path('<slug:page_name>.html', views.page, name='page'),
]