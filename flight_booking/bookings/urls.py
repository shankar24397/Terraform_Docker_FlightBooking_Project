from django.urls import path
from . import views

urlpatterns = [
    path('', views.index_page, name='index_page'),
    path('<int:flight_id>/book/', views.book_flight, name='book_flight'),
    path('cancel/<int:booking_id>/', views.cancel_booking, name='cancel_booking'),
    path('success/', views.booking_success, name='booking_success'),
    path('cancelled/', views.booking_cancelled, name='booking_cancelled'),
]