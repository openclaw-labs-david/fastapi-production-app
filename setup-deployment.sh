#!/bin/bash

# FastAPI Production App - Deployment Setup Script
# This script helps you deploy to Railway or Heroku

set -e

echo "🚀 FastAPI Production App Deployment Setup"
echo "============================================"

# Check if we're in the right directory
if [ ! -f "pyproject.toml" ]; then
    echo "❌ Error: Please run this script from the fastapi-production-app directory"
    exit 1
fi

echo "📋 Available deployment options:"
echo "1. Railway (Recommended - Free tier)"
echo "2. Heroku"
echo "3. Docker (Manual deployment)"

read -p "🔢 Choose deployment option (1-3): " choice

case $choice in
    1)
        echo "🚇 Setting up Railway deployment..."
        
        # Check if Railway CLI is installed
        if ! command -v railway &> /dev/null; then
            echo "📦 Installing Railway CLI..."
            npm install -g @railway/cli
        fi
        
        # Login to Railway
        echo "🔐 Please log in to Railway..."
        railway login
        
        # Create project
        echo "📦 Creating Railway project..."
        railway init
        
        # Deploy
        echo "🚀 Deploying to Railway..."
        railway deploy
        
        # Get deployment URL
        echo "🌐 Getting deployment URL..."
        url=$(railway status | grep -o 'https://[^ ]*' | head -1)
        echo "✅ Your app is deployed at: $url"
        
        # Run migrations
        echo "🗄️ Running database migrations..."
        railway run uv run alembic upgrade head
        
        echo "🎉 Railway deployment complete!"
        echo "📊 Check logs: railway logs"
        echo "⚙️ Configure variables: railway variables"
        ;;
    
    2)
        echo "🚀 Setting up Heroku deployment..."
        
        # Check if Heroku CLI is installed
        if ! command -v heroku &> /dev/null; then
            echo "❌ Heroku CLI not found. Please install it first:"
            echo "   Visit: https://devcenter.heroku.com/articles/heroku-cli"
            exit 1
        fi
        
        # Login to Heroku
        echo "🔐 Please log in to Heroku..."
        heroku login
        
        # Create app
        read -p "📛 Enter Heroku app name (or press enter for auto-generated): " app_name
        if [ -z "$app_name" ]; then
            heroku create
        else
            heroku create "$app_name"
        fi
        
        # Deploy
        echo "🚀 Deploying to Heroku..."
        git push heroku main
        
        # Run migrations
        echo "🗄️ Running database migrations..."
        heroku run uv run alembic upgrade head
        
        # Open app
        heroku open
        
        echo "🎉 Heroku deployment complete!"
        ;;
    
    3)
        echo "🐳 Setting up Docker deployment..."
        
        # Build Docker image
        echo "🔨 Building Docker image..."
        docker build -t fastapi-production-app .
        
        # Run container
        echo "🚀 Running Docker container..."
        docker run -d -p 8000:8000 --name fastapi-app fastapi-production-app
        
        echo "🎉 Docker deployment complete!"
        echo "🌐 Access your app at: http://localhost:8000"
        echo "📊 Check logs: docker logs fastapi-app"
        ;;
    
    *)
        echo "❌ Invalid choice. Please run the script again."
        exit 1
        ;;
esac

echo ""
echo "📋 Next steps:"
echo "1. Configure environment variables"
echo "2. Test the deployed application"
echo "3. Set up monitoring and alerts"
echo "4. Configure custom domain (optional)"
echo ""
echo "📚 Documentation:"
echo "- Deployment guide: DEPLOYMENT.md"
echo "- Railway docs: https://docs.railway.app"
echo "- Heroku docs: https://devcenter.heroku.com"
echo ""
echo "🎉 Your FastAPI app is ready for production!"