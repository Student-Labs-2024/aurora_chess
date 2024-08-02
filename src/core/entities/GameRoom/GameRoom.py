from core.entities.GameRoom.AbstractGameRoom import AbstractGameRoom


class GameRoom(AbstractGameRoom):
    def __init__(self, room_name, game_type):
        super().__init__(room_name, game_type)
        self.players = []

    def make_move(self, move) -> None:
        pass

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
