from core.entities.game_room.game_room import GameRoom
from core.repository.room_repository.abstract_room_repository import (
    AbstractRoomRepository,
)


class RAMRoomRepository(AbstractRoomRepository):
    def __init__(self):
        self.__rooms: dict[str, GameRoom] = {}

    def create_room(self, *args):
        room_name = args[0]
        game_type = args[1]
        self.__rooms[room_name] = GameRoom(room_name, game_type)

    def get_room(self, key_room: str) -> GameRoom:
        return self.__rooms.get(key_room)

    def add_player_to_room(self, room_name, player):
        self.__rooms[room_name].add_player(player)
