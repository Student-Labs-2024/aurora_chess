from pydantic import BaseModel, Field


class Error(BaseModel):
    error_type: str = Field(alias="errorType")
    error_message: str = Field(alias="errorMessage")


class ErrorsMixin(BaseModel):
    errors: list[Error] | None = None
