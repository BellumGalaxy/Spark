from django.db import models
from users.models import CustomUser

class Certificate(models.Model):
    athlete = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='certificates')
    title = models.CharField(max_length=100)
    issue_date = models.DateField()
    document = models.FileField(upload_to='certificates/')  # Para armazenar o arquivo do comprovante
    sign_url = models.CharField(max_length=255)

    def __str__(self):
        return f"{self.title} - {self.athlete.username}"