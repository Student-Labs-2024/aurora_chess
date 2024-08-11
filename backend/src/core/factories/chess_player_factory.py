from core.entities.player.chess_player import ChessPlayer
from core.factories.abstract_player_factory import AbstractPlayerFactory


class ChessPlayerFactory(AbstractPlayerFactory):
    def create_player(self, *args) -> ChessPlayer:
        return ChessPlayer(*args)
