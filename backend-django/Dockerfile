# `python-base` sets up all our shared environment variables
FROM python:3.11-slim-bookworm as python-base

    # python
ENV PYTHONUNBUFFERED=1 \
    # prevents python creating .pyc files
    PYTHONDONTWRITEBYTECODE=1 \
    \
    # pip
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    \
    # poetry
    # https://python-poetry.org/docs/configuration/#using-environment-variables
    # POETRY_VERSION=1.0.3 \
    # make poetry install to this location
    POETRY_HOME="/opt/poetry" \
    # make poetry create the virtual environment in the project's root
    # it gets named `.venv`
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    # do not ask any interactive question
    POETRY_NO_INTERACTION=1 \
    \
    # paths
    # this is where our requirements + virtual environment will live
    PYSETUP_PATH="/opt/pysetup" \
    VENV_PATH="/opt/pysetup/.venv"


# prepend poetry and venv to path
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"


# `builder-base` stage is used to build deps + create our virtual environment
FROM python-base as builder-base
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        # deps for installing poetry
        curl \
        # deps for building python deps
        build-essential

# install poetry - respects $POETRY_VERSION & $POETRY_HOME
RUN curl -sSL https://install.python-poetry.org | python

# copy project requirement files here to ensure they will be cached.
WORKDIR $PYSETUP_PATH
COPY poetry.lock pyproject.toml ./

# install runtime deps - uses $POETRY_VIRTUALENVS_IN_PROJECT internally
# RUN poetry install --no-dev # Option --no-dev is deprecated
RUN poetry install

# Create final image
FROM python-base as django-aws

ARG ENVIRONMENT=dev
ARG DJANGO_SUPERUSER_USERNAME
ARG DJANGO_SUPERUSER_PASSWORD
ARG DJANGO_SUPERUSER_EMAIL

ENV ENVIRONMENT=$ENVIRONMENT
ENV DJANGO_SUPERUSER_USERNAME=$DJANGO_SUPERUSER_USERNAME
ENV DJANGO_SUPERUSER_PASSWORD=$DJANGO_SUPERUSER_PASSWORD
ENV DJANGO_SUPERUSER_EMAIL=$DJANGO_SUPERUSER_EMAIL
ENV FASTAPI_ENV=production

COPY --from=builder-base $PYSETUP_PATH $PYSETUP_PATH

# Set work dir and copy app and entrypoint script
WORKDIR /django_aws
COPY ./django_aws /django_aws
RUN rm -f /django_aws/db.sqlite3
COPY ./scripts/entrypoint.sh /django_aws

# Change timezone to ET - America/New_York
RUN rm -rf /etc/localtime \
  && ln -s /usr/share/zoneinfo/America/New_York /etc/localtime

# Create static and media directories
RUN mkdir -p /var/www/django_aws/static \
  && mkdir -p /var/www/django_aws/media

# Collect static files for prod environment
RUN /django_aws/manage.py collectstatic --noinput

# Run entrypoint script
ENTRYPOINT [ "/django_aws/entrypoint.sh" ]
