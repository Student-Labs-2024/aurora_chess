from pydantic import BaseModel, Field


class Square(BaseModel):
    column: int = Field(alias="column")
    row: int = Field(alias="row")


class PlayerMove(BaseModel):
    board: list[list[str]] = Field("board")
    piece: str = Field("piece")
    source: Square = Field(alias="source")
    destination: Square = Field(alias="destination")
    promotion: str | None = Field(alias="promotion", default=None)
