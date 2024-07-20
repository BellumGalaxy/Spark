from rest_framework import generics, status
from .models import Event
from .serializer import EventSerializer
from rest_framework.response import Response
from users.models import CustomUser

class EventListCreateView(generics.ListCreateAPIView):
    queryset = Event.objects.all()
    serializer_class = EventSerializer

class EventDetailView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Event.objects.all()
    serializer_class = EventSerializer


class EventCreateView(generics.CreateAPIView):
    serializer_class = EventSerializer
    
    def create(self, request, *args, **kwargs):
        athlete_id = self.kwargs.get('athlete_id')
        try:
            user = CustomUser.objects.get(id=athlete_id, type_user='athlete')
        except CustomUser.DoesNotExist:
            return Response({"detail": "Atleta não encontrado ou usuário não é um atleta."}, status=status.HTTP_404_NOT_FOUND)

        data = request.data.copy()
        data['user'] = user.id

        serializer = self.get_serializer(data=data)
        serializer.is_valid(raise_exception=True)
        self.perform_create(serializer)
        headers = self.get_success_headers(serializer.data)
        return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)   