from fractions import Fraction

from fastapi import Depends
from sqlalchemy import update
from sqlalchemy.ext.asyncio import AsyncSession

from core.database.db_helper import db_helper
from core.database.models.game import Game
from core.entities.game_room.game_room import GameRoom
from core.repository.room_repository.abstract_room_repository import (
    AbstractRoomRepository,
)
from core.services.rating_service import update_rating_by_user_id
from core.services.room_service import GameSchema
from utils.chess_rating import calculate_new_elo


class SQLAlchemyRepository(AbstractRoomRepository):
    def __init__(self):
        self.__rooms: dict[int, GameRoom] = {}

    async def create_room(
        self,
        room_schema: GameSchema,
        db: AsyncSession = Depends(db_helper.session_getter),
    ) -> GameSchema:
        db_game = Game(**room_schema.model_dump())
        db.add(db_game)
        await db.commit()
        await db.refresh(db_game)

        room = GameRoom(room_schema.game_type)
        self.__rooms[room_schema.id] = room

        return GameSchema.model_validate(db_game)

    async def get_room(self, key_room: id) -> GameSchema:
        room = self.__rooms.get(key_room)
        if room:
            return GameSchema.model_validate(self.__rooms.get(key_room).__dict__)

    async def add_player_to_room(
        self,
        room_name: int,
        player,
        side,
        db: AsyncSession = Depends(db_helper.session_getter),
    ):
        room = self.__rooms[room_name]
        if side == "white":
            room.player_white = player
            stmt = (
                update(Game)
                .where(Game.id == room_name)
                .values(player_white_id=player.user_id)
            )
            await db.execute(stmt)
        elif side == "black":
            room.player_black = player
            stmt = (
                update(Game)
                .where(Game.id == room_name)
                .values(player_black_id=player.user_id)
            )
            await db.execute(stmt)
        if not room.creator:
            room.creator = player

    async def room_is_full(self, room_name):
        room = self.__rooms[room_name]
        return room.player_black and room.player_white

    def free_side(self, room_name):
        room = self.__rooms[room_name]
        if room.player_white and not room.player_black:
            return "black"
        if room.player_black and not room.player_white:
            return "white"

    async def get_players(self, room_name):
        room = self.__rooms[room_name]
        return [room.player_white, room.player_black]

    async def get_creator(self, room_name):
        return self.__rooms[room_name].creator

    async def start_game(
        self, room_name: int, db: AsyncSession = Depends(db_helper.session_getter)
    ):
        self.__rooms[room_name].start_game()
        stmt = update(Game).where(Game.id == room_name).values(result="*")
        await db.execute(stmt)

    async def get_board(self, room_name):
        room = self.__rooms[room_name]
        return room.get_board()

    async def is_legal_move(self, room_name, move):
        return self.__rooms[room_name].is_legal_move(move)

    async def make_move(
        self, room_name: int, move, db: AsyncSession = Depends(db_helper.session_getter)
    ):
        result = self.__rooms[room_name].make_move(move)
        status, new_board, game_result = result
        if status and game_result in ["1-0", "0-1", "1/2-1/2"]:
            player_white = self.__rooms[room_name].player_white

            player_black = self.__rooms[room_name].player_black

            player_white_new_elo = calculate_new_elo(
                player_elo=player_white.user_elo,
                opponent_elo=player_black.user_elo,
                score=float(Fraction("0-1".split("-")[0])),
                player_age=player_white.user_age,
                games_played=player_white.user_games,
            )
            player_black_new_elo = calculate_new_elo(
                player_elo=player_black.user_elo,
                opponent_elo=player_white.user_elo,
                score=float(Fraction("0-1".split("-")[0])),
                player_age=player_black.user_age,
                games_played=player_black.user_games,
            )
            await update_rating_by_user_id(
                db, player_white.user_id, player_white_new_elo
            )
            await update_rating_by_user_id(
                db, player_black.user_id, player_black_new_elo
            )

            stmt = update(Game).where(Game.id == room_name).values(result=game_result)
            await db.execute(stmt)

        del self.__rooms[room_name]
        return result
