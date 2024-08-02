import json

from fastapi import APIRouter, WebSocket, WebSocketDisconnect

from dependencies import message_dispatcher

router = APIRouter(
    tags=["Chess"]
)


@router.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    try:
        message_json: json = await websocket.receive_json()
        message = json.loads(message_json)
        json_type = message["jsonType"]
        message_dispatcher.get_handler(json_type).handle(message, websocket)
    except WebSocketDisconnect:
        pass
