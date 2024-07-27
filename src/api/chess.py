import json
from typing import Literal

from fastapi import APIRouter, WebSocket

router = APIRouter(
    tags=["Chess"]
)


class Player:
    def __init__(self, name: str, side: Literal["white", "black"]):
        self.name = name
        self.side = side


rooms = dict()


@router.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    try:
        message_json: json = await websocket.receive_json()
        message = json.loads(message_json)
        json_type = message["jsonType"]
        responce_message = message_dispatcher.get_handler(json_type).handle(message, websocket)
        await websocket.send_json(json.dumps(responce_message))

    elif first_message["jsonType"] == "roomConnectionRequest":
        '''request_message_connect = {
            "jsonType": "roomConnectionRequest",
            "data": {
                "gameType": game_type,
                "room": {
                    "roomName": room_name
                },
                "player": {
                    "playerName": player_name_2,
                    "playerSide": side_2
                }
            },
        }'''
        room_name = first_message_data["room"]["roomName"]
        player_1 = None
        player_2 = None
        room_connection_status = "does not exists"

        if room_name in rooms and rooms[room_name][0].side != first_message["data"]["player"]["playerSide"]:
            player_info = first_message["data"]["player"]
            rooms[room_name].append(Player(name=player_info["playerName"], side=player_info["playerSide"]))
            room_connection_status = "successfully_connected"
            player_1_info = rooms[room_name][0]
            player_1 = {"name": player_1_info.name, "side": player_1_info.side}
            player_2 = {"name": player_info["playerName"], "side": player_info["playerSide"]}

        game_type = first_message["data"]["gameType"]
        responce_message_connect = {
            "jsonType": "roomConnectionResponce",
            "data": {
                "gameType": game_type,
                "room": {
                    "roomName": room_name,
                    "roomConnectionStatus": room_connection_status,
                },
                "players": {
                    "roomCreator": player_1,
                    "connectedPlayer": player_2,
                }
            },
        }
        await websocket.send_json(json.dumps(responce_message_connect))

    else:
        await websocket.send_json("{}")
