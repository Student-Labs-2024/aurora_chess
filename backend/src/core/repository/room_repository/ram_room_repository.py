from core.entities.game_room.game_room import GameRoom
from core.repository.room_repository.abstract_room_repository import (
    AbstractRoomRepository,
)
from core.services.room_service import GameSchema


class RAMRoomRepository(AbstractRoomRepository):
    def __init__(self):
        self.__rooms: dict[str or int, GameRoom] = {}

    async def create_room(self, room_schema: GameSchema, room_name) -> GameSchema:
        room = GameRoom(room_schema.game_type)
        self.__rooms[room_name] = room
        return room_schema

    async def get_room(self, key_room: str) -> GameSchema:
        room = self.__rooms.get(key_room)
        if room:
            return GameSchema.model_validate(self.__rooms.get(key_room).__dict__)

    async def add_player_to_room(self, room_name, player, side):
        room = self.__rooms[room_name]
        if side == "white":
            room.player_white = player
        elif side == "black":
            room.player_black = player
        if not room.creator:
            room.creator = player

    async def room_is_full(self, room_name):
        room = self.__rooms[room_name]
        return room.player_black and room.player_white

    async def free_side(self, room_name):
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

    async def start_game(self, room_name):
        self.__rooms[room_name].start_game()

    async def get_board(self, room_name):
        room = self.__rooms[room_name]
        return room.get_board()

    async def is_legal_move(self, room_name, move):
        return self.__rooms[room_name].is_legal_move(move)

    async def make_move(self, room_name, move):
        return self.__rooms[room_name].make_move(move)

    async def is_full(self, room_name):
        room = self.__rooms[room_name]
        return room.player_black and room.player_white
