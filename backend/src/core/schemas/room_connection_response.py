from pydantic import BaseModel, Field

from core.schemas.player import Player
from core.schemas.room import Room
from core.schemas.mixins.error_mixin import ErrorsMixin
from core.schemas.mixins.json_type_str_mixin import JsonTypeStrMixin
from core.schemas.mixins.system_message_mixin import SystemMessagesMixin


class Players(BaseModel):
    room_creator: Player | None = Field(alias="roomCreator", default=None)
    connected_player: Player | None = Field(alias="connectedPlayer", default=None)


class RoomConnectionResponseData(BaseModel):
    game_type: str = Field(alias="gameType")
    room: Room
    room_connection_status: str = Field(alias="roomConnectionStatus")
    players: Players


class RoomConnectionResponse(JsonTypeStrMixin, SystemMessagesMixin, ErrorsMixin):
    data: RoomConnectionResponseData
