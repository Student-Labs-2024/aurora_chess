from typing import Literal

from core.engines.chess_engine import ChessEngine
from core.entities.game_room.abstract_game_room import AbstractGameRoom
from core.schemas.move import Move


class GameRoom(AbstractGameRoom):
    def __init__(self, game_type):
        super().__init__(game_type)
        self.id: int | None = None
        self.player_white = None
        self.player_black = None
        self.result: Literal["", "*", "1-0", "0-1", "1/2-1/2"] = ""
        self.creator = None
        self.__engine = ChessEngine()
        self.board: str = self.__engine.board.board_fen()

    def make_move(self, move) -> tuple[bool, str, str]:
        result = self.__engine.make_move(move=move)
        self.board = result[1]
        return result

    def get_board(self):
        return self.__engine.board.board_fen()

    def is_full(self):
        return self.player_black and self.player_white

    def is_legal_move(self, move: Move):
        return self.__engine.is_legal_move(move)[0]

    def is_active(self):
        return self.result

    def start_game(self):
        if not self.result:
            self.result = "*"
