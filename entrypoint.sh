#!/bin/sh

python manage.py migrate
python manage.py collectstatic --noinput

python manage.py createsuperuser \
  --email "${DJANGO_SUPERUSER_EMAIL}" \
  --noinput || true

python manage.py shell -c "
from conduit.apps.authentication.models import User
user = User.objects.filter(email='${DJANGO_SUPERUSER_EMAIL}').first()
if user:
    user.set_password('${DJANGO_SUPERUSER_PASSWORD}')
    user.is_staff = True
    user.is_superuser = True
    user.save()
"

exec "$@"