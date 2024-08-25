from typing import Literal

from core.entities.player.abstract_player import AbstractPlayer


class ChessPlayer(AbstractPlayer):
    def __init__(
        self,
        player_session,
        name,
        side: Literal["white", "black"],
        user_id,
        user_elo=1000,
        user_age=18,
        user_games=30,
    ):
        super().__init__(player_session, name, side, user_id=user_id)
        self.user_elo = user_elo
        self.user_age = user_age
        self.user_game = user_games

    def get_name(self):
        return self.name

    def get_side(self):
        return self.side
