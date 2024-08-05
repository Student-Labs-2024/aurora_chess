from abc import ABC, abstractmethod
from typing import Literal

from core.entities.game_room.abstract_game_room import AbstractGameRoom


class AbstractPlayerSession(ABC):
    def __init__(self, name: str, side: Literal["white", "black"]):
        self.name = name
        self.side = side
        self.__current_game: AbstractGameRoom | None = None

    @abstractmethod
    def send_message(self, message) -> None:
        pass

    @abstractmethod
    def set_current_game(self, game) -> None:
        pass

    @abstractmethod
    def get_current_game(self) -> AbstractGameRoom:
        pass
