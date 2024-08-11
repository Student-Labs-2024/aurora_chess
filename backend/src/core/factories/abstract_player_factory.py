from abc import ABC, abstractmethod

from core.entities.player.abstract_player import AbstractPlayer


class AbstractPlayerFactory(ABC):
    @abstractmethod
    def create_player(self, *args) -> AbstractPlayer:
        pass
