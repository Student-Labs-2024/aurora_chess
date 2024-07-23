from fastapi.testclient import TestClient
from main import app

import json

client = TestClient(app)


def test_connection_to_room_positive():
    game_type = "gameWithFriend"
    room_name = "test_connection_to_room_positive"
    player_name = "player_2"
    side = "White"

    request_message_connect = {
        "jsonType": "roomConnectionRequest",
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

    game_type = "gameWithFriend"
    room_name = "test_connection_to_room_positive"
    player_name = "player_1"
    side = "Black"

    request_message_create = {
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

    json_request_message_create = json.dumps(request_message_create)
    json_request_message_connect = json.dumps(request_message_connect)

    responce_message_connect = {
        "jsonType": "roomConnectionResponce",
        "data": {
            "gameType": game_type,
            "room": {
                    "roomName": room_name,
                    "roomConnectionStatus": "successfully connected",
            },
            "players": {
                "roomCreator": {"name": "player_1", "side": "Black", },
                "connectedPlayer": {"name": "player_2", "side": "White", },
            }
        },
    }

    with client.websocket_connect(f"api/chess/ws") as websocket:
        websocket.send_json(json_request_message_create)

        with client.websocket_connect(f"api/chess/ws") as websocket_1:
            websocket_1.send_json(json_request_message_connect)
            json_responce_message = websocket_1.receive_json()

    actual_responce_message = json.load(json_responce_message)
    assert actual_responce_message["jsonType"] == responce_message_connect["jsonType"]
    assert actual_responce_message["data"] == responce_message_connect["data"]


def test_connection_to_room_negative():
    game_type = "gameWithFriend"
    room_name = "test_connection_to_room_positive"
    player_name = "player_2"
    side = "White"

    request_message_connect = {
        "jsonType": "roomConnectionRequest",
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

    json_request_message_connect = json.dumps(request_message_connect)

    responce_message_connect = {
        "jsonType": "roomConnectionResponce",
        "data": {
            "gameType": game_type,
            "room": {
                "roomName": room_name,
                "roomConnectionStatus": "does not exists",
            },
            "players": {
            }
        },
    }

    with client.websocket_connect(f"api/chess/ws") as websocket:
        websocket.send_json(json_request_message_connect)
        json_responce_message = websocket.receive_json()

    actual_responce_message = json.load(json_responce_message)
    assert actual_responce_message["jsonType"] == responce_message_connect["jsonType"]
    assert actual_responce_message["data"] == responce_message_connect["data"]

