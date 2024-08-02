from abc import ABC, abstractmethod


class AbstractRoomRepository(ABC):
    @abstractmethod
    def create_room(self, *args):
        raise NotImplemented

    @abstractmethod
    def get_room(self, room_name):
        raise NotImplemented

    def add_player_to_room(self, room_name, player):
        raise NotImplemented
