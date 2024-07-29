import unittest
from unittest.mock import MagicMock, patch
from core.entities.AbstractGameRoom import AbstractGameRoom
from core.factories.AbstractGameRoomFactory import AbstractGameRoomFactory
from core.services.RoomService import RoomService


class TestRoomService(unittest.TestCase):

    def setUp(self):
        self.game_room_factory = MagicMock(spec=AbstractGameRoomFactory)
        self.room_service = RoomService(self.game_room_factory)

    def test_create_room(self):
        room_name = "Test Room"
        game_type = "Test Game"
        self.room_service.create_room(room_name, game_type)
        self.game_room_factory.create_room.assert_called_once_with(room_name, game_type)
        self.assertIn(room_name, self.room_service.rooms)

    def test_get_room(self):
        room_name = "Test Room"
        game_room = MagicMock(spec=AbstractGameRoom)
        self.room_service.rooms[room_name] = game_room
        self.assertEqual(self.room_service.get_room(room_name), game_room)

    def test_get_room_not_found(self):
        room_name = "Non-existent Room"
        self.assertIsNone(self.room_service.get_room(room_name))

    def test_add_player_to_room(self):
        room_name = "Test Room"
        player = MagicMock()
        game_room = MagicMock(spec=AbstractGameRoom)
        self.room_service.rooms[room_name] = game_room
        self.room_service.add_player_to_room(room_name, player)
        game_room.add_player.assert_called_once_with(player)

    def test_add_player_to_non_existent_room(self):
        room_name = "Non-existent Room"
        player = MagicMock()
        self.room_service.add_player_to_room(room_name, player)
