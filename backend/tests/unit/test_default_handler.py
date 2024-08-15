import json
import unittest
from unittest.mock import MagicMock, AsyncMock

from core.handlers.default_handler import DefaultHandler
from core.schemas.unknown_message_response import UnknownMessageResponse


class TestPlayerMoveRequestHandler(unittest.IsolatedAsyncioTestCase):
    async def test_valid_move(self):
        handler = DefaultHandler()

        message = {
            "jsonType": "unknownMessage",
            "data": {
                "gameType": "game_type",
                "roomName": "room_name",
                "player": "player",
                "player_move": "player_move",
            },
        }
        player_session = MagicMock()
        player_session.send_message = AsyncMock()

        await handler.handle(message, player_session)

        response_message = UnknownMessageResponse(jsonType="unknownMessage")

        player_session.send_message.assert_called_once_with(
            json.dumps(response_message.model_dump(by_alias=True))
        )
