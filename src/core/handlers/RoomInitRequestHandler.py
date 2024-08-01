import asyncio
import json

from core.entities.GameRoom import AbstractGameRoom
from core.entities.PlayerSession.AbstractPlayerSession import AbstractPlayerSession
from core.factories import AbstractPlayerSessionFactory
from core.handlers.MessageHandler import MessageHandler
from core.schemas.RoomInitRequest import RoomInitRequest
from core.schemas.RoomInitResponse import RoomInitResponse
from core.services.RoomService import RoomService


class RoomInitRequestHandler(MessageHandler):
    def __init__(self, room_service: RoomService, player_session_factory: AbstractPlayerSessionFactory):
        self.__room_service: RoomService = room_service
        self.__player_session_factory: AbstractPlayerSessionFactory = player_session_factory

    def handle(self, *args) -> json:
        message = RoomInitRequest.model_validate(args[0])
        connection = args[1]

        data = message.data

        player_info = data.player
        player: AbstractPlayerSession = self.__player_session_factory.create_session(player_info.player_name,
                                                                                     player_info.player_side,
                                                                                     connection)
        game_type = data.game_type
        room_name = data.room.room_name
        room: AbstractGameRoom = self.__room_service.get_room(room_name)
        if room:
            room_init_status = "already exists"
        else:
            self.__room_service.create_room(room_name, game_type)
            room: AbstractGameRoom = self.__room_service.get_room(room_name)
            room.add_player(player)
            room_init_status = "successfully created"

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
        loop.create_task(player.send_message(json.dumps(response_message.model_dump(by_alias=True))))
