FROM python:3.11.4


ENV PYTHONDONTWRITEBYTECODE 1

ENV \
  PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  build-essential \
  gettext \
  libpq-dev \
  wget && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY ./requirements.txt .

RUN pip install -r requirements.txt

COPY . .

# Setting up proper permissions:

# RUN mkdir -p /app/media /app/static

CMD ["sh", "-c", "uvicorn src.main:app --reload --host 0.0.0.0 --port 8000 --log-level ${APP_LOGLEVEL:-info} --use-colors"]
