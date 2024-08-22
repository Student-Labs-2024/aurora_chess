def calculate_expection_score(player_elo: int, opponent_elo: int):
    if abs(opponent_elo - player_elo) > 400:
        if opponent_elo - player_elo < 0:
            elo_delta = -400
        else:
            elo_delta = 400
    else:
        elo_delta = opponent_elo - player_elo

    return round(1 / (1 + 10 ** (elo_delta / 400)), 2)


def k_factor(rating: int, player_age: int = 18, games_played: int = 30) -> int:
    if rating >= 2400:
        return 10
    elif games_played < 30 or rating < 2300 and player_age < 18:
        return 40
    else:
        return 20


def calculate_new_elo(
    player_elo: int,
    opponent_elo: int,
    score: float,
    player_age: int = 18,
    games_played: int = 30,
):
    expection_score = calculate_expection_score(player_elo, opponent_elo)
    k = k_factor(player_elo, player_age, games_played)
    print(k)
    print(expection_score)
    return round(player_elo + k * (score - expection_score))


elo_w = 2800
elo_b = 1500

score_w = 0

print(calculate_new_elo(elo_w, elo_b, score_w))
