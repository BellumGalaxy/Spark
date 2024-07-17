from django.urls import path
from .views import EventListCreateView, EventDetailView,EventCreateView

urlpatterns = [
    path('', EventListCreateView.as_view(), name='event-list-create'),
    path('<int:pk>/', EventDetailView.as_view(), name='event-detail'),
    path('create/<int:athlete_id>/', EventCreateView.as_view(), name='event-create'),

]