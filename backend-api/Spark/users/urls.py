from django.urls import path
from .views import UserListCreateView, UserDetailView, ValidateUserSignatureView, CustomUserDetailView, CustomAuthToken, AthleteListView
from rest_framework.authtoken.views import obtain_auth_token

urlpatterns = [
    path('', UserListCreateView.as_view(), name='user-list-create'),
    path('<int:pk>/', UserDetailView.as_view(), name='user-detail'),
    path('validate-signature/', ValidateUserSignatureView.as_view(), name='validate-signature'),
    path("login/", CustomAuthToken.as_view()),
    path('user/<str:wallet_id>/', CustomUserDetailView.as_view(), name='customuser-detail'),
    path('athletes/', AthleteListView.as_view(), name='athlete-list'),

]