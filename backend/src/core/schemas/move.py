from typing import Literal

from pydantic import BaseModel, Field


class Move(BaseModel):
    from_square: str = Field()
    to_square: str = Field()
    piece: str = Field()
    color: Literal["white", "black"] = Field()
    board: str = Field()
    promotion: str | None = Field(default=None)
