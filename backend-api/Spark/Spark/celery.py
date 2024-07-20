from __future__ import absolute_import, unicode_literals
import os
from celery import Celery

# Define o módulo de configurações do Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'Spark.settings')

app = Celery('Spark')

# Carrega as configurações do Celery no arquivo de configurações do Django
app.config_from_object('django.conf:settings', namespace='CELERY')

# Autodiscover tasks em todos os apps Django
app.autodiscover_tasks()