import asyncio
import json

from core.entities.game_room.abstract_game_room import AbstractGameRoom
from core.entities.player.abstract_player import AbstractPlayer
from core.entities.player_session.abstract_player_session import AbstractPlayerSession
from core.factories.abstract_player_factory import AbstractPlayerFactory
from core.handlers.message_handler import MessageHandler
from core.schemas.room_init_request import RoomInitRequest
from core.schemas.room_init_response import RoomInitResponse
from core.services.room_service import RoomService


class RoomInitRequestHandler(MessageHandler):
    def __init__(
        self,
        room_service: RoomService,
        player_factory: AbstractPlayerFactory,
    ):
        self.__room_service: RoomService = room_service
        self.__player_factory: AbstractPlayerFactory = player_factory

    def handle(self, *args) -> json:
        message = RoomInitRequest.model_validate(args[0])
        player_session: AbstractPlayerSession = args[1]

        data = message.data

        game_type = data.game_type
        room_name = data.room.room_name

        room_init_status: str = self.__room_service.create_room(room_name, game_type)
        if room_init_status == "successfully created":
            room: AbstractGameRoom = self.__room_service.get_room(room_name)
            player_info = data.player
            player: AbstractPlayer = self.__player_factory.create_player(
                player_session, player_info.player_name, player_info.player_side
            )
            player.set_session(player_session)
            room.add_player(player)
            player_session.set_player(player)
            player_session.set_current_room(room)

        response_message = {
            "jsonType": "roomInitResponse",
            "data": {
                "gameType": game_type,
                "roomName": room_name,
                "roomInitStatus": room_init_status,
            },
        }

        response_message = RoomInitResponse.model_validate(response_message)

        loop = asyncio.get_event_loop()
        loop.create_task(
            player_session.send_message(
                json.dumps(response_message.model_dump(by_alias=True))
            )
        )
