from rest_framework import generics
from .models import Certificate
from .serializer import CertificateSerializer
from rest_framework.permissions import IsAuthenticated


class CertificateListCreateView(generics.ListCreateAPIView):
    queryset = Certificate.objects.all()
    serializer_class = CertificateSerializer
    permission_classes = [IsAuthenticated]  # Permissões necessárias

    def perform_create(self, serializer):
        user = self.request.user # Obtém o usuário autenticado
        serializer.save(athlete=user)

class CertificateDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Certificate.objects.all()
    serializer_class = CertificateSerializer
    permission_classes = [IsAuthenticated]  # Permissões necessárias

    def perform_create(self, serializer):
        user = self.request.user # Obtém o usuário autenticado
        serializer.save(athlete=user)