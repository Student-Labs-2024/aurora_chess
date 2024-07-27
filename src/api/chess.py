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
        responce_message = message_dispatcher.get_handler(json_type).handle(message, websocket)
        await websocket.send_json(json.dumps(responce_message))
    except WebSocketDisconnect:
        pass
