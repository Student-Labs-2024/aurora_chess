from typing import Literal

from fastapi import WebSocket
from pydantic import json

from core.entities.game_room.abstract_game_room import AbstractGameRoom
from core.entities.player_session.abstract_player_session import AbstractPlayerSession


class WebsocketPlayerSession(AbstractPlayerSession):
    def __init__(
        self, name: str, side: Literal["white", "black"], connection: WebSocket
    ):
        super().__init__(name, side)
        self.__connection: WebSocket = connection

    async def send_message(self, message: json) -> None:
        await self.__connection.send_json(message)

    def set_current_game(self, game) -> None:
        self.__current_game = game

    def get_current_game(self) -> AbstractGameRoom:
        return self.__current_game
