# transactions/models.py
from django.db import models
from users.models import CustomUser

class Transaction(models.Model):
    SPONSORSHIP = 'sponsorship'
    DONATION = 'donation'

    TRANSACTION_TYPE_CHOICES = [
        (SPONSORSHIP, 'Patrocínio'),
        (DONATION, 'Doação'),
    ]

    athlete = models.ForeignKey(CustomUser, related_name='received_transactions', on_delete=models.CASCADE, limit_choices_to={'type_user': 'athlete'})
    donor_sponsor = models.ForeignKey(CustomUser, related_name='sent_transactions', on_delete=models.CASCADE, limit_choices_to={'type_user__in': ['donor', 'sponsor']})
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    transaction_type = models.CharField(max_length=30, choices=TRANSACTION_TYPE_CHOICES)
    date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} -> {self.athlete.username}: {self.amount} ({self.get_transaction_type_display()})"
