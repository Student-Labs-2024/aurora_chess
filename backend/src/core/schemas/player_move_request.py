from pydantic import BaseModel, Field

from core.schemas.player import Player
from core.schemas.player_move import PlayerMove
from core.schemas.mixins.external_data_mixin import ExternalDataMixin
from core.schemas.mixins.json_type_str_mixin import JsonTypeStrMixin


class PlayerMoveRequestData(BaseModel):
    game_type: str = Field(alias="gameType")
    room_name: str = Field(alias="roomName")
    player: Player
    player_move: PlayerMove = Field(alias="playerMove")


class PlayerMoveRequest(JsonTypeStrMixin, ExternalDataMixin):
    data: PlayerMoveRequestData
