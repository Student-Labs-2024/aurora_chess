from sqlalchemy import (
    Column,
    Integer,
    ForeignKey,
)

from core.database.db_helper import Base


class Rating(Base):
    __tablename__ = "chess_ratings"

    id = Column(Integer, primary_key=True)
    value = Column(Integer, nullable=False)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False)
