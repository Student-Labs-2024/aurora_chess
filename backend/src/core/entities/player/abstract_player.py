from abc import ABC


class AbstractPlayer(ABC):
    def __init__(self, player_session):
        self.player_session = player_session

    def get_session(self):
        return self.player_session

    def set_session(self, player_session):
        self.player_session = player_session
