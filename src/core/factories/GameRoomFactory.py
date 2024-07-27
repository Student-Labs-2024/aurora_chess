from core.entities.GameRoom import GameRoom
from core.factories.AbstractGameRoomFactory import AbstractGameRoomFactory


class GameRoomFactory(AbstractGameRoomFactory):
    def create_room(self, *args) -> GameRoom:
        return GameRoom(*args)
