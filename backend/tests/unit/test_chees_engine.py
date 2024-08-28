import unittest

import chess

from core.engines.chess_engine import ChessEngine
from core.schemas.move import Move


class TestChessEngine(unittest.TestCase):
    def setUp(self):
        self.engine = ChessEngine()

    def test_can_make_move(self):
        move = Move(
            from_square="e2",
            to_square="e4",
            piece="P",
            board="rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR",
            color="white",
        )
        success, board, game_state = self.engine.make_move(move)
        self.assertTrue(success)
        self.assertEqual(board, "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR")
        self.assertEqual(game_state, "*")

        move = {
            "from_square": "e7",
            "to_square": "e5",
            "piece": "p",
            "board": "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR",
            "color": "black",
        }
        move = Move.model_validate(move)
        success, board, game_state = self.engine.make_move(move)
        self.assertTrue(success)
        self.assertEqual(board, "rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR")
        self.assertEqual(game_state, "*")

    def test_cant_make_move_incorrect_step(self):
        move = {
            "from_square": "e2",
            "to_square": "e5",
            "piece": "P",
            "board": "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR",
            "color": "black",
        }
        move = Move.model_validate(move)
        success, board, game_state = self.engine.make_move(move)
        self.assertFalse(success)
        self.assertEqual(board, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR")
        self.assertEqual(game_state, "Illegal move")

    def test_cant_make_move_incorrect_board(self):
        move = {
            "from_square": "e2",
            "to_square": "e5",
            "piece": "P",
            "board": "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBN1",
            "color": "black",
        }
        move = Move.model_validate(move)
        success, board, game_state = self.engine.make_move(move)
        self.assertFalse(success)
        self.assertEqual(board, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR")
        self.assertEqual(game_state, "Illegal move")

    def test_cant_make_move_no_piece(self):
        self.engine.board.set_board_fen("rnbqkbnr/pppppppp/8/8/8/8/1PPPPPPP/RNBQKBNR")
        move = {
            "from_square": "a2",
            "to_square": "a4",
            "piece": "P",
            "board": "rnbqkbnr/pppppppp/8/8/8/8/1PPPPPPP/RNBQKBNR",
            "color": "black",
        }
        move = Move.model_validate(move)
        success, board, game_state = self.engine.make_move(move)
        self.assertFalse(success)
        self.assertEqual(board, "rnbqkbnr/pppppppp/8/8/8/8/1PPPPPPP/RNBQKBNR")
        self.assertEqual(game_state, "Illegal move")

    def test_pawn_under_attack(self):
        move = {
            "from_square": "e4",
            "to_square": "d5",
            "piece": "P",
            "board": "rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR",
            "color": "white",
        }
        move = Move.model_validate(move)
        self.engine.board = chess.Board(
            "rnbqkbnr/ppp1pppp/8/3p4/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 1"
        )
        success, board, game_state = self.engine.make_move(move)
        self.assertTrue(success)
        self.assertEqual(board, "rnbqkbnr/ppp1pppp/8/3P4/8/8/PPPP1PPP/RNBQKBNR")
        self.assertEqual(game_state, "*")

    def test_scholars_mate(self):
        move = {
            "from_square": "e2",
            "to_square": "e4",
            "piece": "P",
            "board": "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR",
            "color": "white",
        }
        move = Move.model_validate(move)
        success, board, game_state = self.engine.make_move(move)
        self.assertTrue(success)
        self.assertEqual(board, "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR")
        self.assertEqual(game_state, "*")

        move = {
            "from_square": "e7",
            "to_square": "e5",
            "piece": "p",
            "board": "rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR",
            "color": "black",
        }
        move = Move.model_validate(move)
        success, board, game_state = self.engine.make_move(move)
        self.assertTrue(success)
        self.assertEqual(board, "rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR")
        self.assertEqual(game_state, "*")

        move = {
            "from_square": "d1",
            "to_square": "h5",
            "piece": "Q",
            "board": "rnbqkbnr/pppp1ppp/8/4p3/4P3/8/PPPP1PPP/RNBQKBNR",
            "color": "white",
        }
        move = Move.model_validate(move)
        success, board, game_state = self.engine.make_move(move)
        self.assertTrue(success)
        self.assertEqual(board, "rnbqkbnr/pppp1ppp/8/4p2Q/4P3/8/PPPP1PPP/RNB1KBNR")
        self.assertEqual(game_state, "*")

        move = {
            "from_square": "b8",
            "to_square": "c6",
            "piece": "n",
            "board": "rnbqkbnr/pppp1ppp/8/4p2Q/4P3/8/PPPP1PPP/RNB1KBNR",
            "color": "black",
        }
        move = Move.model_validate(move)
        success, board, game_state = self.engine.make_move(move)
        self.assertTrue(success)
        self.assertEqual(board, "r1bqkbnr/pppp1ppp/2n5/4p2Q/4P3/8/PPPP1PPP/RNB1KBNR")
        self.assertEqual(game_state, "*")

        move = {
            "from_square": "f1",
            "to_square": "c4",
            "piece": "B",
            "board": "r1bqkbnr/pppp1ppp/2n5/4p2Q/4P3/8/PPPP1PPP/RNB1KBNR",
            "color": "white",
        }
        move = Move.model_validate(move)
        success, board, game_state = self.engine.make_move(move)
        self.assertTrue(success)
        self.assertEqual(board, "r1bqkbnr/pppp1ppp/2n5/4p2Q/2B1P3/8/PPPP1PPP/RNB1K1NR")
        self.assertEqual(game_state, "*")

        move = {
            "from_square": "g8",
            "to_square": "f6",
            "piece": "n",
            "board": "r1bqkbnr/pppp1ppp/2n5/4p2Q/2B1P3/8/PPPP1PPP/RNB1K1NR",
            "color": "black",
        }
        move = Move.model_validate(move)
        success, board, game_state = self.engine.make_move(move)
        self.assertTrue(success)
        self.assertEqual(
            board, "r1bqkb1r/pppp1ppp/2n2n2/4p2Q/2B1P3/8/PPPP1PPP/RNB1K1NR"
        )
        self.assertEqual(game_state, "*")

        move = {
            "from_square": "h5",
            "to_square": "f7",
            "piece": "Q",
            "board": "r1bqkb1r/pppp1ppp/2n2n2/4p2Q/2B1P3/8/PPPP1PPP/RNB1K1NR",
            "color": "white",
        }
        move = Move.model_validate(move)
        success, board, game_state = self.engine.make_move(move)
        self.assertTrue(success)
        self.assertEqual(board, "r1bqkb1r/pppp1Qpp/2n2n2/4p3/2B1P3/8/PPPP1PPP/RNB1K1NR")
        self.assertEqual(game_state, "1-0")

    def test_pat(self):
        self.engine.board.set_board_fen("4k3/4P3/3K4/8/8/8/8/8")
        move = {
            "from_square": "d6",
            "to_square": "e6",
            "piece": "K",
            "board": "4k3/4P3/3K4/8/8/8/8/8",
            "color": "white",
        }
        move = Move.model_validate(move)
        success, board, game_state = self.engine.make_move(move)
        self.assertTrue(success)
        self.assertEqual(board, "4k3/4P3/4K3/8/8/8/8/8")
        self.assertEqual(game_state, "1/2-1/2")

    def test_not_enough_pieces_two_kings(self):
        self.engine.board.set_board_fen("8/8/3k4/8/8/3K4/8/8")
        self.assertEqual(self.engine.get_game_status(), "1/2-1/2")

    def test_not_enough_pieces_two_kings_and_knight(self):
        self.engine.board.set_board_fen("8/8/3k4/8/8/1N1K4/8/8")
        self.assertEqual(self.engine.get_game_status(), "1/2-1/2")

    def test_promote_pawn(self):
        self.engine.board.set_board_fen("8/P7/3k4/8/8/1N1K4/p7/8")
        move = {
            "from_square": "a7",
            "to_square": "a8",
            "piece": "P",
            "board": "8/P7/3k4/8/8/1N1K4/p7/8",
            "color": "white",
            "promotion": "n",
        }
        move = Move.model_validate(move)
        success, board, game_state = self.engine.make_move(move)
        self.assertTrue(success)
        self.assertEqual(board, "N7/8/3k4/8/8/1N1K4/p7/8")
        self.assertEqual(game_state, "*")

        move = {
            "from_square": "a2",
            "to_square": "a1",
            "piece": "p",
            "board": "N7/8/3k4/8/8/1N1K4/p7/8",
            "color": "black",
            "promotion": "n",
        }
        move = Move.model_validate(move)
        success, board, game_state = self.engine.make_move(move)
        self.assertTrue(success)
        self.assertEqual(board, "N7/8/3k4/8/8/1N1K4/8/n7")
        self.assertEqual(game_state, "*")
