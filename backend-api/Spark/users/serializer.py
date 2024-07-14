from rest_framework import serializers
from .models import CustomUser
from django.contrib.auth.hashers import make_password


class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = '__all__'
        extra_kwargs = {
            'password': {'write_only': True}  # Não incluir no retorno da API
        }

        read_only = ["id", "is_superuser", "created_at", "updated_at"]
        extra_kwargs = {"password": {"write_only": True}}

    def create(self, validated_data):
        return CustomUser.objects.create_user(**validated_data)
class ValidateUserSignatureRequestSerializer(serializers.Serializer):
    signature = serializers.CharField(required=True)