.PHONY: install test lint format type-check pre-commit docker-build docker-run migrate

# Install dependencies
install:
	poetry install

# Run tests
test:
	poetry run pytest

# Run linting
lint:
	poetry run flake8 app tests

# Format code
format:
	poetry run black app tests
	poetry run isort app tests

# Type checking
type-check:
	poetry run mypy app

# Run pre-commit hooks
pre-commit:
	poetry run pre-commit run --all-files

# Build Docker image
docker-build:
	docker build -t fastapi-production-app .

# Run Docker container
docker-run:
	docker run -p 8000:8000 fastapi-production-app

# Run database migrations
migrate:
	poetry run alembic upgrade head

# Create new migration
migration:
	poetry run alembic revision --autogenerate -m "$(name)"

# Development server
dev:
	poetry run uvicorn app.main:app --reload

# Production server
prod:
	poetry run uvicorn app.main:app --host 0.0.0.0 --port 8000