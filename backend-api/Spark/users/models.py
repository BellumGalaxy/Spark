from django.contrib.auth.models import AbstractUser, Group, Permission
from django.db import models

class CustomUser(AbstractUser):
    ATHLETE = 'athlete'
    DONOR = 'donor'
    SPONSOR = 'sponsor'

    USER_TYPE_CHOICES = [
        (ATHLETE, 'Atleta'),
        (DONOR, 'Doador'),
        (SPONSOR, 'Patrocinador'),
    ]   
    wallet_id = models.CharField(max_length=255, null=True, blank=True, unique=True)
    email = models.EmailField()
    bio = models.TextField(null=True, blank=True)
    location = models.CharField(max_length=100, null=True, blank=True)
    birth_date = models.DateField(null=True, blank=True)
    type_user = models.CharField(
        max_length=10,
        choices=USER_TYPE_CHOICES,
        default=ATHLETE,
    )
    user_validated = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)  
    street_address = models.CharField(max_length=255, null=True, blank=True)
    city = models.CharField(max_length=100, null=True, blank=True)
    state = models.CharField(max_length=100, null=True, blank=True)
    country = models.CharField(max_length=100, null=True, blank=True)
    postal_code = models.CharField(max_length=20, null=True, blank=True)
    groups = models.ManyToManyField(
        Group,
        related_name='customuser_set',  # Nome único
        blank=True,
    )
    user_permissions = models.ManyToManyField(
        Permission,
        related_name='customuser_permissions_set',  # Nome único
        blank=True,
    )

    def __str__(self):
        return self.username