FROM python:3.12-slim

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends ffmpeg \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt requirements-web.txt ./
RUN pip install --no-cache-dir -r requirements.txt -r requirements-web.txt

COPY app.py wsgi.py ./
COPY templates ./templates
COPY languages ./languages
COPY static ./static

ENV PORT=8080 \
    EGM_DEV_MODE=1 \
    FLASK_HOST=0.0.0.0 \
    EGM_ALLOWED_HOSTS=* \
    PYTHONUNBUFFERED=1

EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--threads", "8", "--timeout", "300", "wsgi:app"]
