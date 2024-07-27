from abc import ABC, abstractmethod


class MessageHandler(ABC):
    @abstractmethod
    def handle(self, *args) -> None:
        pass
