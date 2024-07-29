import asyncio
import json
import unittest
from unittest.mock import MagicMock, AsyncMock

from core.entities.AbstractGameRoom import AbstractGameRoom
from core.handlers.RoomInitRequestHandler import RoomInitRequestHandler
from core.services.RoomService import RoomService


class TestRoomInitRequestHandler(unittest.IsolatedAsyncioTestCase):
    async def test_handle_room_already_exists(self):
        room_service = MagicMock(spec=RoomService)
        room_service.get_room.return_value = MagicMock(spec=AbstractGameRoom)
        player_session = MagicMock()
        player_session.send_message = AsyncMock()
        player_session_factory = MagicMock()
        player_session_factory.create_session.return_value = player_session
        handler = RoomInitRequestHandler(room_service, player_session_factory)
        connection = MagicMock()

        message = {
            "jsonType": "roomInitRequest",
            "data": {
                "gameType": "eq",
                "room": {
                    "roomName": "existing_room",
                },
                "player": {
                    "playerName": "qwe",
                    "playerSide": "white"
                }
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
        player_session_factory.create_session.assert_called_once()
        room_service.create_room.assert_not_called()
        player_session.send_message.assert_awaited_once_with(json.dumps(response_message))

    async def test_handle_room_creation(self):
        rooms = {}
        room = MagicMock()

        def func(*args):
            rooms["new_room"] = room
        room_service = MagicMock(spec=RoomService)
        room_service.get_room = lambda x: rooms.get(x)
        room_service.create_room = func
        player_session = MagicMock()
        player_session.send_message = AsyncMock()
        player_session_factory = MagicMock()
        player_session_factory.create_session.return_value = player_session
        handler = RoomInitRequestHandler(room_service, player_session_factory)
        message = {
            "jsonType": "roomInitRequest",
            "data": {
                "gameType": "some_game",
                "room": {
                    "roomName": "new_room",
                },
                "player": {
                    "playerName": "qwe",
                    "playerSide": "white"
                }
            },
        }
        connection = MagicMock()

        handler.handle(message, connection)
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
        player_session_factory.create_session.assert_called_once()
        player_session.send_message.assert_awaited_once_with(json.dumps(response_message))
