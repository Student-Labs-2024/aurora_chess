import asyncio
import json

from core.entities.player.abstract_player import AbstractPlayer
from core.entities.player_session.abstract_player_session import AbstractPlayerSession
from core.factories.abstract_player_factory import AbstractPlayerFactory
from core.handlers.message_handler import MessageHandler
from core.schemas.room_connection_request import RoomConnectionRequest
from core.schemas.room_connection_response import RoomConnectionResponse
from core.services.room_service import RoomService


class ConnectionRequestHandler(MessageHandler):
    def __init__(self, room_service: RoomService, player_factory):
        self.__room_service = room_service
        self.__player_factory: AbstractPlayerFactory = player_factory

    def handle(self, *args) -> json:
        message: RoomConnectionRequest = RoomConnectionRequest.model_validate(args[0])
        player_session: AbstractPlayerSession = args[1]

        data = message.data
        player_1 = None
        player_2 = None
        player_info = data.player
        room_connection_status = "does not exists"
        room_name = data.room.room_name
        room = self.__room_service.get_room(room_name)
        if (
            room
            and not room.is_full()
            and player_info.player_side in room.free_colors()
        ):
            player: AbstractPlayer = self.__player_factory.create_player(
                player_session, player_info.player_name, player_info.player_side
            )
            player.set_session(player_session)
            room.add_player(player)
            player_session.set_player(player)
            player_session.set_current_room(room)
            room_connection_status = "successfully_connected"
            player_1_info = room.get_players()[0]
            player_1 = {
                "playerName": player_1_info.name,
                "playerSide": player_1_info.side,
            }
            player_2 = {
                "playerName": player_info.player_name,
                "playerSide": player_info.player_side,
            }

        game_type = data.game_type
        response_message = {
            "jsonType": "roomConnectionResponse",
            "data": {
                "gameType": game_type,
                "room": {
                    "roomName": room_name,
                },
                "roomConnectionStatus": room_connection_status,
                "players": {
                    "roomCreator": player_1,
                    "connectedPlayer": player_2,
                },
            },
        }
        response_message = RoomConnectionResponse.model_validate(response_message)

        loop = asyncio.get_event_loop()
        if room_connection_status == "successfully_connected":
            owner = room.get_players()[0].get_session()
            loop.create_task(
                owner.send_message(
                    json.dumps(response_message.model_dump(by_alias=True))
                )
            )

        loop.create_task(
            player_session.send_message(
                json.dumps(response_message.model_dump(by_alias=True))
            )
        )
