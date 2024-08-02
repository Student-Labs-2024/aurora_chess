from abc import ABC, abstractmethod


class AbstractGameRoom(ABC):
    def __init__(self, room_name: str, game_type: str):
        self.__room_name = room_name
        self.__game_type = game_type

    @abstractmethod
    def make_move(self, move) -> None:
        pass

    @abstractmethod
    def finish_game(self) -> None:
        pass

    @abstractmethod
    def add_player(self, player) -> None:
        pass

    @abstractmethod
    def is_full(self) -> bool:
        pass

    @abstractmethod
    def free_colors(self):
        pass

    @abstractmethod
    def get_players(self):
        pass

    @abstractmethod
    def get_board(self):
        pass
