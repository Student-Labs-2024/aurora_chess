from datetime import datetime

from pydantic import BaseModel, Field


class ExternalData(BaseModel):
    dispatch_time: datetime = Field(alias="dispatchTime")
    messages: str


class ExternalDataMixin(BaseModel):
    external_data: list[ExternalData] = None
