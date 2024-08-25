from datetime import datetime
from typing import List

from sqlalchemy import (
    Column,
    Integer,
    String,
    TIMESTAMP,
    ForeignKey,
)
from sqlalchemy.orm import Mapped, relationship

from core.database.db_helper import Base
from core.database.models.move import Move


class Game(Base):
    __tablename__ = "games"

    id = Column(Integer, primary_key=True)
    game_type = Column(String(16), nullable=False)
    result = Column(String(8), default="")
    player_white_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    player_black_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    start_time = Column(TIMESTAMP, default=datetime.utcnow)
    end_time = Column(TIMESTAMP, nullable=True)

    moves: Mapped[List["Move"]] = relationship(
        "Move",
        back_populates="game",
        lazy="selectin",
        cascade="all, delete",
        passive_deletes=True,
    )
