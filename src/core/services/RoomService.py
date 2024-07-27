from core.entities.AbstractGameRoom import AbstractGameRoom
from core.factories.AbstractGameRoomFactory import AbstractGameRoomFactory


class RoomService:
    def __init__(self, game_room_factory):
        self.rooms = {}
        self.__game_room_factory: AbstractGameRoomFactory = game_room_factory

    def create_room(self, room_name: str, game_type: str) -> None:
        if room_name not in self.rooms:
            self.rooms[room_name] = self.__game_room_factory.create_room(room_name, game_type)

    def get_room(self, room_name: str) -> AbstractGameRoom:
        return self.rooms.get(room_name)

    def add_player_to_room(self, room_name: str, player) -> None:
        room = self.get_room(room_name)
        if room:
            room.add_player(player)
