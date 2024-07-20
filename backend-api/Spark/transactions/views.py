from rest_framework import generics, permissions
from .models import Transaction
from .serializer import TransactionSerializer
from rest_framework.permissions import IsAuthenticated

class TransactionListCreateView(generics.ListCreateAPIView):
    queryset = Transaction.objects.all()
    serializer_class = TransactionSerializer
    permission_classes = [IsAuthenticated]  # Permissões necessárias

    def perform_create(self, serializer):
        user = self.request.user # Obtém o usuário autenticado
        serializer.save(donor_sponsor=user)