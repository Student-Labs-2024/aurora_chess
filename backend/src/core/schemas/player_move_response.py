from pydantic import BaseModel, Field

from core.schemas.player import Player
from core.schemas.player_move import PlayerMove
from core.schemas.mixins.error_mixin import ErrorsMixin
from core.schemas.mixins.json_type_str_mixin import JsonTypeStrMixin
from core.schemas.mixins.system_message_mixin import SystemMessagesMixin


class PlayerMoveResponseData(BaseModel):
    confirmation_status: str = Field(alias="confirmationStatus")
    player: Player
    player_move: PlayerMove = Field(alias="playerMove")
    game_status: str | None = Field(alias="gameStatus", default=None)
    game_type: str = Field(alias="gameType")
    room_name: str = Field(alias="roomName")


class PlayerMoveResponse(JsonTypeStrMixin, SystemMessagesMixin, ErrorsMixin):
    data: PlayerMoveResponseData
