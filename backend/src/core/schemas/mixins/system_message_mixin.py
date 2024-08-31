from datetime import datetime

from pydantic import BaseModel, Field


class SystemMessage(BaseModel):
    occurence_time: datetime = Field(alias="occurenceTime")
    message_origin: str = Field(alias="messageOrigin")
    message_test: str = Field(alias="messageText")


class SystemMessagesMixin(BaseModel):
    system_messages: list[SystemMessage] | None = None
