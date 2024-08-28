from abc import ABC, abstractmethod

from core.entities.game_room.abstract_game_room import AbstractGameRoom
from core.entities.player.abstract_player import AbstractPlayer


class AbstractPlayerSession(ABC):
    def __init__(self, connection):
        self._connection = connection
        self._player: AbstractPlayer | None = None
        self._current_room: AbstractGameRoom | None = None
        self.user_id: int | None = None

    @abstractmethod
    def send_message(self, message) -> None:
        pass

    def set_current_room(self, room) -> None:
        self._current_room = room

    def get_current_room(self) -> AbstractGameRoom:
        return self._current_room

    def set_player(self, player):
        self._player = player

    def get_player(self) -> AbstractPlayer:
        return self._player
