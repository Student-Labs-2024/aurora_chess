from pydantic import BaseModel, Field

from core.schemas.Player import Player
from core.schemas.Room import Room
from core.schemas.mixins.ExternalDataMixin import ExternalDataMixin
from core.schemas.mixins.JsonTypeStrMixin import JsonTypeStrMixin


class RoomConnectionData(BaseModel):
    game_type: str = Field(alias="gameType")
    room: Room
    player: Player


class RoomConnectionRequest(JsonTypeStrMixin, ExternalDataMixin):
    data: RoomConnectionData
