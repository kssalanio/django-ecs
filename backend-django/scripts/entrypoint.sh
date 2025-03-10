#!/bin/sh

if [ "$ENVIRONMENT" = "prod" ]; then
    echo "Running in PRODUCTION mode"
    exec /root/.local/bin/poetry run gunicorn -c gunicorn.conf.py
elif [ "$ENVIRONMENT" = "dev" ]; then
    echo "Running in DEVELOPMENT mode"
    # exec /root/.local/bin/poetry run /backend-django/django_aws/manage.py collectstatic --noinput
    exec /root/.local/bin/poetry run /backend-django/django_aws/manage.py runserver 0.0.0.0:8000
else
    echo "ERROR: ENVIRONMENT arg/variable is not set properly!"
    exit 1
fi
