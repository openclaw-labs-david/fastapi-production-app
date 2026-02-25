#!/bin/bash

# FastAPI Production App Deployment Script
# This script automates deployment to Railway

set -e

echo "🚀 Starting FastAPI Production App deployment..."

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found. Installing..."
    npm install -g @railway/cli
fi

# Login to Railway (if not already logged in)
if ! railway whoami &> /dev/null; then
    echo "🔐 Please log in to Railway..."
    railway login
fi

# Create project if it doesn't exist
if ! railway status &> /dev/null; then
    echo "📦 Creating new Railway project..."
    railway init
fi

# Deploy the application
echo "🚀 Deploying to Railway..."
railway deploy

echo "✅ Deployment complete!"
echo "📊 Check deployment status: railway logs"
echo "🌐 Your app will be available at: railway status | grep -o 'https://[^ ]*'"

# Run database migrations
echo "🗄️ Running database migrations..."
railway run uv run alembic upgrade head

echo "🎉 Deployment successful!"
echo "📋 Next steps:"
echo "   - Configure environment variables in Railway dashboard"
echo "   - Set up custom domain (optional)"
echo "   - Configure SSL/TLS certificates"
echo "   - Set up monitoring and alerts"