from rest_framework import generics, status
from drf_yasg.utils import swagger_auto_schema
from rest_framework.response import Response
from .models import CustomUser
from .serializer import CustomUserSerializer, ValidateUserSignatureRequestSerializer
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.authtoken.models import Token
from rest_framework.permissions import IsAuthenticated
import requests


class UserListCreateView(generics.ListCreateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer

    def perform_create(self, serializer):
        user = self.request.user # Obtém o usuário autenticado
        serializer.save(user=user)

class UserDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer
    permission_classes = [IsAuthenticated]  # Permissões necessárias

    def perform_create(self, serializer):
        user = self.request.user # Obtém o usuário autenticado
        serializer.save(user=user)
class ValidateUserSignatureView(generics.CreateAPIView):
    """
    View para validar a assinatura digital de um usuário e atualizar o campo user_validated.
    """
    serializer_class = ValidateUserSignatureRequestSerializer
    permission_classes = [IsAuthenticated]  # Permissões necessárias

    def get_queryset(self):
        if getattr(self, 'swagger_fake_view', False):
            return CustomUser.objects.none()
        return CustomUser.objects.all()
    @swagger_auto_schema(request_body=ValidateUserSignatureRequestSerializer)
    def post(self, request, *args, **kwargs):
        try:
            user = CustomUser.objects.get(pk=self.request.user.id)
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            if self.validate_signature(user= user, signature=serializer.validated_data['signature']):
                user.user_validated = True
                user.save()
                return Response({'message': 'User signature validated successfully.'}, status=status.HTTP_200_OK)

            return Response({'message': f'Signature validation failed. For user {self.request.user.id}'}, status=status.HTTP_400_BAD_REQUEST)

        except CustomUser.DoesNotExist:
            return Response({'message': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)
    
    def validate_signature(self, user, signature):
        url = "https://validar.iti.gov.br/url"

        payload = {"url": f"{signature}"}
        headers = {
            "Accept": "/",
            "Accept-Language": "pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7",
            "Connection": "keep-alive",
            "Content-Type": "application/json",
            "Origin": "https://validar.iti.gov.br/",
            "Referer": "https://validar.iti.gov.br/",
            "Sec-Fetch-Dest": "empty",
            "Sec-Fetch-Mode": "cors",
            "Sec-Fetch-Site": "same-origin",
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36",
            "sec-ch-ua": '"Not/A)Brand";v="8", "Chromium";v="126", "Google Chrome";v="126"',
            "sec-ch-ua-mobile": "?0",
            "sec-ch-ua-platform": "Windows"
        }

        response = requests.request("POST", url, json=payload, headers=headers)
        return response.status_code != 200
    
class CustomUserDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer
    lookup_field = 'wallet_id'

    permission_classes = [IsAuthenticated]  # Permissões necessárias

    def perform_create(self, serializer):
        user = self.request.user # Obtém o usuário autenticado
        serializer.save(user=user)


class CustomAuthToken(ObtainAuthToken):
    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        token, created = Token.objects.get_or_create(user=user)
        return Response({'token': token.key})