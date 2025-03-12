#!/bin/sh

if [ "$ENVIRONMENT" = "prod" ]; then
    echo "Running in PRODUCTION mode. Starting Gunicorn"
    echo "Python running from [$( /root/.local/bin/poetry env list --full-path | grep Activated | cut -d' ' -f1 )]"
    # exec /root/.local/bin/poetry run gunicorn -c gunicorn.conf.py
    exec gunicorn \
      --bind 0.0.0.0:8000 \
      --chdir /django_aws/ django_aws.wsgi \
      --reload 

    # exec gunicorn \
    #   --log-level debug \
    #   --capture-output \
    #   --enable-stdio-inheritance \
    #   --workers 5 \
    #   --timeout 300 \
    #   --max-requests 10000 \
    #   --reload django_aws.wsgi:application \
    #   --bind 0.0.0.0:8000 
elif [ "$ENVIRONMENT" = "dev" ]; then
    echo "Running in DEVELOPMENT mode"
    # exec /root/.local/bin/poetry run /backend-django/django_aws/manage.py collectstatic --noinput
    exec /root/.local/bin/poetry run /django_aws/manage.py runserver 0.0.0.0:8000
else
    echo "ERROR: ENVIRONMENT arg/variable is not set properly!"
    exit 1
fi

# gunicorn --bind 0.0.0.0:8000 --chdir /backend-django/django_aws/django_aws/ --reload django_aws.wsgi:application