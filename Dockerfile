# Use an official Python runtime as a parent image
FROM python:3.13-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y build-essential libpq-dev curl

# Install Poetry
# RUN curl -sSL https://install.python-poetry.org | python -
RUN pip install poetry==1.8.4

ENV POETRY_VIRTUALENVS_CREATE=false \
    POETRY_VIRTUALENVS_IN_PROJECT=false

# Copy only requirements to cache them in docker layer
WORKDIR /poetry
COPY pyproject.toml poetry.lock ./
RUN poetry install --no-interaction --no-ansi

# Set work directory back to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY app /app/

# Copy the entrypoint script into the container
COPY app/entrypoint.sh /app/entrypoint.sh

# Ensure the entrypoint script has execute permissions
RUN chmod +x /app/entrypoint.sh

# Run the command to start Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
