from copy import deepcopy

import chess

from core.schemas.move import Move


class ChessEngine:
    def __init__(self):
        self.board = chess.Board()
        self.moves: list[Move] = []

    def is_legal_move(self, move: Move):
        piece = (
            move.piece[0].upper()
            if move.color[0].lower() == "w"
            else move.piece[0].lower()
        )
        uci_move = move.from_square + move.to_square
        if (piece == "p" or piece == "P") and move.promotion:
            uci_move += move.promotion[0].lower()

        current_piece = None
        if self.board.piece_at(chess.parse_square(move.from_square)):
            current_piece = self.board.piece_at(
                chess.parse_square(move.from_square)
            ).symbol()

        chess_move = chess.Move.from_uci(uci_move)
        if not (
            current_piece
            and chess_move in self.board.legal_moves
            and move.board == self.board.board_fen()
            and piece == current_piece
            and self.board.fen().split(" ")[1] == move.color[0].lower()
        ):
            return False, chess_move
        return True, chess_move

    def make_move(self, move: Move):
        is_valid_move, chess_move = self.is_legal_move(move)
        if not is_valid_move:
            return False, self.board.board_fen(), "Illegal move"
        self.board.push(chess_move)
        self.moves.append(move)
        new_fen = self.board.board_fen()
        status = self.get_game_status()
        return True, new_fen, status

    def get_game_status(self):
        result = self.board.result()
        if result == "1-0":
            return "white victory"
        elif result == "0-1":
            return "black victory"
        elif result == "1/2-1/2":
            return "draw"
        return "game in progress"

    def get_moves(self) -> list[Move]:
        return deepcopy(self.moves)