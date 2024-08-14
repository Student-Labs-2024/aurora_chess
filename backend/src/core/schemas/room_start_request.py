from pydantic import BaseModel, Field

from core.schemas.player import Player
from core.schemas.room import Room
from core.schemas.mixins.external_data_mixin import ExternalDataMixin
from core.schemas.mixins.json_type_str_mixin import JsonTypeStrMixin


class RoomStartData(BaseModel):
    game_type: str = Field(alias="gameType")
    room_name: str = Field(alias="roomName")
    player: Player


class RoomStartRequest(JsonTypeStrMixin, ExternalDataMixin):
    data: RoomStartData
