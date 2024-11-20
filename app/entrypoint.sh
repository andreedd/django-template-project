#!/bin/bash

# Wait for the database to be ready
while !</dev/tcp/$POSTGRES_HOST/5432; do
    echo "Waiting for database to become available..."
    sleep 5
done

echo "Database is available. Proceeding with Django setup."

# Run Django migrations
python manage.py migrate --noinput

# Collect static files
python manage.py collectstatic --noinput

# Compile messages, ignoring the env directory
# python manage.py compilemessages --ignore=env

if [ "$DJANGO_DEBUG" = "True" ]; then
    # Start the Django development server
    python manage.py runserver 0.0.0.0:8000
else
    # Start Gunicorn server
    exec gunicorn lokala.wsgi:application --bind 0.0.0.0:8000 --workers 3 --reload
fi
