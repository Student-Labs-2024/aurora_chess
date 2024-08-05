from core.entities.player_session.websocket_player_session import WebsocketPlayerSession
from core.factories.abstract_player_session_factory import PlayerSessionFactory


class WebsocketPlayerSessionFactory(PlayerSessionFactory):
    def create_session(self, *args) -> WebsocketPlayerSession:
        return WebsocketPlayerSession(*args)
