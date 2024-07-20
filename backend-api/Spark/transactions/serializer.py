from rest_framework import serializers
from .models import Transaction
from users.models import CustomUser
import ipdb
class TransactionSerializer(serializers.ModelSerializer):

    class Meta:
        model = Transaction
        fields = '__all__'
        read_only_fields = ['donor_sponsor']

    def create(self, validated_data):
        sponsor_id = validated_data.pop('donor_sponsor')

        athlete_id = validated_data.pop('athlete')
        donor_sponsor = CustomUser.objects.get(id=sponsor_id.id)
        athlete = CustomUser.objects.get(id=athlete_id.id)
        transaction = Transaction.objects.create(donor_sponsor=donor_sponsor, athlete=athlete, **validated_data)
        return transaction