from django.db import models
from users.models import CustomUser
class Event(models.Model):
    title = models.CharField(max_length=100)
    date = models.DateField()
    location = models.CharField(max_length=100)
    user = models.ForeignKey(CustomUser, related_name='received_event', on_delete=models.CASCADE, limit_choices_to={'type_user': 'athlete'})

    def __str__(self):
        return self.title