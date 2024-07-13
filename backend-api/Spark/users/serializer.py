from rest_framework import serializers
from .models import CustomUser

class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['id', 'username', 'email', 'type_user', 'bio', 'location', 'birth_date']

class ValidateUserSignatureRequestSerializer(serializers.Serializer):
    signature = serializers.CharField(required=True)