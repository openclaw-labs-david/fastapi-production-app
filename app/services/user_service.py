from typing import Optional

from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select

from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate
from app.services.auth_service import get_password_hash


async def create_user(db: AsyncSession, user: UserCreate) -> User:
    """Create a new user"""
    hashed_password = get_password_hash(user.password)
    db_user = User(
        email=user.email,
        hashed_password=hashed_password,
        full_name=user.full_name,
    )
    db.add(db_user)
    await db.commit()
    await db.refresh(db_user)
    return db_user


async def get_user(db: AsyncSession, user_id: int) -> Optional[User]:
    """Get user by ID"""
    result = await db.execute(select(User).where(User.id == user_id))
    return result.scalar_one_or_none()


async def get_user_by_email(db: AsyncSession, email: str) -> Optional[User]:
    """Get user by email"""
    result = await db.execute(select(User).where(User.email == email))
    return result.scalar_one_or_none()


async def get_users(
    db: AsyncSession, skip: int = 0, limit: int = 100
) -> list[User]:
    """Get multiple users"""
    result = await db.execute(select(User).offset(skip).limit(limit))
    return list(result.scalars().all())


async def update_user(
    db: AsyncSession, user_id: int, user_update: UserUpdate
) -> Optional[User]:
    """Update user"""
    db_user = await get_user(db, user_id)
    if not db_user:
        return None

    update_data = user_update.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_user, field, value)

    await db.commit()
    await db.refresh(db_user)
    return db_user


async def delete_user(db: AsyncSession, user_id: int) -> bool:
    """Delete user"""
    db_user = await get_user(db, user_id)
    if not db_user:
        return False

    await db.delete(db_user)
    await db.commit()
    return True
