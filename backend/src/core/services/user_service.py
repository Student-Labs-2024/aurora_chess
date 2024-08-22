from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

import core.schemas.user as schemas
from core.database.models.user import User


async def get_user(db: AsyncSession, user_id: int) -> schemas.User | None:
    stmt = select(User).where(User.id == user_id)
    result = await db.execute(stmt)
    user: User | None = result.scalar_one_or_none()
    return user


async def get_user_by_email(db: AsyncSession, email: str) -> schemas.User | None:
    stmt = select(User).where(User.email == email)
    result = await db.execute(stmt)
    user: User | None = result.scalar_one_or_none()
    return user


async def create_user(db: AsyncSession, user: schemas.UserCreate) -> schemas.User:
    db_user = User(**user.model_dump())
    db.add(db_user)
    await db.commit()
    await db.refresh(db_user)
    return db_user
