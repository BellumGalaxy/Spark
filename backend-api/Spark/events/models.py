from django.db import models
from users.models import CustomUser
class Event(models.Model):
    title = models.CharField(max_length=100)
    date = models.DateField()
    location = models.CharField(max_length=100)
    amount_total = models.DecimalField(max_digits=10, decimal_places=2, default=0.0)
    amount_actual = models.DecimalField(max_digits=10, decimal_places=2)
    user = models.ForeignKey(CustomUser, related_name='received_event', on_delete=models.CASCADE, limit_choices_to={'type_user': 'athlete'},default=1)

    def __str__(self):
        return self.title