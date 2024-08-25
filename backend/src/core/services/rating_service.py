from pydantic import BaseModel
from sqlalchemy import select, update
from sqlalchemy.ext.asyncio import AsyncSession

from core.database.models.rating import Rating


class RatingSchema(BaseModel):
    id: int = None
    value: int
    user_id: int


async def create_rating(db: AsyncSession, rating: RatingSchema) -> RatingSchema:
    db_rating = Rating(**rating.model_dump())
    db.add(db_rating)
    await db.commit()
    await db.refresh(db_rating)
    return RatingSchema.model_validate(db_rating)


async def get_rating(db: AsyncSession, rating_id: int) -> RatingSchema | None:
    stmt = select(Rating).where(Rating.id == rating_id)
    result = await db.execute(stmt)
    db_rating: Rating | None = result.scalar_one_or_none()
    if db_rating:
        return RatingSchema.model_validate(db_rating)


async def get_rating_by_user_id(db: AsyncSession, user_id: int) -> RatingSchema:
    stmt = select(Rating).where(Rating.user_id == user_id)
    result = await db.execute(stmt)
    db_rating: Rating | None = result.scalar_one_or_none()
    if db_rating:
        return RatingSchema.model_validate(db_rating)
    else:
        return await create_rating(
            db, RatingSchema.model_validate({"value": 1000, "user_id": user_id})
        )


async def update_rating_by_user_id(db: AsyncSession, user_id: int, rating):
    stmt = update(Rating).where(Rating.user_id == user_id).values(value=rating)
    await db.execute(stmt)
