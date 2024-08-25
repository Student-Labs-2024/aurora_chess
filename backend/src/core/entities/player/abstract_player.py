from abc import ABC


class AbstractPlayer(ABC):
    def __init__(self, player_session, name, side, user_id):
        self.player_session = player_session
        self.name = name
        self.side = side
        self.user_id = user_id

    def get_session(self):
        return self.player_session

    def set_session(self, player_session):
        self.player_session = player_session
