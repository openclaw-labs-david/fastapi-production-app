# FastAPI Production App

A production-ready FastAPI application with modern tooling, testing, and deployment setup.

## Features

- FastAPI with async/await support
- SQLAlchemy with async support
- Alembic database migrations
- Pytest with async support
- Docker containerization
- GitHub Actions CI/CD
- **UV for dependency management** (faster and more reliable)
- Pre-commit hooks for code quality
- OpenAPI documentation with Swagger UI
- JWT authentication
- Environment configuration management

## Quick Start

### Prerequisites

- **Python 3.10+** (required for FastAPI compatibility)
- **UV** (fast Python package manager)
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
uv sync
```

3. Set up environment variables:
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. Initialize the database:
```bash
uv run alembic upgrade head
```

5. Run the application:
```bash
uv run uvicorn app.main:app --reload
```

## Development

### Running Tests

```bash
uv run pytest
```

### Code Quality

```bash
uv run pre-commit run --all-files
```

### Dependency Validation

Validate that uv.lock is properly synced and Dockerfile standards are met:

```bash
# Run comprehensive validation
./scripts/ci_validation.sh

# Python validation script
python scripts/validate_dependencies.py
```

### Database Migrations

Create a new migration:
```bash
uv run alembic revision --autogenerate -m "migration_description"
```

Apply migrations:
```bash
uv run alembic upgrade head
```

## Deployment

### Quick Deployment

Use the automated deployment script:
```bash
./setup-deployment.sh
```

### Docker

```bash
docker-compose up --build
```

### Production Deployment

The application is configured for deployment on:
- **Railway** (Recommended - Free tier)
- **Heroku**
- **Docker containers**
- **Kubernetes**
- **Cloud platforms** (AWS, GCP, Azure)

See the `DEPLOYMENT.md` file for detailed deployment instructions.

### Deployment URLs

Once deployed, your application will be available at:
- Railway: `https://<project-name>.railway.app`
- Heroku: `https://<app-name>.herokuapp.com`

Access points:
- API Documentation: `/docs`
- Health Check: `/health`
- API Base: `/api/v1`

## API Documentation

Once running, access the API documentation:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## Quality Assurance

### Preventing Dependency Mismatches

The project includes comprehensive validation to prevent dependency mismatches:

1. **Pre-commit hooks**: Automatically validate lock file sync on commit
2. **CI/CD validation**: Scripts ensure lock file is properly maintained
3. **Dockerfile standards**: ENV format validation

### Validation Commands

```bash
# Check uv.lock sync
uv sync --check

# Run all validation checks
./scripts/ci_validation.sh

# Install pre-commit hooks
uv run pre-commit install
```

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
├── scripts/            # Validation and utility scripts
│   ├── ci_validation.sh
│   └── validate_dependencies.py
└── docs/              # Additional documentation
```

## Why UV?

This project uses **UV** instead of Poetry for dependency management because:

- **Faster**: UV resolves dependencies significantly faster than Poetry
- **More reliable**: UV has better caching and more predictable behavior
- **Simpler configuration**: UV uses standard pyproject.toml format
- **Better caching**: UV's caching system is more efficient
- **Active development**: UV is actively maintained by the creators of Ruff

## Migrating from Poetry

If you're migrating from Poetry to UV:

1. Remove Poetry files: `rm poetry.lock pyproject.toml` (backup first)
2. Install UV: `curl -LsSf https://astral.sh/uv/install.sh | sh`
3. Generate new lock file: `uv lock`
4. Install dependencies: `uv sync`

All existing functionality remains the same - just replace `poetry run` with `uv run`.