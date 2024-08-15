import asyncio
import json
import unittest
from unittest.mock import MagicMock, AsyncMock

from core.engines.chess_engine import ChessEngine
from core.entities.game_room.abstract_game_room import AbstractGameRoom
from core.entities.player.chess_player import ChessPlayer
from core.handlers.player_move_request_handler import (
    PlayerMoveRequestHandler,
)
from core.schemas.player_move_response import PlayerMoveResponseData, PlayerMoveResponse
from core.services.room_service import RoomService


class TestPlayerMoveRequestHandler(unittest.IsolatedAsyncioTestCase):
    async def test_valid_move(self):
        room_service = MagicMock(spec=RoomService)
        game_room = MagicMock(spec=AbstractGameRoom)
        game_room.make_move.return_value = (
            True,
            "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR",
            "game in progress",
        )
        room_service.get_room.return_value = game_room
        player_session = MagicMock()
        player_session.send_message = AsyncMock()

        handler = PlayerMoveRequestHandler(room_service)

        player_room = MagicMock(ChessPlayer)
        player_room.get_session.return_value = player_session
        player_room.get_name.return_value = "player_white"
        player_room.get_side.return_value = "white"
        session_other_player = MagicMock()
        session_other_player.send_message = AsyncMock()
        other_player = MagicMock(ChessPlayer)
        other_player.name = "player_black"
        other_player.side = "black"
        other_player.get_session.return_value = session_other_player

        game_type = "test_invalid_session"
        game_room.get_game_type.return_value = game_type
        game_room.is_legal_move.return_value = True
        game_room.get_players.return_value = [player_room, other_player]

        room_name = "invalid_test_session"
        player = {"playerName": "player_white", "playerSide": "white"}
        player_move = {
            "board": [
                ["r", "n", "b", "q", "k", "b", "n", "r"],
                ["p", "p", "p", "p", "p", "p", "p", "p"],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["P", "P", "P", "P", "P", "P", "P", "P"],
                ["R", "N", "B", "Q", "K", "B", "N", "R"],
            ],
            "piece": "P",
            "source": {"column": 0, "row": 6},
            "destination": {"column": 0, "row": 5},
        }
        message = {
            "jsonType": "playerMoveRequest",
            "data": {
                "gameType": game_type,
                "roomName": room_name,
                "player": player,
                "player_move": player_move,
            },
        }

        await handler.handle(message, player_session)
        await asyncio.sleep(0.1)

        response_data = PlayerMoveResponseData(
            confirmationStatus="confirmed",
            player=player,
            player_move=player_move,
            gameType=game_type,
            roomName=room_name,
            gameStatus="game in progress",
        )
        response_message = PlayerMoveResponse(
            jsonType="moveConfirmationResponce", data=response_data
        )

        room_service.get_room.assert_called_once_with(room_name)
        game_room.get_game_type.asser_called_once()
        game_room.get_players.asser_called_once()
        game_room.is_legal_move.assert_called_once()
        player_room.get_session.asser_called_once()
        player_session.send_message.assert_called_once_with(
            json.dumps(response_message.model_dump(by_alias=True))
        )

    async def test_invalid_move_board(self):
        room_service = MagicMock(spec=RoomService)
        game_room = MagicMock(spec=AbstractGameRoom)
        room_service.get_room.return_value = game_room
        player_session = MagicMock()
        player_session.send_message = AsyncMock()

        handler = PlayerMoveRequestHandler(room_service)

        player_room = MagicMock(ChessPlayer)
        player_room.get_session.return_value = player_session
        player_room.get_name.return_value = "player_white"
        player_room.get_side.return_value = "white"

        game_type = "test_invalid_session"
        game_room.get_game_type.return_value = game_type
        game_room.is_legal_move.return_value = (
            "r1bqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"
            == "rrbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"
        )
        game_room.get_players.return_value = [player_room]

        room_name = "invalid_test_session"
        player = {"playerName": "player_white", "playerSide": "white"}
        player_move = {
            "board": [
                ["r", "", "b", "q", "k", "b", "n", "r"],
                ["p", "p", "p", "p", "p", "p", "p", "p"],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["P", "P", "P", "P", "P", "P", "P", "P"],
                ["R", "N", "B", "Q", "K", "B", "N", "R"],
            ],
            "piece": "P",
            "source": {"column": 0, "row": 6},
            "destination": {"column": 0, "row": 5},
        }
        message = {
            "jsonType": "playerMoveRequest",
            "data": {
                "gameType": game_type,
                "roomName": room_name,
                "player": player,
                "player_move": player_move,
            },
        }

        await handler.handle(message, player_session)
        await asyncio.sleep(0.1)

        response_data = PlayerMoveResponseData(
            confirmationStatus="not valid",
            player=player,
            player_move=player_move,
            gameType=game_type,
            roomName=room_name,
        )
        response_message = PlayerMoveResponse(
            jsonType="moveConfirmationResponce", data=response_data
        )

        room_service.get_room.assert_called_once_with(room_name)
        game_room.get_game_type.asser_called_once()
        game_room.get_players.asser_called_once()
        game_room.is_legal_move.assert_called_once()
        player_room.get_session.asser_called_once()
        player_session.send_message.assert_called_once_with(
            json.dumps(response_message.model_dump(by_alias=True))
        )

    async def test_invalid_move_session(self):
        room_service = MagicMock(spec=RoomService)
        game_room = MagicMock(spec=AbstractGameRoom)
        room_service.get_room.return_value = game_room
        player_session = MagicMock()
        player_session.send_message = AsyncMock()

        handler = PlayerMoveRequestHandler(room_service)

        player_room = MagicMock(ChessPlayer)
        player_room.get_session.return_value = MagicMock()
        player_room.name = "player_white"
        player_room.side = "white"

        game_type = "test_invalid_session"
        game_room.get_game_type.return_value = game_type
        game_room.is_legal_move.return_value = lambda x: ChessEngine().is_legal_move(x)
        game_room.get_players.return_value = [player_room]

        room_name = "invalid_test_session"
        player = {"playerName": "player_white", "playerSide": "white"}
        player_move = {
            "board": [
                ["r", "n", "b", "q", "k", "b", "n", "r"],
                ["p", "p", "p", "p", "p", "p", "p", "p"],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["P", "P", "P", "P", "P", "P", "P", "P"],
                ["R", "N", "B", "Q", "K", "B", "N", "R"],
            ],
            "piece": "P",
            "source": {"column": 0, "row": 7},
            "destination": {"column": 0, "row": 7},
        }
        message = {
            "jsonType": "playerMoveRequest",
            "data": {
                "gameType": game_type,
                "roomName": room_name,
                "player": player,
                "player_move": player_move,
            },
        }

        await handler.handle(message, player_session)
        await asyncio.sleep(0.1)

        response_data = PlayerMoveResponseData(
            confirmationStatus="not valid",
            player=player,
            player_move=player_move,
            gameType=game_type,
            roomName=room_name,
        )
        response_message = PlayerMoveResponse(
            jsonType="moveConfirmationResponce", data=response_data
        )

        room_service.get_room.assert_called_once_with(room_name)
        game_room.get_game_type.asser_called_once()
        game_room.get_players.asser_called_once()
        player_room.get_session.asser_called_once()
        player_session.send_message.assert_called_once_with(
            json.dumps(response_message.model_dump(by_alias=True))
        )

    async def test_invalid_move_player(self):
        room_service = MagicMock(spec=RoomService)
        game_room = MagicMock(spec=AbstractGameRoom)
        room_service.get_room.return_value = game_room
        player_session = MagicMock()
        player_session.send_message = AsyncMock()

        handler = PlayerMoveRequestHandler(room_service)

        player_room = MagicMock(ChessPlayer)
        player_room.get_session.return_value = player_session
        player_room.name = "player_whitee"
        player_room.side = "white"

        game_type = "test_invalid_session"
        game_room.get_game_type.return_value = game_type
        game_room.is_legal_move.return_value = True
        game_room.get_players.return_value = [player_room]

        room_name = "invalid_test_session"
        player = {"playerName": "player_white", "playerSide": "white"}
        player_move = {
            "board": [
                ["r", "n", "b", "q", "k", "b", "n", "r"],
                ["p", "p", "p", "p", "p", "p", "p", "p"],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["P", "P", "P", "P", "P", "P", "P", "P"],
                ["R", "N", "B", "Q", "K", "B", "N", "R"],
            ],
            "piece": "P",
            "source": {"column": 0, "row": 6},
            "destination": {"column": 0, "row": 5},
        }
        message = {
            "jsonType": "playerMoveRequest",
            "data": {
                "gameType": game_type,
                "roomName": room_name,
                "player": player,
                "player_move": player_move,
            },
        }

        await handler.handle(message, player_session)
        await asyncio.sleep(0.1)

        response_data = PlayerMoveResponseData(
            confirmationStatus="not valid",
            player=player,
            player_move=player_move,
            gameType=game_type,
            roomName=room_name,
        )
        response_message = PlayerMoveResponse(
            jsonType="moveConfirmationResponce", data=response_data
        )

        room_service.get_room.assert_called_once_with(room_name)
        game_room.get_game_type.asser_called_once()
        game_room.get_players.asser_called_once()
        player_room.get_session.asser_called_once()
        player_session.send_message.assert_called_once_with(
            json.dumps(response_message.model_dump(by_alias=True))
        )

    async def test_invalid_move_room(self):
        room_service = MagicMock(spec=RoomService)
        game_room = MagicMock(spec=AbstractGameRoom)
        room_service.get_room.return_value = None
        player_session = MagicMock()
        player_session.send_message = AsyncMock()

        handler = PlayerMoveRequestHandler(room_service)

        player_room = MagicMock(ChessPlayer)
        player_room.get_session.return_value = player_session
        player_room.name = "player_white"
        player_room.side = "white"

        game_type = "test_invalid_session"
        game_room.get_game_type.return_value = game_type
        game_room.is_legal_move.return_value = True
        game_room.get_players.return_value = [player_room]

        room_name = "invalid_test_session"
        player = {"playerName": "player_white", "playerSide": "white"}
        player_move = {
            "board": [
                ["r", "n", "b", "q", "k", "b", "n", "r"],
                ["p", "p", "p", "p", "p", "p", "p", "p"],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["P", "P", "P", "P", "P", "P", "P", "P"],
                ["R", "N", "B", "Q", "K", "B", "N", "R"],
            ],
            "piece": "P",
            "source": {"column": 0, "row": 6},
            "destination": {"column": 0, "row": 5},
        }
        message = {
            "jsonType": "playerMoveRequest",
            "data": {
                "gameType": game_type,
                "roomName": room_name,
                "player": player,
                "player_move": player_move,
            },
        }

        await handler.handle(message, player_session)
        await asyncio.sleep(0.1)

        response_data = PlayerMoveResponseData(
            confirmationStatus="not valid",
            player=player,
            player_move=player_move,
            gameType=game_type,
            roomName=room_name,
        )
        response_message = PlayerMoveResponse(
            jsonType="moveConfirmationResponce", data=response_data
        )

        room_service.get_room.assert_called_once_with(room_name)
        game_room.get_game_type.asser_called_once()
        game_room.get_players.asser_called_once()
        player_room.get_session.asser_called_once()
        player_session.send_message.assert_called_once_with(
            json.dumps(response_message.model_dump(by_alias=True))
        )

    async def test_invalid_move_game_type(self):
        room_service = MagicMock(spec=RoomService)
        game_room = MagicMock(spec=AbstractGameRoom)
        room_service.get_room.return_value = game_room
        player_session = MagicMock()
        player_session.send_message = AsyncMock()

        handler = PlayerMoveRequestHandler(room_service)

        player_room = MagicMock(ChessPlayer)
        player_room.get_session.return_value = player_session
        player_room.name = "player_white"
        player_room.side = "white"

        game_type = "test_invalid_session"
        game_room.get_game_type.return_value = game_type + "fvs"
        game_room.is_legal_move.return_value = True
        game_room.get_players.return_value = [player_room]

        room_name = "invalid_test_session"
        player = {"playerName": "player_white", "playerSide": "white"}
        player_move = {
            "board": [
                ["r", "n", "b", "q", "k", "b", "n", "r"],
                ["p", "p", "p", "p", "p", "p", "p", "p"],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["", "", "", "", "", "", "", ""],
                ["P", "P", "P", "P", "P", "P", "P", "P"],
                ["R", "N", "B", "Q", "K", "B", "N", "R"],
            ],
            "piece": "P",
            "source": {"column": 0, "row": 6},
            "destination": {"column": 0, "row": 5},
        }
        message = {
            "jsonType": "playerMoveRequest",
            "data": {
                "gameType": game_type,
                "roomName": room_name,
                "player": player,
                "player_move": player_move,
            },
        }

        await handler.handle(message, player_session)
        await asyncio.sleep(0.1)

        response_data = PlayerMoveResponseData(
            confirmationStatus="not valid",
            player=player,
            player_move=player_move,
            gameType=game_type,
            roomName=room_name,
        )
        response_message = PlayerMoveResponse(
            jsonType="moveConfirmationResponce", data=response_data
        )

        room_service.get_room.assert_called_once_with(room_name)
        game_room.get_game_type.asser_called_once()
        game_room.get_players.asser_called_once()
        player_room.get_session.asser_called_once()
        player_session.send_message.assert_called_once_with(
            json.dumps(response_message.model_dump(by_alias=True))
        )
