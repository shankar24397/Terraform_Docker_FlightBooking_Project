from django.shortcuts import render, redirect
from .models import Flight,Booking

def index_page(request):
    return render(request,'bookings/index_page.html')

def booking_cancelled(request):
    return render(request, 'bookings/booking_cancelled.html')

def book_flight(request, flight_id):
    flight = Flight.objects.get(pk=flight_id)
    if request.method == 'POST':
        passenger_name = request.POST.get('passenger_name')
        seat_number = int(request.POST.get('seat_number'))
        if flight.available_seats > 0:
            Booking.objects.create(flight=flight, passenger_name=passenger_name, seat_number=seat_number)
            flight.available_seats -= 1
            flight.save()
            return redirect('booking_success')
    return render(request, 'bookings/book_flight.html', {'flight': flight})

def booking_success(request):
    return render(request, 'bookings/booking_success.html')

def cancel_booking(request, booking_id):
    booking = Booking.objects.get(pk=booking_id)
    flight = booking.flight
    flight.available_seats += 1
    flight.save()
    booking.delete()
    return redirect('booking_cancelled')
