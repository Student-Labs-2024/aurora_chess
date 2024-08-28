from typing import Literal

from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession

from core.database.models.game import Game
from core.repository.room_repository.abstract_room_repository import (
    AbstractRoomRepository,
)


class MoveSchema(BaseModel):
    id: int
    game_id: int
    move_side: Literal["b", "w"]
    move: str
    piece: str
    promotion: str


class GameSchema(BaseModel):
    id: int | None = None
    game_type: str
    player_white_id: int = None
    player_black_id: int = None
    result: Literal["", "*", "1-0", "0-1", "1/2-1/2"] = ""
    board: str = None

    moves: list[MoveSchema] | None = None

    def is_full(self):
        return self.player_black and self.player_white

    def is_active(self):
        return self.result

    def start_game(self):
        if not self.result:
            self.result = "*"


class RoomService:
    def __init__(self, game_room_repository):
        self.__game_room_repository: AbstractRoomRepository = game_room_repository

    async def create_room(self, room: GameSchema, room_name=None) -> GameSchema:
        if not room_name:
            game_room = None
        else:
            game_room = await self.__game_room_repository.get_room(room_name)
        if not game_room:
            return await self.__game_room_repository.create_room(room, room_name)

    async def get_room(self, room_name: str) -> GameSchema:
        return await self.__game_room_repository.get_room(room_name)

    async def add_player_to_room(
        self, room_name: str, player, side: Literal["black", "white"]
    ) -> None:
        await self.__game_room_repository.add_player_to_room(room_name, player, side)

    async def room_is_full(self, room_name) -> bool:
        return await self.__game_room_repository.room_is_full(room_name)

    async def free_side(self, room_name) -> Literal["black", "white"]:
        return await self.__game_room_repository.free_side(room_name)

    async def get_players(self, room_name):
        return await self.__game_room_repository.get_players(room_name)

    async def get_creator(self, room_name):
        return await self.__game_room_repository.get_creator(room_name)

    async def start_game(self, room_name):
        await self.__game_room_repository.start_game(room_name)

    async def get_board(self, room_name):
        return await self.__game_room_repository.get_board(room_name)

    async def is_legal_move(self, room_name, move):
        return await self.__game_room_repository.is_legal_move(room_name, move)

    async def make_move(self, room_name, move):
        return await self.__game_room_repository.make_move(room_name, move)
