import asyncio
import json
import unittest
from unittest.mock import MagicMock, AsyncMock

from core.entities.game_room.abstract_game_room import AbstractGameRoom
from core.handlers.room_init_request_handler import RoomInitRequestHandler
from core.services.room_service import RoomService


class TestRoomInitRequestHandler(unittest.IsolatedAsyncioTestCase):
    async def test_handle_room_already_exists(self):
        room_service = MagicMock(spec=RoomService)
        room_service.get_room.return_value = MagicMock(spec=AbstractGameRoom)
        room_service.create_room.return_value = "already exists"
        player_session = MagicMock()
        player_session.send_message = AsyncMock()
        player_factory = MagicMock()
        player_factory.create_player.return_value = None
        handler = RoomInitRequestHandler(room_service, player_factory)
        connection = AsyncMock()
        connection.send_message.return_value = AsyncMock()

        message = {
            "jsonType": "roomInitRequest",
            "data": {
                "gameType": "eq",
                "room": {
                    "roomName": "existing_room",
                },
                "player": {"playerName": "qwe", "playerSide": "white"},
            },
        }

        handler.handle(message, connection)
        await asyncio.sleep(0.1)

        response_message = {
            "errors": None,
            "system_messages": None,
            "jsonType": "roomInitResponse",
            "data": {
                "gameType": "eq",
                "roomName": "existing_room",
                "roomInitStatus": "already exists",
            },
        }
        player_factory.create_player.assert_not_called()
        room_service.create_room.assert_called_once()
        connection.send_message.assert_awaited_once_with(
            json.dumps(response_message)
        )

    async def test_handle_room_creation(self):
        rooms = {}
        room = MagicMock()

        def func(*args):
            rooms["new_room"] = room
            return "successfully created"

        room_service = MagicMock(spec=RoomService)
        room_service.get_room = lambda x: rooms.get(x)
        room_service.create_room = func
        player_session = MagicMock()
        player_session.send_message = AsyncMock()
        player_factory = MagicMock()
        player = MagicMock()
        player_factory.create_player.return_value = player
        handler = RoomInitRequestHandler(room_service, player_factory)
        message = {
            "jsonType": "roomInitRequest",
            "data": {
                "gameType": "some_game",
                "room": {
                    "roomName": "new_room",
                },
                "player": {"playerName": "qwe", "playerSide": "white"},
            },
        }

        handler.handle(message, player_session)
        await asyncio.sleep(0.1)

        response_message = {
            "errors": None,
            "system_messages": None,
            "jsonType": "roomInitResponse",
            "data": {
                "gameType": "some_game",
                "roomName": "new_room",
                "roomInitStatus": "successfully created",
            },
        }
        player_factory.create_player.assert_called_once()
        player_session.send_message.assert_awaited_once_with(
            json.dumps(response_message)
        )
