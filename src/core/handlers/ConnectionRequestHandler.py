import asyncio
import json

from core.entities.AbstractPlayerSession import AbstractPlayerSession
from core.factories import AbstractPlayerSessionFactory
from core.handlers.MessageHandler import MessageHandler
from core.schemas.RoomConnectionRequest import RoomConnectionRequest
from core.services.RoomService import RoomService


class ConnectionRequestHandler(MessageHandler):
    def __init__(self, room_service: RoomService, player_session_factory):
        self.__room_service = room_service
        self.__player_session_factory: AbstractPlayerSessionFactory = player_session_factory

    def handle(self, *args) -> json:
        message: RoomConnectionRequest = RoomConnectionRequest.model_validate(args[0])
        connection: object = args[1]

        data = message.data
        player_1 = None
        player_2 = None
        player_info = data.player
        player: AbstractPlayerSession = self.__player_session_factory.create_session(player_info.player_name,
                                                                                     player_info.player_side,
                                                                                     connection)
        room_connection_status = "does not exists"
        room_name = data.room.room_name
        room = self.__room_service.get_room(room_name)
        if room and not room.is_full() and player_info.player_side in room.free_colors():
            room.add_player(player)
            room_connection_status = "successfully_connected"
            player_1_info = room.get_players()[0]
            player_1 = {"name": player_1_info.name, "side": player_1_info.side}
            player_2 = {"name": player_info.player_name, "side": player_info.player_side}

        game_type = data.game_type
        responce_message_connect = {
            "jsonType": "roomConnectionResponce",
            "data": {
                "gameType": game_type,
                "room": {
                    "roomName": room_name,
                },
                "roomConnectionStatus": room_connection_status,
                "players": {
                    "roomCreator": player_1,
                    "connectedPlayer": player_2,
                }
            },
        }
        loop = asyncio.get_event_loop()
        loop.create_task(player.send_message(json.dumps(responce_message_connect)))
