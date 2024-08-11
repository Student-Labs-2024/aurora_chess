from typing import Literal

from core.entities.player.abstract_player import AbstractPlayer


class ChessPlayer(AbstractPlayer):
    def __init__(self, player_session, name, side: Literal["white", "black"]):
        super().__init__(player_session)
        self.name = name
        self.side = side

    def get_name(self):
        return self.name

    def get_side(self):
        return self.side
