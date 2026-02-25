import pytest


@pytest.mark.asyncio
async def test_create_user(client, test_db):
    """Test user creation"""
    user_data = {
        "email": "test@example.com",
        "password": "testpassword",
        "full_name": "Test User",
    }

    response = client.post("/api/v1/users/", json=user_data)
    assert response.status_code == 200
    data = response.json()
    assert data["email"] == "test@example.com"
    assert data["full_name"] == "Test User"
    assert "id" in data


@pytest.mark.asyncio
async def test_get_user(client, test_db):
    """Test getting a user"""
    # First create a user
    user_data = {
        "email": "get@example.com",
        "password": "password",
        "full_name": "Get User",
    }
    create_response = client.post("/api/v1/users/", json=user_data)
    user_id = create_response.json()["id"]

    # Then get the user
    response = client.get(f"/api/v1/users/{user_id}")
    assert response.status_code == 200
    data = response.json()
    assert data["id"] == user_id
    assert data["email"] == "get@example.com"


@pytest.mark.asyncio
async def test_get_nonexistent_user(client, test_db):
    """Test getting a non-existent user"""
    response = client.get("/api/v1/users/999")
    assert response.status_code == 404


@pytest.mark.asyncio
async def test_get_users(client, test_db):
    """Test getting multiple users"""
    # Create some users
    for i in range(3):
        user_data = {
            "email": f"user{i}@example.com",
            "password": "password",
            "full_name": f"User {i}",
        }
        client.post("/api/v1/users/", json=user_data)

    response = client.get("/api/v1/users/")
    assert response.status_code == 200
    data = response.json()
    assert len(data) == 3
