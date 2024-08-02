from pydantic import BaseModel, Field

from core.schemas.mixins.ErrorsMixin import ErrorsMixin
from core.schemas.mixins.JsonTypeStrMixin import JsonTypeStrMixin
from core.schemas.mixins.SystemMessageMixin import SystemMessagesMixin


class RoomInitResponseData(BaseModel):
    game_type: str = Field(alias="gameType")
    room_name: str = Field(alias="roomName")
    room_init_status: str = Field(alias="roomInitStatus")


class RoomInitResponse(JsonTypeStrMixin, SystemMessagesMixin, ErrorsMixin):
    data: RoomInitResponseData
