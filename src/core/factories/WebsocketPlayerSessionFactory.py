from core.entities.PlayerSession.WebsocketPlayerSession import WebsocketPlayerSession
from core.factories.AbstractPlayerSessionFactory import PlayerSessionFactory


class WebsocketPlayerSessionFactory(PlayerSessionFactory):
    def create_session(self, *args) -> WebsocketPlayerSession:
        return WebsocketPlayerSession(*args)
