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

    async def handle(self, *args) -> json:
        message: RoomConnectionRequest = RoomConnectionRequest.model_validate(args[0])
        player_session: AbstractPlayerSession = args[1]

        data = message.data
        player_1 = None
        player_2 = None
        player_info = data.player
        room_connection_status = "does not exists"
        room_name = data.room.room_name
        room = await self.__room_service.get_room(room_name)
        if (
            room
            and not await self.__room_service.room_is_full(room_name)
            and player_info.player_side
            == await self.__room_service.free_side(room_name)
        ):
            player: AbstractPlayer = self.__player_factory.create_player(
                player_session,
                player_info.player_name,
                player_info.player_side,
                player_session.user_id,
            )
            player.set_session(player_session)
            await self.__room_service.add_player_to_room(
                room_name, player, player_info.player_side
            )
            player_session.set_player(player)
            player_session.set_current_room(room)
            room_connection_status = "successfully_connected"
            player_1_info = [
                player
                for player in await self.__room_service.get_players(room_name)
                if player.side != player_info.player_side
            ][0]
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

        if room_connection_status == "successfully_connected":
            other_player = [
                player
                for player in await self.__room_service.get_players(room_name)
                if player.side != player_info.player_side
            ][0]

            other_player_session = other_player.get_session()
            await other_player_session.send_message(
                json.dumps(response_message.model_dump(by_alias=True))
            )

        await player_session.send_message(
            json.dumps(response_message.model_dump(by_alias=True))
        )
