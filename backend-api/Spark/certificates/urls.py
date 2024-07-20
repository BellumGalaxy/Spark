from django.urls import path
from .views import CertificateListCreateView, CertificateDetailView

urlpatterns = [
    path('', CertificateListCreateView.as_view(), name='certificate-list-create'),
    path('<int:pk>/', CertificateDetailView.as_view(), name='certificate-detail'),
]