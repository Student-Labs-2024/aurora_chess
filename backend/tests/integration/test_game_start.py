from pprint import pprint

import pytest
from fastapi.testclient import TestClient
from starlette.websockets import WebSocketDisconnect

from core.schemas.player import Player
from core.schemas.room_start_response import RoomStartResponseData, RoomStartResponse
from main import app

import json

client = TestClient(app)


@pytest.mark.asyncio
async def test_player_can_start_room():
    game_type = "gameWithFriend"
    room_name = "test_start_room_positive"
    player_name_2 = "player_2"
    side_2 = "white"

    request_message_connect = {
        "jsonType": "roomConnectionRequest",
        "data": {
            "gameType": game_type,
            "room": {"roomName": room_name},
            "player": {"playerName": player_name_2, "playerSide": side_2},
        },
    }

    player_name = "player_1"
    side = "black"

    request_message_create = {
        "jsonType": "roomInitRequest",
        "data": {
            "gameType": game_type,
            "room": {"roomName": room_name},
            "player": {"playerName": player_name, "playerSide": side},
        },
    }

    json_request_message_create = json.dumps(request_message_create)
    json_request_message_connect = json.dumps(request_message_connect)

    room_connection_status = "successfully_connected"
    responce_message_connect = {
        "jsonType": "roomConnectionResponse",
        "data": {
            "gameType": game_type,
            "room": {
                "roomName": room_name,
            },
            "roomConnectionStatus": room_connection_status,
            "players": {
                "roomCreator": {
                    "playerName": player_name,
                    "playerSide": side,
                },
                "connectedPlayer": {
                    "playerName": player_name_2,
                    "playerSide": side_2,
                },
            },
        },
    }

    start_room_request = json.dumps(
        {
            "jsonType": "roomStartRequest",
            "data": {
                "gameType": game_type,
                "roomName": room_name,
                "player": {"playerName": player_name, "playerSide": side},
            },
        }
    )

    response_data = RoomStartResponseData(
        confirmationStatus="confirmed",
        gameType=game_type,
        roomName=room_name,
        board=[
            ["r", "n", "b", "q", "k", "b", "n", "r"],
            ["p", "p", "p", "p", "p", "p", "p", "p"],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["P", "P", "P", "P", "P", "P", "P", "P"],
            ["R", "N", "B", "Q", "K", "B", "N", "R"],
        ],
        players=[
            Player(playerName=player_name_2, playerSide=side_2),
            Player(playerName=player_name, playerSide=side),
        ],
    )
    responce_message_start = RoomStartResponse(
        jsonType="roomStartResponse", data=response_data
    )

    with client.websocket_connect(f"api/chess/ws") as websocket:
        websocket.send_json(json_request_message_create)
        websocket.receive_json()

        with client.websocket_connect(f"api/chess/ws") as websocket_1:
            websocket_1.send_json(json_request_message_connect)
            json_connection_responce_message = websocket_1.receive_json()
            json_connection_responce_message_creator = websocket.receive_json()

            websocket.send_json(start_room_request)
            actual_responce_message_start_creator = websocket.receive_json()
            actual_responce_message_start = websocket_1.receive_json()

        websocket_1.close()
        websocket.close()

    actual_responce_message = json.loads(json_connection_responce_message)
    assert actual_responce_message["jsonType"] == responce_message_connect["jsonType"]
    assert actual_responce_message["data"] == responce_message_connect["data"]
    actual_responce_message = json.loads(json_connection_responce_message_creator)
    assert actual_responce_message["jsonType"] == responce_message_connect["jsonType"]
    assert actual_responce_message["data"] == responce_message_connect["data"]

    assert responce_message_start == RoomStartResponse.model_validate(
        json.loads(actual_responce_message_start_creator)
    )
    assert responce_message_start == RoomStartResponse.model_validate(
        json.loads(actual_responce_message_start)
    )


@pytest.mark.asyncio
async def test_player_cant_start_room_invalid_room_name():
    game_type = "gameWithFriend"
    room_name = "test_start_room_negative"
    player_name_2 = "player_2"
    side_2 = "white"

    request_message_connect = {
        "jsonType": "roomConnectionRequest",
        "data": {
            "gameType": game_type,
            "room": {"roomName": room_name},
            "player": {"playerName": player_name_2, "playerSide": side_2},
        },
    }

    player_name = "player_1"
    side = "black"

    request_message_create = {
        "jsonType": "roomInitRequest",
        "data": {
            "gameType": game_type,
            "room": {"roomName": room_name},
            "player": {"playerName": player_name, "playerSide": side},
        },
    }

    json_request_message_create = json.dumps(request_message_create)
    json_request_message_connect = json.dumps(request_message_connect)

    room_connection_status = "successfully_connected"
    responce_message_connect = {
        "jsonType": "roomConnectionResponse",
        "data": {
            "gameType": game_type,
            "room": {
                "roomName": room_name,
            },
            "roomConnectionStatus": room_connection_status,
            "players": {
                "roomCreator": {
                    "playerName": player_name,
                    "playerSide": side,
                },
                "connectedPlayer": {
                    "playerName": player_name_2,
                    "playerSide": side_2,
                },
            },
        },
    }

    start_room_request = json.dumps(
        {
            "jsonType": "roomStartRequest",
            "data": {
                "gameType": game_type,
                "roomName": room_name + " ",
                "player": {"playerName": player_name, "playerSide": side},
            },
        }
    )

    response_data = RoomStartResponseData(
        confirmationStatus="not valid",
        gameType=game_type,
        roomName=room_name + " ",
    )
    responce_message_start = RoomStartResponse(
        jsonType="roomStartResponse", data=response_data
    )

    with client.websocket_connect(f"api/chess/ws") as websocket:
        websocket.send_json(json_request_message_create)
        websocket.receive_json()

        with client.websocket_connect(f"api/chess/ws") as websocket_1:
            websocket_1.send_json(json_request_message_connect)
            json_connection_responce_message = websocket_1.receive_json()
            json_connection_responce_message_creator = websocket.receive_json()

            websocket.send_json(start_room_request)
            actual_responce_message_start_creator = websocket.receive_json()

        websocket_1.close()
        websocket.close()

    actual_responce_message = json.loads(json_connection_responce_message)
    assert actual_responce_message["jsonType"] == responce_message_connect["jsonType"]
    assert actual_responce_message["data"] == responce_message_connect["data"]
    actual_responce_message = json.loads(json_connection_responce_message_creator)
    assert actual_responce_message["jsonType"] == responce_message_connect["jsonType"]
    assert actual_responce_message["data"] == responce_message_connect["data"]

    assert responce_message_start == RoomStartResponse.model_validate(
        json.loads(actual_responce_message_start_creator)
    )


@pytest.mark.asyncio
async def test_player_cant_start_room_invalid_game_type():
    game_type = "gameWithFriend"
    room_name = "test_start_room_negative_invalid_game_type"
    player_name_2 = "player_2"
    side_2 = "white"

    request_message_connect = {
        "jsonType": "roomConnectionRequest",
        "data": {
            "gameType": game_type,
            "room": {"roomName": room_name},
            "player": {"playerName": player_name_2, "playerSide": side_2},
        },
    }

    player_name = "player_1"
    side = "black"

    request_message_create = {
        "jsonType": "roomInitRequest",
        "data": {
            "gameType": game_type,
            "room": {"roomName": room_name},
            "player": {"playerName": player_name, "playerSide": side},
        },
    }

    json_request_message_create = json.dumps(request_message_create)
    json_request_message_connect = json.dumps(request_message_connect)

    room_connection_status = "successfully_connected"
    responce_message_connect = {
        "jsonType": "roomConnectionResponse",
        "data": {
            "gameType": game_type,
            "room": {
                "roomName": room_name,
            },
            "roomConnectionStatus": room_connection_status,
            "players": {
                "roomCreator": {
                    "playerName": player_name,
                    "playerSide": side,
                },
                "connectedPlayer": {
                    "playerName": player_name_2,
                    "playerSide": side_2,
                },
            },
        },
    }

    start_room_request = json.dumps(
        {
            "jsonType": "roomStartRequest",
            "data": {
                "gameType": game_type + " ",
                "roomName": room_name,
                "player": {"playerName": player_name, "playerSide": side},
            },
        }
    )

    response_data = RoomStartResponseData(
        confirmationStatus="not valid",
        gameType=game_type + " ",
        roomName=room_name,
    )
    responce_message_start = RoomStartResponse(
        jsonType="roomStartResponse", data=response_data
    )

    with client.websocket_connect(f"api/chess/ws") as websocket:
        websocket.send_json(json_request_message_create)
        websocket.receive_json()

        with client.websocket_connect(f"api/chess/ws") as websocket_1:
            websocket_1.send_json(json_request_message_connect)
            json_connection_responce_message = websocket_1.receive_json()
            json_connection_responce_message_creator = websocket.receive_json()

            websocket.send_json(start_room_request)
            actual_responce_message_start_creator = websocket.receive_json()

        websocket_1.close()
        websocket.close()

    actual_responce_message = json.loads(json_connection_responce_message)
    assert actual_responce_message["jsonType"] == responce_message_connect["jsonType"]
    assert actual_responce_message["data"] == responce_message_connect["data"]
    actual_responce_message = json.loads(json_connection_responce_message_creator)
    assert actual_responce_message["jsonType"] == responce_message_connect["jsonType"]
    assert actual_responce_message["data"] == responce_message_connect["data"]

    assert responce_message_start == RoomStartResponse.model_validate(
        json.loads(actual_responce_message_start_creator)
    )
