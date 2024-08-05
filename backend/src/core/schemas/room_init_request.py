from pydantic import BaseModel, Field

from core.schemas.player import Player
from core.schemas.room import Room
from core.schemas.mixins.external_data_mixin import ExternalDataMixin
from core.schemas.mixins.json_type_str_mixin import JsonTypeStrMixin


class RoomInitData(BaseModel):
    game_type: str = Field(alias="gameType")
    room: Room
    player: Player


class RoomInitRequest(JsonTypeStrMixin, ExternalDataMixin):
    data: RoomInitData
