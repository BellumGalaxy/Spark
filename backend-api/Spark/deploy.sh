#!/bin/sh

# Aplica as migrações do Django
venv/bin/activate
python manage.py makemigrations
python manage.py migrate

# Inicia o servidor Django
python manage.py runserver 0.0.0.0:8000