from pydantic import BaseModel, Field

from core.schemas.mixins.error_mixin import ErrorsMixin
from core.schemas.mixins.json_type_str_mixin import JsonTypeStrMixin
from core.schemas.mixins.system_message_mixin import SystemMessagesMixin


class RoomInitResponseData(BaseModel):
    game_type: str = Field(alias="gameType")
    room_name: str = Field(alias="roomName")
    room_init_status: str = Field(alias="roomInitStatus")


class RoomInitResponse(JsonTypeStrMixin, SystemMessagesMixin, ErrorsMixin):
    data: RoomInitResponseData
