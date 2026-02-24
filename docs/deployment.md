# Deployment Guide

## Docker Deployment

### Build and Run

```bash
# Build the Docker image
docker build -t fastapi-production-app .

# Run the container
docker run -p 8000:8000 fastapi-production-app
```

### Docker Compose

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

## Production Environment Variables

Create a `.env` file with production values:

```env
# Security
SECRET_KEY=your-secure-random-key-generated-in-production

# Database (PostgreSQL recommended for production)
POSTGRES_USER=your_production_user
POSTGRES_PASSWORD=your_secure_password
POSTGRES_SERVER=your-database-host
POSTGRES_DB=fastapi_production

# Environment
ENVIRONMENT=production
LOG_LEVEL=WARNING

# CORS (restrict in production)
BACKEND_CORS_ORIGINS=["https://your-domain.com"]
```

## Cloud Deployment

### AWS ECS

1. Create ECR repository
2. Push Docker image
3. Create ECS task definition
4. Configure load balancer

### Google Cloud Run

```bash
# Build and deploy
gcloud builds submit --tag gcr.io/your-project/fastapi-app
gcloud run deploy fastapi-app --image gcr.io/your-project/fastapi-app
```

### Azure Container Instances

```bash
# Build and deploy
az acr build --registry yourregistry --image fastapi-app .
az container create --resource-group your-rg --name fastapi-app --image yourregistry.azurecr.io/fastapi-app --ports 8000
```

## Kubernetes Deployment

See `deployment/kubernetes.yaml` for a sample Kubernetes deployment configuration.

## Monitoring and Logging

### Health Checks

The application includes a health endpoint at `/health` that can be used for load balancer health checks.

### Logging

Configure logging level via `LOG_LEVEL` environment variable:
- `DEBUG`: Detailed debug information
- `INFO`: General operational information
- `WARNING`: Warning messages
- `ERROR`: Error messages

### Performance Monitoring

Consider integrating with:
- Prometheus for metrics
- Grafana for visualization
- Sentry for error tracking