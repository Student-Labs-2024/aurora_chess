from fastapi.testclient import TestClient
from main import app

import json


client = TestClient(app)


def test_create_room_with_friend_positive():
    game_type = "gameWithFriend"
    room_name = "test_create_room_with_friend_positive"
    player_name = "player_1"
    side = "Black"

    request_message = {
        "jsonType": "roomInitRequest",
        "data": {
                    "gameType": game_type,
                    "room": {
                        "roomName": room_name
                    },
                    "player": {
                        "playerName": player_name,
                        "playerSide": side
                    }
        },
    }

    json_request_message = json.dumps(request_message)

    room_init_status = "successfully created"
    responce_message = {
        "jsonType": "roomInitResponce",
        "data": {
            "gameType": game_type,
            "roomName": room_name,
            "roomInitStatus": room_init_status,
        },
    }

    with client.websocket_connect(f"api/chess/ws") as websocket:
        websocket.send_json(json_request_message)
        json_responce_message: json = websocket.receive_json()

        websocket.close()

    actual_responce_message = json.loads(json_responce_message)
    assert actual_responce_message["jsonType"] == responce_message["jsonType"]
    assert actual_responce_message["data"] == responce_message["data"]


def test_create_room_with_friend_negative():
    game_type = "gameWithFriend"
    room_name = "test_create_room_with_friend_positive"
    player_name = "player_1"
    side = "Black"

    request_message = {
        "jsonType": "roomInitRequest",
        "data": {
                    "gameType": game_type,
                    "room": {
                        "roomName": room_name
                    },
                    "player": {
                        "playerName": player_name,
                        "playerSide": side
                    }
        },
    }

    json_request_message = json.dumps(request_message)

    room_init_status = "already exists"
    responce_message = {
        "jsonType": "roomInitResponce",
        "data": {
            "gameType": game_type,
            "roomName": room_name,
            "roomInitStatus": room_init_status,
        },
    }

    with client.websocket_connect(f"api/chess/ws") as websocket:
        websocket.send_json(json_request_message)

        with client.websocket_connect(f"api/chess/ws") as websocket_1:
            websocket_1.send_json(json_request_message)
            json_responce_message: json = websocket_1.receive_json()

        websocket_1.close()
        websocket.close()

    actual_responce_message = json.loads(json_responce_message)
    assert actual_responce_message["jsonType"] == responce_message["jsonType"]
    assert actual_responce_message["data"] == responce_message["data"]
