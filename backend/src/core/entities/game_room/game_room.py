from typing import Literal

from core.engines.chess_engine import ChessEngine
from core.entities.game_room.abstract_game_room import AbstractGameRoom
from core.schemas.move import Move


class GameRoom(AbstractGameRoom):
    def __init__(self, room_name, game_type):
        super().__init__(room_name, game_type)
        self.players = []
        self.__engine = ChessEngine()
        self.game_status: Literal["waiting", "active"] = "waiting"

    def make_move(self, move) -> tuple[bool, str, str]:
        return self.__engine.make_move(move=move)

    def finish_game(self) -> None:
        pass

    def get_board(self):
        pass

    def add_player(self, player):
        self.players.append(player)

    def is_full(self) -> bool:
        return len(self.players) == 2

    def free_colors(self):
        colors = ["white", "black"]
        for player in self.players:
            print(player.side)
            colors.remove(player.side)
        return colors

    def get_players(self):
        return self.players

    def is_legal_move(self, move: Move):
        return self.__engine.is_legal_move(move)[0]

    def is_active(self):
        return self.game_status == "active"
