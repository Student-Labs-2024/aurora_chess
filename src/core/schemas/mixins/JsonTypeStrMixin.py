from pydantic import BaseModel, Field


class JsonTypeStrMixin(BaseModel):
    json_type: str = Field(alias="jsonType")
