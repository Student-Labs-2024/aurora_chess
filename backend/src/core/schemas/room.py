from pydantic import BaseModel, Field


class Room(BaseModel):
    room_name: str = Field(alias="roomName")
