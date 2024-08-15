import asyncio
import json

from core.entities.game_room.abstract_game_room import AbstractGameRoom
from core.entities.player.chess_player import ChessPlayer
from core.entities.player_session.abstract_player_session import AbstractPlayerSession
from core.handlers.message_handler import MessageHandler
from core.schemas.player_move_request import PlayerMoveRequest
from core.schemas.player_move_response import PlayerMoveResponse, PlayerMoveResponseData
from core.services.room_service import RoomService
from utils.chess_board import interpritation_move, fen_to_list_board


class PlayerMoveRequestHandler(MessageHandler):
    def __init__(
        self,
        room_service: RoomService,
    ):
        self.__room_service: RoomService = room_service

    def __is_valid_player(
        self, room: AbstractGameRoom, player, player_session: AbstractPlayerSession
    ):
        players: list[ChessPlayer] = room.get_players()
        for room_player in players:
            if (
                room_player.get_name() == player.player_name
                and room_player.get_side() == player.player_side
                and room_player.get_session() is player_session
            ):
                return True
        return False

    async def handle(self, *args) -> json:
        message = PlayerMoveRequest.model_validate(args[0])
        player_session: AbstractPlayerSession = args[1]

        data = message.data

        game_type = data.game_type
        room_name = data.room_name
        player_info = data.player
        player_move = data.player_move

        chess_move = interpritation_move(player_move, player_info.player_side)

        room: AbstractGameRoom = self.__room_service.get_room(room_name)

        if not (
            room
            and room.is_active()
            and room.get_game_type() == game_type
            and self.__is_valid_player(room, player_info, player_session)
            and room.is_legal_move(chess_move)
        ):
            response_data = PlayerMoveResponseData(
                confirmationStatus="not valid",
                player=data.player,
                player_move=data.player_move,
                gameType=game_type,
                roomName=room_name,
            )
            response_message = PlayerMoveResponse(
                jsonType="moveConfirmationResponce", data=response_data
            )
            await player_session.send_message(
                json.dumps(response_message.model_dump(by_alias=True))
            )
            return

        status, new_board_fen, game_status = room.make_move(chess_move)
        response_data = PlayerMoveResponseData(
            confirmationStatus="confirmed",
            player=data.player,
            player_move=data.player_move,
            gameType=game_type,
            gameStatus=game_status,
            roomName=room_name,
        )
        response_message = PlayerMoveResponse(
            jsonType="moveConfirmationResponce", data=response_data
        )
        response_message.data.player_move.board = fen_to_list_board(new_board_fen)
        to_other_player_message = PlayerMoveResponse(
            jsonType="enemysMove", data=response_data
        )
        other_player_session = [
            player.get_session()
            for player in room.get_players()
            if player.get_session() != player_session
        ][0]

        await player_session.send_message(
            json.dumps(response_message.model_dump(by_alias=True))
        )

        await other_player_session.send_message(
            json.dumps(to_other_player_message.model_dump(by_alias=True))
        )
