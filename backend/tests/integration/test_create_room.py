from fastapi.testclient import TestClient
from main import app

import json


client = TestClient(app)


def test_player_can_create_room():
    game_type = "gameWithFriend"
    room_name = "test_create_room_with_friend_positive"
    player_name = "player_1"
    side = "black"

    request_message = {
        "jsonType": "roomInitRequest",
        "data": {
            "gameType": game_type,
            "room": {"roomName": room_name},
            "player": {"playerName": player_name, "playerSide": side},
        },
    }

    json_request_message = json.dumps(request_message)

    room_init_status = "successfully created"
    response_message = {
        "jsonType": "roomInitResponse",
        "data": {
            "gameType": game_type,
            "roomName": room_name,
            "roomInitStatus": room_init_status,
        },
    }

    with client.websocket_connect(f"api/chess/ws") as websocket:
        websocket.send_json(json_request_message)
        json_response_message: json = websocket.receive_json()

        websocket.close()

    actual_response_message = json.loads(json_response_message)
    assert actual_response_message["jsonType"] == response_message["jsonType"]
    assert actual_response_message["data"] == response_message["data"]


def test_player_cant_create_alredy_exist_room():
    game_type = "gameWithFriend"
    room_name = "test_create_room_with_friend_positive"
    player_name = "player_1"
    side = "black"

    request_message = {
        "jsonType": "roomInitRequest",
        "data": {
            "gameType": game_type,
            "room": {"roomName": room_name},
            "player": {"playerName": player_name, "playerSide": side},
        },
    }

    json_request_message = json.dumps(request_message)

    room_init_status = "already exists"
    response_message = {
        "jsonType": "roomInitResponse",
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
            json_response_message: json = websocket_1.receive_json()

        websocket_1.close()
        websocket.close()

    actual_response_message = json.loads(json_response_message)
    assert actual_response_message["jsonType"] == response_message["jsonType"]
    assert actual_response_message["data"] == response_message["data"]
