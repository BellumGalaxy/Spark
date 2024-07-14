from celery import shared_task
from .models import Transaction
from certificates.models import Certificate
from datetime import datetime, timedelta

@shared_task
def check_certificates():
    # Obter a data de um mês atrás
    one_month_ago = datetime.now() - timedelta(days=30)

    # Obter todas as transações dos últimos 30 dias
    recent_transactions = Transaction.objects.filter(date__gte=one_month_ago)

    for transaction in recent_transactions:
        athlete = transaction.athlete

        # Verificar se o atleta enviou algum comprovante após a data do patrocínio/doação
        certificates = Certificate.objects.filter(user=athlete, date__gte=transaction.date)

        if not certificates.exists():
            print(f"O atleta {athlete.username} não enviou comprovantes para a transação de {transaction.amount} feita por {transaction.user.username}.")