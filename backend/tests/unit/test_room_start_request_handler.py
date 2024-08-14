import asyncio
import json
import unittest
from unittest.mock import MagicMock, AsyncMock

from core.entities.game_room.abstract_game_room import AbstractGameRoom
from core.entities.player.chess_player import ChessPlayer
from core.handlers.room_start_request_handler import RoomStartRequestHandler
from core.schemas.player_move_response import PlayerMoveResponseData, PlayerMoveResponse
from core.schemas.room_start_response import RoomStartResponseData, RoomStartResponse
from core.services.room_service import RoomService


class TestStartMoveRequestHandler(unittest.IsolatedAsyncioTestCase):
    async def test_valid_start(self):
        room_service = MagicMock(spec=RoomService)
        game_room = MagicMock(spec=AbstractGameRoom)
        game_room.is_active.return_value = False
        game_room.is_full.return_value = True
        board = "qwe"
        game_room.get_board.return_value = board
        room_service.get_room.return_value = game_room

        handler = RoomStartRequestHandler(room_service)

        player_session_white = MagicMock()
        player_session_white.send_message = AsyncMock()
        player_white_owner = MagicMock(ChessPlayer)
        player_white_owner.get_session.return_value = player_session_white
        player_white_owner.get_name.return_value = "player_white"
        player_white_owner.get_side.return_value = "white"
        player_session_black = MagicMock()
        player_session_black.send_message = AsyncMock()
        player_black = MagicMock(ChessPlayer)
        player_black.get_session.return_value = player_session_black
        player_black.get_name.return_value = "player_black"
        player_black.get_side.return_value = "black"

        game_room.get_owner.return_value = player_white_owner

        game_type = "test_invalid_player_info"
        game_room.get_game_type.return_value = game_type
        game_room.get_players.return_value = [player_white_owner, player_black]
        room_name = "invalid_test_player_info"

        message = {
            "jsonType": "roomStartRequest",
            "data": {
                "gameType": game_type,
                "roomName": room_name,
                "player": {"playerName": "player_white", "playerSide": "white"},
            },
        }

        handler.handle(message, player_session_white)
        await asyncio.sleep(0.1)

        response_data = RoomStartResponseData(
            confirmationStatus="confirmed",
            gameType=game_type,
            roomName=room_name,
            board=board,
            players=[
                {"playerName": "player_white", "playerSide": "white"},
                {"playerName": "player_black", "playerSide": "black"},
            ],
        )
        response_message = RoomStartResponse(
            jsonType="roomStartResponse", data=response_data
        )

        room_service.get_room.assert_called_once_with(room_name)
        game_room.get_game_type.asser_called_once()
        game_room.get_players.asser_called_once()
        player_white_owner.get_session.asser_called_once()
        player_white_owner.get_name.assert_called()
        player_white_owner.get_side.assert_called()

        player_black.get_session.asser_not_called()
        player_black.get_name.assert_called_once()
        player_black.get_side.assert_called_once()

        player_session_white.send_message.assert_called_once_with(
            json.dumps(response_message.model_dump(by_alias=True))
        )
        player_session_black.send_message.assert_called_once_with(
            json.dumps(response_message.model_dump(by_alias=True))
        )

    async def test_invalid_player_info(self):
        room_service = MagicMock(spec=RoomService)
        game_room = MagicMock(spec=AbstractGameRoom)
        game_room.is_active.return_value = False
        game_room.is_full.return_value = True
        room_service.get_room.return_value = game_room

        handler = RoomStartRequestHandler(room_service)

        player_session_white = MagicMock()
        player_session_white.send_message = AsyncMock()
        player_white_owner = MagicMock(ChessPlayer)
        player_white_owner.get_session.return_value = player_session_white
        player_white_owner.get_name.return_value = "player_white"
        player_white_owner.get_side.return_value = "white"
        player_session_black = MagicMock()
        player_session_black.send_message = AsyncMock()
        player_black = MagicMock(ChessPlayer)
        player_black.get_session.return_value = player_session_black
        player_black.get_name.return_value = "player_black"
        player_black.get_side.return_value = "black"

        game_room.get_owner.return_value = player_white_owner

        game_type = "test_invalid_player_info"
        game_room.get_game_type.return_value = game_type
        game_room.get_players.return_value = [player_white_owner, player_black]
        room_name = "invalid_test_player_info"

        message = {
            "jsonType": "roomStartRequest",
            "data": {
                "gameType": game_type,
                "roomName": room_name,
                "player": {"playerName": "", "playerSide": "white"},
            },
        }

        handler.handle(message, player_session_white)
        await asyncio.sleep(0.1)

        response_data = RoomStartResponseData(
            confirmationStatus="not valid",
            gameType=game_type,
            roomName=room_name,
        )
        response_message = RoomStartResponse(
            jsonType="roomStartResponse", data=response_data
        )

        room_service.get_room.assert_called_once_with(room_name)
        game_room.get_game_type.asser_called_once()
        game_room.get_players.asser_called_once()
        player_white_owner.get_session.asser_called_once()
        player_white_owner.get_name.assert_called_once()
        player_white_owner.get_side.assert_called()

        player_black.get_session.asser_not_called()
        player_black.get_name.assert_not_called()
        player_black.get_side.assert_not_called()

        player_session_white.send_message.assert_called_once_with(
            json.dumps(response_message.model_dump(by_alias=True))
        )

    async def test_invalid_room_is_active(self):
        room_service = MagicMock(spec=RoomService)
        game_room = MagicMock(spec=AbstractGameRoom)
        game_room.is_active.return_value = True
        game_room.is_full.return_value = True
        room_service.get_room.return_value = game_room

        handler = RoomStartRequestHandler(room_service)

        player_session_white = MagicMock()
        player_session_white.send_message = AsyncMock()
        player_white_owner = MagicMock(ChessPlayer)
        player_white_owner.get_session.return_value = player_session_white
        player_white_owner.get_name.return_value = "player_white"
        player_white_owner.get_side.return_value = "white"
        player_session_black = MagicMock()
        player_session_black.send_message = AsyncMock()
        player_black = MagicMock(ChessPlayer)
        player_black.get_session.return_value = player_session_black
        player_black.get_name.return_value = "player_black"
        player_black.get_side.return_value = "black"

        game_room.get_owner.return_value = player_white_owner

        game_type = "test_invalid_player_info"
        game_room.get_game_type.return_value = game_type
        game_room.get_players.return_value = [player_white_owner, player_black]
        room_name = "invalid_test_player_info"

        message = {
            "jsonType": "roomStartRequest",
            "data": {
                "gameType": game_type,
                "roomName": room_name,
                "player": {"playerName": "player_white", "playerSide": "white"},
            },
        }

        handler.handle(message, player_session_white)
        await asyncio.sleep(0.1)

        response_data = RoomStartResponseData(
            confirmationStatus="not valid",
            gameType=game_type,
            roomName=room_name,
        )
        response_message = RoomStartResponse(
            jsonType="roomStartResponse", data=response_data
        )

        room_service.get_room.assert_called_once_with(room_name)
        game_room.get_game_type.asser_called_once()
        game_room.get_players.asser_called_once()
        player_white_owner.get_session.asser_called_once()
        player_white_owner.get_name.assert_not_called()
        player_white_owner.get_side.assert_not_called()

        player_black.get_session.asser_not_called()
        player_black.get_name.assert_not_called()
        player_black.get_side.assert_not_called()

        player_session_white.send_message.assert_called_once_with(
            json.dumps(response_message.model_dump(by_alias=True))
        )

    async def test_invalid_room_not_full(self):
        room_service = MagicMock(spec=RoomService)
        game_room = MagicMock(spec=AbstractGameRoom)
        game_room.is_active.return_value = False
        game_room.is_full.return_value = False
        room_service.get_room.return_value = game_room

        handler = RoomStartRequestHandler(room_service)

        player_session_white = MagicMock()
        player_session_white.send_message = AsyncMock()
        player_white_owner = MagicMock(ChessPlayer)
        player_white_owner.get_session.return_value = player_session_white
        player_white_owner.get_name.return_value = "player_white"
        player_white_owner.get_side.return_value = "white"
        player_session_black = MagicMock()
        player_session_black.send_message = AsyncMock()
        player_black = MagicMock(ChessPlayer)
        player_black.get_session.return_value = player_session_black
        player_black.get_name.return_value = "player_black"
        player_black.get_side.return_value = "black"

        game_room.get_owner.return_value = player_white_owner

        game_type = "test_invalid_player_info"
        game_room.get_game_type.return_value = game_type
        game_room.get_players.return_value = [player_white_owner, player_black]
        room_name = "invalid_test_player_info"

        message = {
            "jsonType": "roomStartRequest",
            "data": {
                "gameType": game_type,
                "roomName": room_name,
                "player": {"playerName": "player_white", "playerSide": "white"},
            },
        }

        handler.handle(message, player_session_white)
        await asyncio.sleep(0.1)

        response_data = RoomStartResponseData(
            confirmationStatus="not valid",
            gameType=game_type,
            roomName=room_name,
        )
        response_message = RoomStartResponse(
            jsonType="roomStartResponse", data=response_data
        )

        room_service.get_room.assert_called_once_with(room_name)
        game_room.get_game_type.asser_called_once()
        game_room.get_players.asser_called_once()
        player_white_owner.get_session.asser_called_once()
        player_white_owner.get_name.assert_not_called()
        player_white_owner.get_side.assert_not_called()

        player_black.get_session.asser_not_called()
        player_black.get_name.assert_not_called()
        player_black.get_side.assert_not_called()

        player_session_white.send_message.assert_called_once_with(
            json.dumps(response_message.model_dump(by_alias=True))
        )

    async def test_invalid_player_session(self):
        room_service = MagicMock(spec=RoomService)
        game_room = MagicMock(spec=AbstractGameRoom)
        game_room.is_active.return_value = False
        game_room.is_full.return_value = True
        room_service.get_room.return_value = game_room

        handler = RoomStartRequestHandler(room_service)

        player_session_white = MagicMock()
        player_session_white.send_message = AsyncMock()
        player_white_owner = MagicMock(ChessPlayer)
        player_white_owner.get_session.return_value = player_session_white
        player_white_owner.get_name.return_value = "player_white"
        player_white_owner.get_side.return_value = "white"
        player_session_black = MagicMock()
        player_session_black.send_message = AsyncMock()
        player_black = MagicMock(ChessPlayer)
        player_black.get_session.return_value = player_session_black
        player_black.get_name.return_value = "player_black"
        player_black.get_side.return_value = "black"

        game_room.get_owner.return_value = player_white_owner

        game_type = "test_invalid_player_info"
        game_room.get_game_type.return_value = game_type
        game_room.get_players.return_value = [player_white_owner, player_black]
        room_name = "invalid_test_player_info"

        message = {
            "jsonType": "roomStartRequest",
            "data": {
                "gameType": game_type,
                "roomName": room_name,
                "player": {"playerName": "player_white", "playerSide": "white"},
            },
        }

        handler.handle(message, player_session_black)
        await asyncio.sleep(0.1)

        response_data = RoomStartResponseData(
            confirmationStatus="not valid",
            gameType=game_type,
            roomName=room_name,
        )
        response_message = RoomStartResponse(
            jsonType="roomStartResponse", data=response_data
        )

        room_service.get_room.assert_called_once_with(room_name)
        game_room.get_game_type.asser_called_once()
        game_room.get_players.asser_called_once()
        player_white_owner.get_session.asser_called_once()
        player_white_owner.get_name.assert_called_once()
        player_white_owner.get_side.assert_called_once()

        player_black.get_session.asser_not_called()
        player_black.get_name.assert_not_called()
        player_black.get_side.assert_not_called()

        player_session_black.send_message.assert_called_once_with(
            json.dumps(response_message.model_dump(by_alias=True))
        )

    async def test_invalid_room_name(self):
        room_service = MagicMock(spec=RoomService)
        game_room = MagicMock(spec=AbstractGameRoom)
        game_room.is_active.return_value = True
        game_room.is_full.return_value = False
        room_service.get_room.return_value = game_room

        handler = RoomStartRequestHandler(room_service)

        player_session_white = MagicMock()
        player_session_white.send_message = AsyncMock()
        player_white_owner = MagicMock(ChessPlayer)
        player_white_owner.get_session.return_value = player_session_white
        player_white_owner.get_name.return_value = "player_white"
        player_white_owner.get_side.return_value = "white"
        player_session_black = MagicMock()
        player_session_black.send_message = AsyncMock()
        player_black = MagicMock(ChessPlayer)
        player_black.get_session.return_value = player_session_black
        player_black.get_name.return_value = "player_black"
        player_black.get_side.return_value = "black"

        game_room.get_owner.return_value = player_white_owner

        game_type = "test_invalid_player_info"
        game_room.get_game_type.return_value = game_type
        game_room.get_players.return_value = [player_white_owner, player_black]
        room_name = "invalid_test_player_info"

        message = {
            "jsonType": "roomStartRequest",
            "data": {
                "gameType": game_type,
                "roomName": room_name + "   ",
                "player": {"playerName": "player_white", "playerSide": "white"},
            },
        }

        handler.handle(message, player_session_white)
        await asyncio.sleep(0.1)

        response_data = RoomStartResponseData(
            confirmationStatus="not valid",
            gameType=game_type,
            roomName=room_name + "   ",
        )
        response_message = RoomStartResponse(
            jsonType="roomStartResponse", data=response_data
        )

        room_service.get_room.assert_called_once_with(room_name + "   ")
        game_room.get_game_type.asser_called_once()
        game_room.get_players.asser_called_once()
        player_white_owner.get_session.asser_called_once()
        player_white_owner.get_name.assert_not_called()
        player_white_owner.get_side.assert_not_called()

        player_black.get_session.asser_not_called()
        player_black.get_name.assert_not_called()
        player_black.get_side.assert_not_called()

        player_session_white.send_message.assert_called_once_with(
            json.dumps(response_message.model_dump(by_alias=True))
        )
