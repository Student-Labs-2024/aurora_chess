import json

from fastapi import APIRouter, WebSocket, WebSocketDisconnect

from core.entities.player_session.websocket_player_session import WebsocketPlayerSession
from dependencies import message_dispatcher

router = APIRouter(tags=["Chess"])


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
        pass
