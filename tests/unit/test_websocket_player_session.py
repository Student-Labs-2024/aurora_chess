import unittest
from unittest.mock import MagicMock, patch
from fastapi import WebSocket
from core.entities.AbstractGameRoom import AbstractGameRoom
from core.entities.WebsocketPlayerSession import WebsocketPlayerSession


class TestWebsocketPlayerSession(unittest.IsolatedAsyncioTestCase):

    async def test_send_message(self):
        name = "Test Player"
        side = "white"
        connection = MagicMock(spec=WebSocket)
        session = WebsocketPlayerSession(name, side, connection)
        message = {"test": "message"}
        await session.send_message(message)
        connection.send_json.assert_called_once_with(message)

    def test_set_current_game(self):
        name = "Test Player"
        side = "white"
        connection = MagicMock(spec=WebSocket)
        session = WebsocketPlayerSession(name, side, connection)
        game = MagicMock(spec=AbstractGameRoom)
        session.set_current_game(game)
        self.assertEqual(session.get_current_game(), game)

    def test_get_current_game_not_set(self):
        name = "Test Player"
        side = "white"
        connection = MagicMock(spec=WebSocket)
        session = WebsocketPlayerSession(name, side, connection)
        with self.assertRaises(AttributeError):
            session.get_current_game()

    async def test_init(self):
        name = "Test Player"
        side = "white"
        connection = MagicMock(spec=WebSocket)
        session = WebsocketPlayerSession(name, side, connection)
        self.assertEqual(session.name, name)
        self.assertEqual(session.side, side)
        self.assertEqual(session._WebsocketPlayerSession__connection, connection)
