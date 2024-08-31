from core.entities.player_session.websocket_player_session import WebsocketPlayerSession


class WebsocketAuthPlayerSession(WebsocketPlayerSession):
    def __init__(
        self,
        connection,
        user_id,
        username,
        user_age=18,
        user_games=30,
    ):
        super().__init__(connection)
        self.user_id = user_id
        self.user_elo = None
        self.user_age = user_age
        self.user_games = user_games
        self.username = username
