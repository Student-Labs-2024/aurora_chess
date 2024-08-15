import asyncio
import json

from core.entities.game_room.abstract_game_room import AbstractGameRoom
from core.entities.player_session.abstract_player_session import AbstractPlayerSession
from core.handlers.message_handler import MessageHandler
from core.schemas.player_move_response import PlayerMoveResponse, PlayerMoveResponseData
from core.schemas.room_start_request import RoomStartRequest
from core.schemas.room_start_response import RoomStartResponseData, RoomStartResponse
from core.services.room_service import RoomService
from utils.chess_board import fen_to_list_board


class RoomStartRequestHandler(MessageHandler):
    def __init__(
        self,
        room_service: RoomService,
    ):
        self.__room_service: RoomService = room_service

    def __is_owner(self, room, player, session):
        owner = room.get_owner()
        return (
            owner.get_side() == player.player_side
            and owner.get_name() == player.player_name
            and owner.get_session() == session
        )

    async def handle(self, *args) -> json:
        message = RoomStartRequest.model_validate(args[0])
        player_session: AbstractPlayerSession = args[1]

        data = message.data

        game_type = data.game_type
        room_name = data.room_name
        player_info = data.player

        room: AbstractGameRoom = self.__room_service.get_room(room_name)

        if not (
            room
            and not room.is_active()
            and room.is_full()
            and self.__is_owner(room, player_info, player_session)
        ):
            response_data = RoomStartResponseData(
                confirmationStatus="not valid",
                gameType=game_type,
                roomName=room_name,
            )
            response_message = RoomStartResponse(
                jsonType="roomStartResponse", data=response_data
            )
            await player_session.send_message(
                json.dumps(response_message.model_dump(by_alias=True))
            )
            return

        room.start_game()

        response_data = RoomStartResponseData(
            confirmationStatus="confirmed",
            gameType=game_type,
            roomName=room_name,
            board=fen_to_list_board(room.get_board()),
            players=[
                {"playerName": player.get_name(), "playerSide": player.get_side()}
                for player in room.get_players()
            ],
        )
        response_message = RoomStartResponse(
            jsonType="roomStartResponse", data=response_data
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
            json.dumps(response_message.model_dump(by_alias=True))
        )
