# Deployment Pipeline

This document describes the automated deployment pipeline for the FastAPI Production App.

## Supported Platforms

- **Railway** (Recommended - Free tier available)
- **Heroku** (Alternative)
- **Docker** (Any container platform)

## Quick Deployment (Railway)

### Prerequisites

1. [Railway account](https://railway.app)
2. [GitHub account](https://github.com)
3. Railway CLI (optional): `npm install -g @railway/cli`

### Automated Deployment

1. **Connect GitHub Repository**
   - Fork this repository to your GitHub account
   - Go to [Railway](https://railway.app) and create a new project
   - Connect your GitHub repository

2. **Configure Environment Variables**
   - In Railway dashboard, go to "Variables" tab
   - Add the following variables:
     ```
     SECRET_KEY=generate-a-secure-random-key
     ENVIRONMENT=production
     LOG_LEVEL=INFO
     ```

3. **Deploy**
   - Railway will automatically deploy on git push
   - Or use the CLI: `railway deploy`

### Manual Deployment

```bash
# Clone the repository
git clone <your-repository-url>
cd fastapi-production-app

# Install Railway CLI
npm install -g @railway/cli

# Login and deploy
railway login
railway init
railway deploy

# Run database migrations
railway run poetry run alembic upgrade head
```

## Environment Configuration

### Required Environment Variables

```env
# Security
SECRET_KEY=your-secure-random-key
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Application
ENVIRONMENT=production
LOG_LEVEL=INFO
API_V1_STR=/api/v1
PROJECT_NAME=FastAPI Production App

# CORS
BACKEND_CORS_ORIGINS=["*"]
```

### Database Configuration

Railway automatically provides PostgreSQL with `DATABASE_URL` environment variable.

## CI/CD Pipeline

The GitHub Actions workflow (`/.github/workflows/ci.yml`) provides:

- ✅ Automated testing on Python 3.9, 3.10, 3.11
- ✅ Code linting and formatting checks
- ✅ Type checking with MyPy
- ✅ Docker image building
- ✅ Automatic deployment to Railway on main branch

## Monitoring & Logging

### Built-in Features

- **Health Check**: `GET /health` endpoint
- **Structured Logging**: JSON-formatted logs
- **Error Tracking**: Automatic error reporting
- **Performance Monitoring**: Request timing and metrics

### Railway Monitoring

- Real-time application logs
- Resource usage monitoring
- Automatic scaling
- SSL/TLS certificates

## Security Best Practices

### ✅ Implemented

- Environment variable configuration
- JWT token authentication
- CORS configuration
- SQL injection prevention (SQLAlchemy)
- Input validation (Pydantic)
- Secure headers (FastAPI)

### 🔧 Configuration Required

- Set strong `SECRET_KEY` in production
- Configure proper CORS origins
- Enable HTTPS/SSL
- Set up database backups

## Performance Optimization

### ✅ Implemented

- Async/await support
- Database connection pooling
- Gzip compression
- CORS preflight optimization

### 🚀 Additional Optimizations

- CDN for static assets
- Database query optimization
- Caching layer (Redis)
- Load balancing

## Database Migrations

Alembic migrations are automatically applied on deployment:

```bash
# Create new migration
poetry run alembic revision --autogenerate -m "description"

# Apply migrations
poetry run alembic upgrade head
```

## Health Checks

The application includes health check endpoints:

- `GET /health` - Basic application health
- `GET /` - Root endpoint with status

## SSL/TLS Configuration

Railway automatically provides:
- Free SSL certificates
- Automatic certificate renewal
- HTTPS redirect
- HSTS headers

## Deployment URL

Once deployed, your application will be available at:
- `https://<your-project-name>.railway.app`
- API Documentation: `https://<your-project-name>.railway.app/docs`
- Health Check: `https://<your-project-name>.railway.app/health`

## Troubleshooting

### Common Issues

1. **Database Connection Errors**
   - Check `DATABASE_URL` environment variable
   - Verify PostgreSQL service is running

2. **Build Failures**
   - Check Poetry dependency resolution
   - Verify Python version compatibility

3. **Application Errors**
   - Check Railway logs: `railway logs`
   - Verify environment variables

### Getting Help

- Check Railway documentation: https://docs.railway.app
- Review application logs: `railway logs`
- Open an issue in the GitHub repository

## Next Steps

After successful deployment:

1. **Configure Domain** (Optional)
   - Add custom domain in Railway dashboard
   - Configure DNS records

2. **Set Up Monitoring**
   - Configure alerts and notifications
   - Set up performance monitoring

3. **Database Backups**
   - Configure automatic backups
   - Test recovery procedures

4. **Scale Resources**
   - Monitor resource usage
   - Scale up as needed