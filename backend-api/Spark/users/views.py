from rest_framework import generics, status
from drf_yasg.utils import swagger_auto_schema
from rest_framework.response import Response
from .models import CustomUser
from .serializer import CustomUserSerializer, ValidateUserSignatureRequestSerializer
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.authtoken.models import Token



class UserListCreateView(generics.ListCreateAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer

class UserDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer

class ValidateUserSignatureView(generics.CreateAPIView):
    """
    View para validar a assinatura digital de um usuário e atualizar o campo user_validated.
    """
    serializer_class = ValidateUserSignatureRequestSerializer

    def get_queryset(self):
        if getattr(self, 'swagger_fake_view', False):
            return CustomUser.objects.none()
        return CustomUser.objects.all()
    @swagger_auto_schema(request_body=ValidateUserSignatureRequestSerializer)
    def post(self, request, *args, **kwargs):
        user_id = kwargs.get('pk')
        try:
            user = CustomUser.objects.get(pk=user_id)
            serializer = self.get_serializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            if self.validate_signature(user= user, signature=serializer.validated_data['signature']):
                user.user_validated = True
                user.save()
                return Response({'message': 'User signature validated successfully.'}, status=status.HTTP_200_OK)

            return Response({'message': 'Signature validation failed.'}, status=status.HTTP_400_BAD_REQUEST)

        except CustomUser.DoesNotExist:
            return Response({'message': 'User not found.'}, status=status.HTTP_404_NOT_FOUND)
    
    def validate_signature(self, user, signature):
        # Aqui você deve implementar a lógica de validação da assinatura digital com a Receita
        # Retorne True se validado, caso contrário False
        return True  # Substitua pela lógica real
    
class CustomUserDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer
    lookup_field = 'wallet_id'


class CustomAuthToken(ObtainAuthToken):
    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        token, created = Token.objects.get_or_create(user=user)
        return Response({'token': token.key})