#!/bin/bash

# FastAPI Production App Setup Script
# This script helps set up the development environment

echo "🚀 Setting up FastAPI Production App..."

# Check if Poetry is installed
if ! command -v poetry &> /dev/null; then
    echo "📦 Installing Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -
    export PATH="$HOME/.local/bin:$PATH"
fi

# Install dependencies
echo "📚 Installing dependencies..."
poetry install

# Set up environment file
if [ ! -f .env ]; then
    echo "⚙️  Creating .env file from template..."
    cp .env.example .env
    echo "⚠️  Please edit .env file with your configuration"
fi

# Initialize database
echo "🗄️  Setting up database..."
poetry run alembic upgrade head

# Install pre-commit hooks
echo "🔧 Installing pre-commit hooks..."
poetry run pre-commit install

echo "✅ Setup complete!"
echo ""
echo "🎯 Next steps:"
echo "1. Edit .env file with your configuration"
echo "2. Run 'poetry run uvicorn app.main:app --reload' to start the server"
echo "3. Visit http://localhost:8000/docs for API documentation"
echo ""
echo "📚 Useful commands:"
echo "- make test       # Run tests"
echo "- make format     # Format code"
echo "- make lint       # Lint code"
echo "- make type-check # Type checking"