ELO_DELTA_THRESHOLD = 400
RATING_THRESHOLD_1 = 2400
RATING_THRESHOLD_2 = 2300
DEFAULT_PLAYER_AGE = 18
DEFAULT_GAMES_PLAYED = 30


def calculate_expection_score(player_elo: int, opponent_elo: int) -> float:
    if abs(opponent_elo - player_elo) > ELO_DELTA_THRESHOLD:
        if opponent_elo - player_elo < 0:
            elo_delta = -ELO_DELTA_THRESHOLD
        else:
            elo_delta = ELO_DELTA_THRESHOLD
    else:
        elo_delta = opponent_elo - player_elo

    return round(1 / (1 + 10 ** (elo_delta / ELO_DELTA_THRESHOLD)), 2)


def k_factor(
    rating: int,
    player_age: int = DEFAULT_PLAYER_AGE,
    games_played: int = DEFAULT_GAMES_PLAYED,
) -> int:
    if rating >= RATING_THRESHOLD_1:
        return 10
    elif (
        games_played < DEFAULT_GAMES_PLAYED
        or rating < RATING_THRESHOLD_2
        and player_age < DEFAULT_PLAYER_AGE
    ):
        return 40
    else:
        return 20


def calculate_new_elo(
    player_elo: int,
    opponent_elo: int,
    score: float,
    player_age: int = DEFAULT_PLAYER_AGE,
    games_played: int = DEFAULT_GAMES_PLAYED,
) -> int:
    expection_score = calculate_expection_score(player_elo, opponent_elo)
    k = k_factor(player_elo, player_age, games_played)
    return round(player_elo + k * (score - expection_score))
