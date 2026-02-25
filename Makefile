.PHONY: install test lint format type-check pre-commit docker-build docker-run migrate

# Install dependencies
install:
	uv sync

# Run tests
test:
	uv run pytest

# Run linting
lint:
	uv run flake8 app tests

# Format code
format:
	uv run black app tests
	uv run isort app tests

# Type checking
type-check:
	uv run mypy app

# Run pre-commit hooks
pre-commit:
	uv run pre-commit run --all-files

# Build Docker image
docker-build:
	docker build -t fastapi-production-app .

# Run Docker container
docker-run:
	docker run -p 8000:8000 fastapi-production-app

# Run database migrations
migrate:
	uv run alembic upgrade head

# Create new migration
migration:
	uv run alembic revision --autogenerate -m "$(name)"

# Development server
dev:
	uv run uvicorn app.main:app --reload

# Production server
prod:
	uv run uvicorn app.main:app --host 0.0.0.0 --port 8000