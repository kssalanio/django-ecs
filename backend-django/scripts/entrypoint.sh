#!/bin/sh

if [ "$ENVIRONMENT" = "prod" ]; then
    echo "Running in PRODUCTION mode. Starting Gunicorn"
    echo "Python running from [$( /root/.local/bin/poetry env list --full-path | grep Activated | cut -d' ' -f1 )]"
    # exec /root/.local/bin/poetry run gunicorn -c gunicorn.conf.py
    exec gunicorn \
      --bind 0.0.0.0:8000 \
      --chdir /django_aws/ django_aws.wsgi \
      --reload 

elif [ "$ENVIRONMENT" = "dev" ]; then
    echo "Running in DEVELOPMENT mode"
    # exec /root/.local/bin/poetry run /backend-django/django_aws/manage.py collectstatic --noinput
    exec /django_aws/manage.py runserver 0.0.0.0:8000
else
    echo "ERROR: ENVIRONMENT arg/variable is not set properly!"
    exit 1
fi
