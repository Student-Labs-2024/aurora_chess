import json

from core.handlers.message_handler import MessageHandler
from core.schemas.unknown_message_response import UnknownMessageResponse


class DefaultHandler(MessageHandler):

    async def handle(self, *args) -> None:
        player_session = args[1]

        response_message = UnknownMessageResponse(jsonType="unknownMessage")
        await player_session.send_message(
            json.dumps(response_message.model_dump(by_alias=True))
        )
