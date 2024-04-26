from django.db import models

# Create your models here.
class Flight(models.Model):
    flight_number = models.CharField(max_length=12)
    departure_time = models.DateTimeField()
    arrival_time = models.DateTimeField()
    available_seats = models.IntegerField()


class Booking(models.Model):
    flight = models.ForeignKey(Flight, on_delete=models.CASCADE)
    passenger_name = models.CharField(max_length=100)
    seat_number = models.IntegerField()
    