from datetime import datetime

from sqlalchemy import (
    Column,
    Integer,
    String,
    TIMESTAMP,
    LargeBinary,
)

from core.database.db_helper import Base


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True)
    email = Column(String(30), unique=True, nullable=False, index=True)
    username = Column(String(30), nullable=False, index=True)
    password = Column(LargeBinary, nullable=False)
    date_registration = Column(TIMESTAMP, default=datetime.utcnow)
