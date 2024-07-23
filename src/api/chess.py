from fastapi import APIRouter, WebSocket


router = APIRouter(
    tags=["Chess"]
)


@router.websocket("/ws")
async def websoket_endpoint(websocket: WebSocket):
    pass
