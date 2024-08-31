import pytest
from fastapi.testclient import TestClient

from core.schemas.player import Player
from core.schemas.player_move import PlayerMove
from core.schemas.player_move_request import PlayerMoveRequestData, PlayerMoveRequest
from core.schemas.player_move_response import PlayerMoveResponse, PlayerMoveResponseData
from core.schemas.room_start_response import RoomStartResponseData, RoomStartResponse
from main import app

import json

client = TestClient(app)


@pytest.mark.asyncio
async def test_player_can_make_move_scholars_mate():
    game_type = "gameWithFriend"
    room_name = "test_make_move_positive"
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
    # 1
    player_move_white_1 = PlayerMove(
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
        piece="P",
        source={"column": 4, "row": 6},
        destination={"column": 4, "row": 4},
    )

    make_move_request_data_1 = PlayerMoveRequestData(
        gameType=game_type,
        roomName=room_name,
        player=Player(playerName=player_name_2, playerSide=side_2),
        playerMove=player_move_white_1,
    )
    make_move_request_1 = PlayerMoveRequest(
        jsonType="playerMoveRequest", data=make_move_request_data_1
    )
    make_move_request_1 = json.dumps(make_move_request_1.model_dump(by_alias=True))

    player_move_response_white_1 = PlayerMove(
        board=[
            ["r", "n", "b", "q", "k", "b", "n", "r"],
            ["p", "p", "p", "p", "p", "p", "p", "p"],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "P", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["P", "P", "P", "P", "", "P", "P", "P"],
            ["R", "N", "B", "Q", "K", "B", "N", "R"],
        ],
        piece="P",
        source={"column": 4, "row": 6},
        destination={"column": 4, "row": 4},
    )
    make_move_response_data_1 = PlayerMoveResponseData(
        confirmationStatus="confirmed",
        player=Player(playerName=player_name_2, playerSide=side_2),
        playerMove=player_move_response_white_1,
        gameType=game_type,
        roomName=room_name,
        gameStatus="*",
    )
    make_move_response_white_1 = PlayerMoveResponse(
        jsonType="moveConfirmationResponce", data=make_move_response_data_1
    )
    make_move_response_black_1 = PlayerMoveResponse(
        jsonType="enemysMove", data=make_move_response_data_1
    )

    # 2
    player_move_black_2 = PlayerMove(
        board=[
            ["r", "n", "b", "q", "k", "b", "n", "r"],
            ["p", "p", "p", "p", "p", "p", "p", "p"],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "P", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["P", "P", "P", "P", "", "P", "P", "P"],
            ["R", "N", "B", "Q", "K", "B", "N", "R"],
        ],
        piece="p",
        source={"column": 4, "row": 1},
        destination={"column": 4, "row": 3},
    )

    make_move_request_data_2 = PlayerMoveRequestData(
        gameType=game_type,
        roomName=room_name,
        player=Player(playerName=player_name, playerSide=side),
        playerMove=player_move_black_2,
    )
    make_move_request_2 = PlayerMoveRequest(
        jsonType="playerMoveRequest", data=make_move_request_data_2
    )
    make_move_request_2 = json.dumps(make_move_request_2.model_dump(by_alias=True))

    player_move_response_black_2 = PlayerMove(
        board=[
            ["r", "n", "b", "q", "k", "b", "n", "r"],
            ["p", "p", "p", "p", "", "p", "p", "p"],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "p", "", "", ""],
            ["", "", "", "", "P", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["P", "P", "P", "P", "", "P", "P", "P"],
            ["R", "N", "B", "Q", "K", "B", "N", "R"],
        ],
        piece="p",
        source={"column": 4, "row": 1},
        destination={"column": 4, "row": 3},
    )
    make_move_response_data_2 = PlayerMoveResponseData(
        confirmationStatus="confirmed",
        player=Player(playerName=player_name, playerSide=side),
        playerMove=player_move_response_black_2,
        gameType=game_type,
        roomName=room_name,
        gameStatus="*",
    )
    make_move_response_black_2 = PlayerMoveResponse(
        jsonType="moveConfirmationResponce", data=make_move_response_data_2
    )
    make_move_response_white_2 = PlayerMoveResponse(
        jsonType="enemysMove", data=make_move_response_data_2
    )

    # 3
    player_move_white_3 = PlayerMove(
        board=[
            ["r", "n", "b", "q", "k", "b", "n", "r"],
            ["p", "p", "p", "p", "", "p", "p", "p"],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "p", "", "", ""],
            ["", "", "", "", "P", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["P", "P", "P", "P", "", "P", "P", "P"],
            ["R", "N", "B", "Q", "K", "B", "N", "R"],
        ],
        piece="Q",
        source={"column": 3, "row": 7},
        destination={"column": 7, "row": 3},
    )

    make_move_request_data_3 = PlayerMoveRequestData(
        gameType=game_type,
        roomName=room_name,
        player=Player(playerName=player_name_2, playerSide=side_2),
        playerMove=player_move_white_3,
    )
    make_move_request_3 = PlayerMoveRequest(
        jsonType="playerMoveRequest", data=make_move_request_data_3
    )
    make_move_request_3 = json.dumps(make_move_request_3.model_dump(by_alias=True))

    player_move_response_white_3 = PlayerMove(
        board=[
            ["r", "n", "b", "q", "k", "b", "n", "r"],
            ["p", "p", "p", "p", "", "p", "p", "p"],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "p", "", "", "Q"],
            ["", "", "", "", "P", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["P", "P", "P", "P", "", "P", "P", "P"],
            ["R", "N", "B", "", "K", "B", "N", "R"],
        ],
        piece="Q",
        source={"column": 3, "row": 7},
        destination={"column": 7, "row": 3},
    )
    make_move_response_data_3 = PlayerMoveResponseData(
        confirmationStatus="confirmed",
        player=Player(playerName=player_name_2, playerSide=side_2),
        playerMove=player_move_response_white_3,
        gameType=game_type,
        roomName=room_name,
        gameStatus="*",
    )
    make_move_response_white_3 = PlayerMoveResponse(
        jsonType="moveConfirmationResponce", data=make_move_response_data_3
    )
    make_move_response_black_3 = PlayerMoveResponse(
        jsonType="enemysMove", data=make_move_response_data_3
    )

    # 4
    player_move_black_4 = PlayerMove(
        board=[
            ["r", "n", "b", "q", "k", "b", "n", "r"],
            ["p", "p", "p", "p", "", "p", "p", "p"],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "p", "", "", "Q"],
            ["", "", "", "", "P", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["P", "P", "P", "P", "", "P", "P", "P"],
            ["R", "N", "B", "", "K", "B", "N", "R"],
        ],
        piece="n",
        source={"column": 1, "row": 0},
        destination={"column": 2, "row": 2},
    )

    make_move_request_data_4 = PlayerMoveRequestData(
        gameType=game_type,
        roomName=room_name,
        player=Player(playerName=player_name, playerSide=side),
        playerMove=player_move_black_4,
    )
    make_move_request_4 = PlayerMoveRequest(
        jsonType="playerMoveRequest", data=make_move_request_data_4
    )
    make_move_request_4 = json.dumps(make_move_request_4.model_dump(by_alias=True))

    player_move_response_black_4 = PlayerMove(
        board=[
            ["r", "", "b", "q", "k", "b", "n", "r"],
            ["p", "p", "p", "p", "", "p", "p", "p"],
            ["", "", "n", "", "", "", "", ""],
            ["", "", "", "", "p", "", "", "Q"],
            ["", "", "", "", "P", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["P", "P", "P", "P", "", "P", "P", "P"],
            ["R", "N", "B", "", "K", "B", "N", "R"],
        ],
        piece="n",
        source={"column": 1, "row": 0},
        destination={"column": 2, "row": 2},
    )
    make_move_response_data_4 = PlayerMoveResponseData(
        confirmationStatus="confirmed",
        player=Player(playerName=player_name, playerSide=side),
        playerMove=player_move_response_black_4,
        gameType=game_type,
        roomName=room_name,
        gameStatus="*",
    )
    make_move_response_black_4 = PlayerMoveResponse(
        jsonType="moveConfirmationResponce", data=make_move_response_data_4
    )
    make_move_response_white_4 = PlayerMoveResponse(
        jsonType="enemysMove", data=make_move_response_data_4
    )

    # 5
    player_move_white_5 = PlayerMove(
        board=[
            ["r", "", "b", "q", "k", "b", "n", "r"],
            ["p", "p", "p", "p", "", "p", "p", "p"],
            ["", "", "n", "", "", "", "", ""],
            ["", "", "", "", "p", "", "", "Q"],
            ["", "", "", "", "P", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["P", "P", "P", "P", "", "P", "P", "P"],
            ["R", "N", "B", "", "K", "B", "N", "R"],
        ],
        piece="B",
        source={"column": 5, "row": 7},
        destination={"column": 2, "row": 4},
    )

    make_move_request_data_5 = PlayerMoveRequestData(
        gameType=game_type,
        roomName=room_name,
        player=Player(playerName=player_name_2, playerSide=side_2),
        playerMove=player_move_white_5,
    )
    make_move_request_5 = PlayerMoveRequest(
        jsonType="playerMoveRequest", data=make_move_request_data_5
    )
    make_move_request_5 = json.dumps(make_move_request_5.model_dump(by_alias=True))

    player_move_response_white_5 = PlayerMove(
        board=[
            ["r", "", "b", "q", "k", "b", "n", "r"],
            ["p", "p", "p", "p", "", "p", "p", "p"],
            ["", "", "n", "", "", "", "", ""],
            ["", "", "", "", "p", "", "", "Q"],
            ["", "", "B", "", "P", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["P", "P", "P", "P", "", "P", "P", "P"],
            ["R", "N", "B", "", "K", "", "N", "R"],
        ],
        piece="B",
        source={"column": 5, "row": 7},
        destination={"column": 2, "row": 4},
    )
    make_move_response_data_5 = PlayerMoveResponseData(
        confirmationStatus="confirmed",
        player=Player(playerName=player_name_2, playerSide=side_2),
        playerMove=player_move_response_white_5,
        gameType=game_type,
        roomName=room_name,
        gameStatus="*",
    )
    make_move_response_white_5 = PlayerMoveResponse(
        jsonType="moveConfirmationResponce", data=make_move_response_data_5
    )
    make_move_response_black_5 = PlayerMoveResponse(
        jsonType="enemysMove", data=make_move_response_data_5
    )

    # 6
    player_move_black_6 = PlayerMove(
        board=[
            ["r", "", "b", "q", "k", "b", "n", "r"],
            ["p", "p", "p", "p", "", "p", "p", "p"],
            ["", "", "n", "", "", "", "", ""],
            ["", "", "", "", "p", "", "", "Q"],
            ["", "", "B", "", "P", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["P", "P", "P", "P", "", "P", "P", "P"],
            ["R", "N", "B", "", "K", "", "N", "R"],
        ],
        piece="n",
        source={"column": 6, "row": 0},
        destination={"column": 5, "row": 2},
    )

    make_move_request_data_6 = PlayerMoveRequestData(
        gameType=game_type,
        roomName=room_name,
        player=Player(playerName=player_name, playerSide=side),
        playerMove=player_move_black_6,
    )
    make_move_request_6 = PlayerMoveRequest(
        jsonType="playerMoveRequest", data=make_move_request_data_6
    )
    make_move_request_6 = json.dumps(make_move_request_6.model_dump(by_alias=True))

    player_move_response_black_6 = PlayerMove(
        board=[
            ["r", "", "b", "q", "k", "b", "", "r"],
            ["p", "p", "p", "p", "", "p", "p", "p"],
            ["", "", "n", "", "", "n", "", ""],
            ["", "", "", "", "p", "", "", "Q"],
            ["", "", "B", "", "P", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["P", "P", "P", "P", "", "P", "P", "P"],
            ["R", "N", "B", "", "K", "", "N", "R"],
        ],
        piece="n",
        source={"column": 6, "row": 0},
        destination={"column": 5, "row": 2},
    )
    make_move_response_data_6 = PlayerMoveResponseData(
        confirmationStatus="confirmed",
        player=Player(playerName=player_name, playerSide=side),
        playerMove=player_move_response_black_6,
        gameType=game_type,
        roomName=room_name,
        gameStatus="*",
    )
    make_move_response_black_6 = PlayerMoveResponse(
        jsonType="moveConfirmationResponce", data=make_move_response_data_6
    )
    make_move_response_white_6 = PlayerMoveResponse(
        jsonType="enemysMove", data=make_move_response_data_6
    )

    # 7
    player_move_white_7 = PlayerMove(
        board=[
            ["r", "", "b", "q", "k", "b", "", "r"],
            ["p", "p", "p", "p", "", "p", "p", "p"],
            ["", "", "n", "", "", "n", "", ""],
            ["", "", "", "", "p", "", "", "Q"],
            ["", "", "B", "", "P", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["P", "P", "P", "P", "", "P", "P", "P"],
            ["R", "N", "B", "", "K", "", "N", "R"],
        ],
        piece="Q",
        source={"column": 7, "row": 3},
        destination={"column": 5, "row": 1},
    )

    make_move_request_data_7 = PlayerMoveRequestData(
        gameType=game_type,
        roomName=room_name,
        player=Player(playerName=player_name_2, playerSide=side_2),
        playerMove=player_move_white_7,
    )
    make_move_request_7 = PlayerMoveRequest(
        jsonType="playerMoveRequest", data=make_move_request_data_7
    )
    make_move_request_7 = json.dumps(make_move_request_7.model_dump(by_alias=True))

    player_move_response_white_7 = PlayerMove(
        board=[
            ["r", "", "b", "q", "k", "b", "", "r"],
            ["p", "p", "p", "p", "", "Q", "p", "p"],
            ["", "", "n", "", "", "n", "", ""],
            ["", "", "", "", "p", "", "", ""],
            ["", "", "B", "", "P", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["P", "P", "P", "P", "", "P", "P", "P"],
            ["R", "N", "B", "", "K", "", "N", "R"],
        ],
        piece="Q",
        source={"column": 7, "row": 3},
        destination={"column": 5, "row": 1},
    )
    make_move_response_data_7 = PlayerMoveResponseData(
        confirmationStatus="confirmed",
        player=Player(playerName=player_name_2, playerSide=side_2),
        playerMove=player_move_response_white_7,
        gameType=game_type,
        roomName=room_name,
        gameStatus="1-0",
    )
    make_move_response_white_7 = PlayerMoveResponse(
        jsonType="moveConfirmationResponce", data=make_move_response_data_7
    )
    make_move_response_black_7 = PlayerMoveResponse(
        jsonType="enemysMove", data=make_move_response_data_7
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

            websocket_1.send_json(make_move_request_1)
            actual_make_move_response_white_1 = websocket_1.receive_json()
            actual_make_move_response_black_1 = websocket.receive_json()

            websocket.send_json(make_move_request_2)
            actual_make_move_response_white_2 = websocket_1.receive_json()
            actual_make_move_response_black_2 = websocket.receive_json()

            websocket_1.send_json(make_move_request_3)
            actual_make_move_response_white_3 = websocket_1.receive_json()
            actual_make_move_response_black_3 = websocket.receive_json()

            websocket.send_json(make_move_request_4)
            actual_make_move_response_white_4 = websocket_1.receive_json()
            actual_make_move_response_black_4 = websocket.receive_json()

            websocket_1.send_json(make_move_request_5)
            actual_make_move_response_white_5 = websocket_1.receive_json()
            actual_make_move_response_black_5 = websocket.receive_json()

            websocket.send_json(make_move_request_6)
            actual_make_move_response_white_6 = websocket_1.receive_json()
            actual_make_move_response_black_6 = websocket.receive_json()

            websocket_1.send_json(make_move_request_7)
            actual_make_move_response_white_7 = websocket_1.receive_json()
            actual_make_move_response_black_7 = websocket.receive_json()

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

    assert make_move_response_white_1 == PlayerMoveResponse.model_validate(
        json.loads(actual_make_move_response_white_1)
    )
    assert make_move_response_black_1 == PlayerMoveResponse.model_validate(
        json.loads(actual_make_move_response_black_1)
    )

    assert make_move_response_white_2 == PlayerMoveResponse.model_validate(
        json.loads(actual_make_move_response_white_2)
    )
    assert make_move_response_black_2 == PlayerMoveResponse.model_validate(
        json.loads(actual_make_move_response_black_2)
    )

    assert make_move_response_white_3 == PlayerMoveResponse.model_validate(
        json.loads(actual_make_move_response_white_3)
    )
    assert make_move_response_black_3 == PlayerMoveResponse.model_validate(
        json.loads(actual_make_move_response_black_3)
    )

    assert make_move_response_white_4 == PlayerMoveResponse.model_validate(
        json.loads(actual_make_move_response_white_4)
    )
    assert make_move_response_black_4 == PlayerMoveResponse.model_validate(
        json.loads(actual_make_move_response_black_4)
    )

    assert make_move_response_white_5 == PlayerMoveResponse.model_validate(
        json.loads(actual_make_move_response_white_5)
    )
    assert make_move_response_black_5 == PlayerMoveResponse.model_validate(
        json.loads(actual_make_move_response_black_5)
    )

    assert make_move_response_white_6 == PlayerMoveResponse.model_validate(
        json.loads(actual_make_move_response_white_6)
    )
    assert make_move_response_black_6 == PlayerMoveResponse.model_validate(
        json.loads(actual_make_move_response_black_6)
    )

    assert make_move_response_white_7 == PlayerMoveResponse.model_validate(
        json.loads(actual_make_move_response_white_7)
    )
    assert make_move_response_black_7 == PlayerMoveResponse.model_validate(
        json.loads(actual_make_move_response_black_7)
    )


@pytest.mark.asyncio
async def test_player_cant_make_move_invaild_board():
    game_type = "gameWithFriend"
    room_name = "test_cant_make_move"
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
    # 1
    player_move_white_1 = PlayerMove(
        board=[
            ["", "n", "b", "q", "k", "b", "n", "r"],
            ["p", "p", "p", "p", "p", "p", "p", "p"],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["P", "P", "P", "P", "P", "P", "P", "P"],
            ["R", "N", "B", "Q", "K", "B", "N", "R"],
        ],
        piece="P",
        source={"column": 4, "row": 6},
        destination={"column": 4, "row": 4},
    )

    make_move_request_data_1 = PlayerMoveRequestData(
        gameType=game_type,
        roomName=room_name,
        player=Player(playerName=player_name_2, playerSide=side_2),
        playerMove=player_move_white_1,
    )
    make_move_request_1 = PlayerMoveRequest(
        jsonType="playerMoveRequest", data=make_move_request_data_1
    )
    make_move_request_1 = json.dumps(make_move_request_1.model_dump(by_alias=True))

    player_move_response_white_1 = PlayerMove(
        board=[
            ["", "n", "b", "q", "k", "b", "n", "r"],
            ["p", "p", "p", "p", "p", "p", "p", "p"],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["", "", "", "", "", "", "", ""],
            ["P", "P", "P", "P", "P", "P", "P", "P"],
            ["R", "N", "B", "Q", "K", "B", "N", "R"],
        ],
        piece="P",
        source={"column": 4, "row": 6},
        destination={"column": 4, "row": 4},
    )
    make_move_response_data_1 = PlayerMoveResponseData(
        confirmationStatus="not valid",
        player=Player(playerName=player_name_2, playerSide=side_2),
        playerMove=player_move_response_white_1,
        gameType=game_type,
        roomName=room_name,
        gameStatus=None,
    )
    make_move_response_white_1 = PlayerMoveResponse(
        jsonType="moveConfirmationResponce", data=make_move_response_data_1
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

            websocket_1.send_json(make_move_request_1)
            actual_make_move_response_white_1 = websocket_1.receive_json()

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

    assert make_move_response_white_1 == PlayerMoveResponse.model_validate(
        json.loads(actual_make_move_response_white_1)
    )
