import unittest
from unittest.mock import MagicMock
from fastapi import WebSocket

from core.entities.game_room.abstract_game_room import AbstractGameRoom
from core.entities.player_session.websocket_player_session import WebsocketPlayerSession


class TestWebsocketPlayerSession(unittest.IsolatedAsyncioTestCase):

    async def test_send_message(self):
        connection = MagicMock(spec=WebSocket)
        session = WebsocketPlayerSession(connection)
        message = {"test": "message"}
        await session.send_message(message)
        connection.send_json.assert_called_once_with(message)

    def test_set_current_game(self):
        connection = MagicMock(spec=WebSocket)
        session = WebsocketPlayerSession(connection)
        game = MagicMock(spec=AbstractGameRoom)
        session.set_current_room(game)
        self.assertEqual(session.get_current_room(), game)

    def test_get_current_game_not_set(self):
        connection = MagicMock(spec=WebSocket)
        session = WebsocketPlayerSession(connection)
        self.assertIsNone(session.get_current_room())

    async def test_init(self):
        connection = MagicMock(spec=WebSocket)
        session = WebsocketPlayerSession(connection)
        self.assertEqual(session._connection, connection)
