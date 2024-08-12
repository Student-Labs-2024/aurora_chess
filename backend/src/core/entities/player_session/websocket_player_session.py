from fastapi import WebSocket
from pydantic import json

from core.entities.player_session.abstract_player_session import AbstractPlayerSession


class WebsocketPlayerSession(AbstractPlayerSession):
    def __init__(self, connection: WebSocket):
        super().__init__(connection)

    async def send_message(self, message: json) -> None:
        await self._connection.send_json(message)
