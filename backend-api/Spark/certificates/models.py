from django.db import models
from users.models import CustomUser

class Certificate(models.Model):
    athlete = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='certificates')
    title = models.CharField(max_length=100)
    issue_date = models.DateTimeField(auto_now_add=True)
    document = models.CharField(max_length=255)  # Para armazenar o arquivo do comprovante
    sign_url = models.CharField(max_length=255)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    def __str__(self):
        return f"{self.title} - {self.athlete.username}"