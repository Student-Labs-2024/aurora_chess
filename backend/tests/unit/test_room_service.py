import unittest
from unittest.mock import MagicMock, AsyncMock

from core.repository.room_repository.abstract_room_repository import (
    AbstractRoomRepository,
)
from core.services.room_service import RoomService


class TestRoomService(unittest.IsolatedAsyncioTestCase):

    def setUp(self):
        self.game_room_repository = MagicMock(spec=AbstractRoomRepository)
        self.game_room_repository.create_room = AsyncMock(return_value=None)
        self.game_room_repository.get_room = AsyncMock(return_value=None)
        self.game_room_repository.add_player_to_room = AsyncMock(return_value=None)
        self.room_service = RoomService(self.game_room_repository)

    async def test_create_room(self):
        room_name = "Test Room"
        game_type = "Test Game"
        self.game_room_repository.get_room.return_value = None
        self.game_room_repository.create_room.return_value = None
        await self.room_service.create_room(game_type, room_name)
        self.game_room_repository.create_room.assert_called_once_with(
            game_type, room_name
        )
        self.game_room_repository.get_room.assert_called_once_with(room_name)

    async def test_get_room(self):
        room_name = "Test Room"
        await self.room_service.get_room(room_name)
        self.game_room_repository.get_room.assert_called_once_with(room_name)

    async def test_get_room_not_found(self):
        room_name = "Non-existent Room"
        self.game_room_repository.get_room.return_value = None
        self.assertIsNone(await self.room_service.get_room(room_name))

    async def test_add_player_to_room(self):
        room_name = "Test Room"
        player = MagicMock()
        await self.room_service.add_player_to_room(room_name, player, "white")
        self.game_room_repository.add_player_to_room.assert_called_once_with(
            room_name, player, "white"
        )

    async def test_add_player_to_non_existent_room(self):
        room_name = "Non-existent Room"
        player = MagicMock()
        await self.room_service.add_player_to_room(room_name, player, "white")
