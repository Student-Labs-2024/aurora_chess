import unittest
from unittest.mock import MagicMock
from core.repository.room_repository.abstract_room_repository import (
    AbstractRoomRepository,
)
from core.services.room_service import RoomService


class TestRoomService(unittest.TestCase):

    def setUp(self):
        self.game_room_repository = MagicMock(spec=AbstractRoomRepository)
        self.room_service = RoomService(self.game_room_repository)

    def test_create_room(self):
        room_name = "Test Room"
        game_type = "Test Game"
        self.game_room_repository.get_room.return_value = None
        self.game_room_repository.create_room.return_value = None
        self.room_service.create_room(room_name, game_type)
        self.game_room_repository.create_room.assert_called_once_with(
            room_name, game_type
        )
        self.game_room_repository.get_room.assert_called_once_with(room_name)

    def test_get_room(self):
        room_name = "Test Room"
        self.room_service.get_room(room_name)
        self.game_room_repository.get_room.assert_called_once_with(room_name)

    def test_get_room_not_found(self):
        room_name = "Non-existent Room"
        self.game_room_repository.get_room.return_value = None
        self.assertIsNone(self.room_service.get_room(room_name))

    def test_add_player_to_room(self):
        room_name = "Test Room"
        player = MagicMock()
        self.room_service.add_player_to_room(room_name, player)
        self.game_room_repository.add_player_to_room.assert_called_once_with(
            room_name, player
        )

    def test_add_player_to_non_existent_room(self):
        room_name = "Non-existent Room"
        player = MagicMock()
        self.room_service.add_player_to_room(room_name, player)
