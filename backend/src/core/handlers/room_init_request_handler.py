import json

from core.entities.player.abstract_player import AbstractPlayer
from core.entities.player_session.abstract_player_session import AbstractPlayerSession
from core.factories.abstract_player_factory import AbstractPlayerFactory
from core.handlers.message_handler import MessageHandler
from core.schemas.room_init_request import RoomInitRequest
from core.schemas.room_init_response import RoomInitResponse
from core.services.room_service import RoomService, GameSchema


class RoomInitRequestHandler(MessageHandler):
    def __init__(
        self,
        room_service: RoomService,
        player_factory: AbstractPlayerFactory,
    ):
        self.__room_service: RoomService = room_service
        self.__player_factory: AbstractPlayerFactory = player_factory

    async def handle(self, *args) -> json:
        message = RoomInitRequest.model_validate(args[0])
        player_session: AbstractPlayerSession = args[1]

        data = message.data

        game_type = data.game_type
        room_name = data.room.room_name

        room_schema = {
            "game_type": game_type,
        }

        room_init_status = "already exists"
        room: GameSchema = await self.__room_service.create_room(
            GameSchema.model_validate(room_schema), room_name
        )
        if room:
            player_info = data.player
            player: AbstractPlayer = self.__player_factory.create_player(
                player_session,
                player_info.player_name,
                player_info.player_side,
                player_session.user_id,
            )
            player.set_session(player_session)
            await self.__room_service.add_player_to_room(
                room_name, player, side=player_info.player_side
            )
            player_session.set_player(player)
            player_session.set_current_room(room)
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

        await player_session.send_message(
            json.dumps(response_message.model_dump(by_alias=True))
        )
