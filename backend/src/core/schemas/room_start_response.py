from pydantic import BaseModel, Field

from core.schemas.mixins.error_mixin import ErrorsMixin
from core.schemas.mixins.json_type_str_mixin import JsonTypeStrMixin
from core.schemas.mixins.system_message_mixin import SystemMessagesMixin
from core.schemas.player import Player


class RoomStartResponseData(BaseModel):
    game_type: str = Field(alias="gameType")
    room_name: str = Field(alias="roomName")
    confirmation_status: str = Field(alias="confirmationStatus")
    board: list[list[str]] | None = Field(alias="board", default=None)
    players: list[Player] | None = Field(alias="players", default=None)


class RoomStartResponse(JsonTypeStrMixin, SystemMessagesMixin, ErrorsMixin):
    data: RoomStartResponseData
