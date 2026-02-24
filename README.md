# FastAPI Production App

A production-ready FastAPI application with modern tooling, testing, and deployment setup.

## Features

- FastAPI with async/await support
- SQLAlchemy with async support
- Alembic database migrations
- Pytest with async support
- Docker containerization
- GitHub Actions CI/CD
- Poetry for dependency management
- Pre-commit hooks for code quality
- OpenAPI documentation with Swagger UI
- JWT authentication
- Environment configuration management

## Quick Start

### Prerequisites

- Python 3.9+
- Poetry
- Docker & Docker Compose
- PostgreSQL (optional, SQLite for development)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd fastapi-production-app
```

2. Install dependencies:
```bash
poetry install
```

3. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. Initialize the database:
```bash
poetry run alembic upgrade head
```

5. Run the application:
```bash
poetry run uvicorn app.main:app --reload
```

## Development

### Running Tests

```bash
poetry run pytest
```

### Code Quality

```bash
poetry run pre-commit run --all-files
```

### Database Migrations

Create a new migration:
```bash
poetry run alembic revision --autogenerate -m "migration_description"
```

Apply migrations:
```bash
poetry run alembic upgrade head
```

## Deployment

### Docker

```bash
docker-compose up --build
```

### Production Deployment

The application is configured for deployment on:
- Docker containers
- Kubernetes
- Cloud platforms (AWS, GCP, Azure)

See the `deployment/` directory for specific deployment configurations.

## API Documentation

Once running, access the API documentation:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Project Structure

```
fastapi-production-app/
├── app/                 # Application code
│   ├── api/            # API routes
│   ├── core/           # Core configurations
│   ├── models/         # Database models
│   ├── schemas/        # Pydantic schemas
│   └── services/       # Business logic
├── tests/              # Test suite
├── alembic/            # Database migrations
├── deployment/         # Deployment configurations
└── docs/              # Additional documentation
```