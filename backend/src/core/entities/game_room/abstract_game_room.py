from abc import ABC, abstractmethod


class AbstractGameRoom(ABC):
    def __init__(self, game_type: str):
        self.game_type = game_type

    @abstractmethod
    def make_move(self, move):
        pass

    @abstractmethod
    def is_full(self) -> bool:
        pass

    @abstractmethod
    def get_board(self):
        pass

    @abstractmethod
    def is_legal_move(self, move):
        raise NotImplemented

    @abstractmethod
    def is_active(self):
        raise NotImplemented

    @abstractmethod
    def start_game(self):
        raise NotImplemented
