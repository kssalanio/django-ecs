FROM python:3.11-slim-bookworm

EXPOSE 8000

ARG ENVIRONMENT=dev
ENV ENVIRONMENT=$ENVIRONMENT
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update  \
    && apt-get --no-install-recommends install -y \
        build-essential \
        libssl-dev \
        libcurl4-openssl-dev \
        curl \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip
RUN pip install gunicorn==20.1.0

# COPY requirements.txt /
# RUN pip install --no-cache-dir -r /requirements.txt

# install poetry to manage python dependencies
RUN curl -sSL https://install.python-poetry.org | python3 -

# install python dependencies
# COPY ./pyproject.toml .
# COPY ./poetry.lock .
# RUN /root/.local/bin/poetry install

# copy Django app
# WORKDIR /app
# COPY . /app
WORKDIR /backend-django
COPY . /backend-django
RUN pwd
RUN /root/.local/bin/poetry install

WORKDIR /backend-django/django_aws
ENTRYPOINT [ "/backend-django/scripts/entrypoint.sh" ]