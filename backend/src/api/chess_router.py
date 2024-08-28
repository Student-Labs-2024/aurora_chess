import json
import random

from fastapi import (
    APIRouter,
    WebSocket,
    WebSocketDisconnect,
    Depends,
    WebSocketException,
)
from sqlalchemy.ext.asyncio import AsyncSession

from api.auth_router import get_current_auth_user
from core.database.db_helper import db_helper
from core.entities.player_session.websocket_auth_player_session import (
    WebsocketAuthPlayerSession,
)
from core.entities.player_session.websocket_player_session import WebsocketPlayerSession
from core.factories.chess_player_factory import ChessPlayerFactory
from core.schemas.user import User
from core.services.rating_service import get_rating_by_user_id, RatingSchema
from core.services.room_service import GameSchema
from dependencies import message_dispatcher, rooms_service

from core.services import user_service as crud
from api import utils as auth_utils
from jwt.exceptions import InvalidTokenError


router = APIRouter(tags=["Chess"])


@router.get("/my_rating/", response_model=RatingSchema)
async def user_check_self_rating(
    db: AsyncSession = Depends(db_helper.session_getter),
    user: User = Depends(get_current_auth_user),
):
    return await get_rating_by_user_id(db, user.id)


@router.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    player_session = WebsocketPlayerSession(websocket)
    try:
        message_json: json = await websocket.receive_json()
        message = json.loads(message_json)
        json_type = message["jsonType"]
        await message_dispatcher.get_handler(json_type).handle(message, player_session)
    except WebSocketDisconnect:
        player = player_session.get_player()
        player.set_session(None)


class QueuePlayers:
    def __init__(self):
        self.queue: dict[int, WebsocketAuthPlayerSession] = dict()

    def find_opponent(self, player):
        player_elo = player.user_elo
        for opponent_elo in self.queue.keys():
            if abs(opponent_elo - player_elo) < 200:
                opponent = self.queue[opponent_elo]
                del self.queue[opponent_elo]
                return opponent

    def add_to_wait(self, player):
        self.queue[player.user_elo] = player


queue = QueuePlayers()


async def get_auth_user(token: str) -> User | None:
    if not token:
        raise WebSocketException(code=401, reason="Unauthorized")
    try:
        payload = auth_utils.decode_jwt(token=token)
    except InvalidTokenError as e:
        raise WebSocketException(
            code=401, reason=f"Unauthorized.invalid token error: {e}"
        )
    email: str | None = payload.get("sub")
    user = await crud.get_user_by_email(Depends(db_helper.session_getter), email)
    if not user:
        raise WebSocketException(
            code=401, reason="Unauthorized.token invalid (user not found)"
        )
    return user


@router.websocket("/ws/rating")
async def websocket_endpoint(websocket: WebSocket):
    token = websocket.headers.get("Authorization")

    user = await get_auth_user(token)

    await websocket.accept()
    player_session = WebsocketAuthPlayerSession(websocket, user.id, user.username)
    player_session.user_elo = get_rating_by_user_id(
        db=Depends(db_helper.session_getter), user_id=user.id
    )

    opponent_session = queue.find_opponent(player_session)
    if not opponent_session:
        queue.add_to_wait(player_session)
    else:
        room: GameSchema = GameSchema.model_validate({"game_type": "mm"})
        room = rooms_service.create_room(room)
        room_id = room.id
        factory = ChessPlayerFactory()
        sides = ["white", "black"]
        random_side = random.choice(sides)
        sides.remove(random_side)

        player = (
            factory.create_player(
                player_session,
                user.username,
                random_side,
                player_session.user_id,
            ),
        )
        player_session.set_player(player)
        rooms_service.add_player_to_room(room_id, player)

        rooms_service.add_player_to_room(
            room_id,
            factory.create_player(
                opponent_session,
                opponent_session.username,
                sides[0],
                opponent_session.user_id,
            ),
        )
        rooms_service.start_game(room_id)

        message = {
            "jsonType": "gameStart",
            "data": {
                "gameType": "mm",
                "gameID": room_id,
                "players": {
                    random_side: player_session.username,
                    sides[0]: opponent_session.username,
                },
                "board": rooms_service.get_board(room_id),
            },
        }

        await player_session.send_message(message)
        await opponent_session.send_message(message)

    try:
        message_json: json = await websocket.receive_json()
        message = json.loads(message_json)
        json_type = message["jsonType"]
        await message_dispatcher.get_handler(json_type).handle(message, player_session)
    except WebSocketDisconnect:
        player = player_session.get_player()
        player.set_session(None)
