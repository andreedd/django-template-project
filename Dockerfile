# Use an official Python runtime as a parent image
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set work directory in the container
WORKDIR /code

# Install system dependencies
RUN apt-get update && apt-get install -y build-essential libpq-dev curl

# Install Poetry
RUN curl -sSL https://install.python-poetry.org | python -

# Copy only requirements to cache them in docker layer
WORKDIR /poetry
COPY pyproject.toml poetry.lock ./
RUN poetry config virtualenvs.create false \
  && poetry install --no-interaction --no-ansi

# Set work directory back to /code
WORKDIR /code

# Copy the current directory contents into the container at /code
COPY . .

# Run the command to start Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]