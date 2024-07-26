from typing import Literal

from pydantic import BaseModel, Field


class Player(BaseModel):
    player_name: str = Field(alias="playerName")
    player_side: Literal["white", "black"] = Field(alias="playerSide")
