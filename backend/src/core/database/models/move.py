from datetime import datetime

from sqlalchemy import (
    Column,
    Integer,
    String,
    ForeignKey,
)
from sqlalchemy.orm import relationship

from core.database.db_helper import Base


class Move(Base):
    __tablename__ = "moves"

    id = Column(Integer, primary_key=True)
    game_id = Column(Integer, ForeignKey("games.id"), nullable=False)
    move_side = Column(String(5), nullable=False)
    move = Column(String(6), nullable=False)
    piece = Column(String(1), nullable=False)
    promotion = Column(String(1), nullable=True)

    game = relationship("Game", back_populates="moves")
