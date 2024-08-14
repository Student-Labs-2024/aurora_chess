from core.schemas.move import Move
from core.schemas.player_move import PlayerMove


def fen_to_list_board(board_fen):
    board_list = []
    rows = board_fen.split("/")
    for row in rows:
        board_row = []
        for char in row:
            if char.isdigit():
                board_row.extend([""] * int(char))
            else:
                board_row.append(char)
        board_list.append(board_row)
    return board_list


def list_to_fen_board(board_list: [[str]]):
    board_fen = ""
    empty_count = 0
    for row in board_list:
        for piece in row:
            if piece == "":
                empty_count += 1
            else:
                if empty_count > 0:
                    board_fen += str(empty_count)
                    empty_count = 0
                board_fen += piece
        if empty_count > 0:
            board_fen += str(empty_count)
            empty_count = 0
        board_fen += "/"
    return board_fen[:-1]


def cell_to_chess_notation(row, col):
    columns = "abcdefgh"
    rows = "87654321"
    return columns[col] + rows[row]


def interpritation_move(player_move: PlayerMove, player_side) -> Move:
    board = list_to_fen_board(player_move.board)
    from_square = cell_to_chess_notation(
        player_move.source.row, player_move.source.column
    )
    to_square = cell_to_chess_notation(
        player_move.destination.row, player_move.destination.column
    )
    piece = player_move.piece
    promotion = player_move.promotion
    move = {
        "from_square": from_square,
        "to_square": to_square,
        "piece": piece,
        "color": player_side,
        "board": board,
        "promotion": promotion,
    }
    return Move.model_validate(move)
