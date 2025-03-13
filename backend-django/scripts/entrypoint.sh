#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

# DB Migration
/django_aws/manage.py migrate

# Create superuser using env variable
if [[ -z "$DJANGO_SUPERUSER_USERNAME" || -z "$DJANGO_SUPERUSER_PASSWORD" || -z "$DJANGO_SUPERUSER_EMAIL" ]]
then
    echo "Superuser env variables (DJANGO_SUPERUSER_USERNAME, DJANGO_SUPERUSER_PASSWORD, DJANGO_SUPERUSER_EMAIL) must be set!"
    exit 1
fi

# Run 'createsuperuser' and redirect both STDOUT and STDERR to the 'response' variable
set +e
createsuperuser_result="$(/django_aws/manage.py createsuperuser --no-input 2>&1)"
if [[ $? -eq 0 ]]; then
    echo "SUCCESS: $createsuperuser_result"
else
    echo "WARNING: Superuser creation skipped due to... $createsuperuser_result"
fi
set -e


if [ "$ENVIRONMENT" = "prod" ]; then
    echo "Running in PRODUCTION mode. Starting Gunicorn"
    # echo "Python running from [$( /root/.local/bin/poetry env list --full-path | grep Activated | cut -d' ' -f1 )]"
    # exec /root/.local/bin/poetry run gunicorn -c gunicorn.conf.py

    exec gunicorn \
      --bind 0.0.0.0:8000 \
      --chdir /django_aws/ django_aws.wsgi \
      --reload 

elif [ "$ENVIRONMENT" = "dev" ]; then
    echo "Running in DEVELOPMENT mode"
    # exec /django_aws/manage.py collectstatic --noinput
    exec /django_aws/manage.py runserver 0.0.0.0:8000
else
    echo "ERROR: ENVIRONMENT arg/variable is not set properly!"
    exit 1
fi
