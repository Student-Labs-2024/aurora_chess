from abc import ABC, abstractmethod


class AbstractRoomRepository(ABC):
    @abstractmethod
    def create_room(self, *args):
        raise NotImplemented

    @abstractmethod
    def get_room(self, room_name):
        raise NotImplemented

    @abstractmethod
    def add_player_to_room(self, room_name, player, side):
        raise NotImplemented

    @abstractmethod
    def room_is_full(self, room_name):
        raise NotImplemented

    @abstractmethod
    def free_side(self, room_name):
        raise NotImplemented

    @abstractmethod
    def get_players(self, room_name):
        raise NotImplemented

    @abstractmethod
    def get_creator(self, room_name):
        raise NotImplemented

    @abstractmethod
    def start_game(self, room_name):
        raise NotImplemented

    @abstractmethod
    def get_board(self, room_name):
        raise NotImplemented

    @abstractmethod
    def is_legal_move(self, room_name, move):
        raise NotImplemented

    @abstractmethod
    def make_move(self, room_name, move):
        raise NotImplemented

    @abstractmethod
    def is_full(self, room_name):
        raise NotImplemented
