from django.urls import path
from .views import UserListCreateView, UserDetailView, ValidateUserSignatureView

urlpatterns = [
    path('', UserListCreateView.as_view(), name='user-list-create'),
    path('<int:pk>/', UserDetailView.as_view(), name='user-detail'),
    path('<int:pk>/validate-signature/', ValidateUserSignatureView.as_view(), name='validate-signature'),

]