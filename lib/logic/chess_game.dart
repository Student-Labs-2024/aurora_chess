import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:frontend/logic/chess_piece_sprite.dart';
import 'package:frontend/logic/move_calculation/ai_move_calculation.dart';
import 'package:frontend/logic/move_calculation/move_calculation.dart';
import 'package:frontend/logic/move_calculation/move_classes/move_meta.dart';
import 'package:frontend/logic/shared_functions.dart';
import 'package:frontend/model/game_model.dart';
import 'package:frontend/views/components/main_menu_view/game_options/side_picker.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'package:flutter/foundation.dart';

import 'chess_board.dart';
import 'chess_piece.dart';
import 'move_calculation/move_classes/move.dart';

class ChessGame extends Game with TapDetector {
  double? width;
  double? tileSize;
  GameModel gameModel;
  BuildContext context;
  ChessBoard board = ChessBoard();
  Map<ChessPiece, ChessPieceSprite> spriteMap = Map();

  CancelableOperation? aiOperation;
  List<int> validMoves = [];
  ChessPiece? selectedPiece;
  int? checkHintTile;
  Move? latestMove;

  ChessGame(this.gameModel, this.context) {
    width = MediaQuery.of(context).size.width - 68;
    tileSize = (width ?? 0) / 8;
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece] = ChessPieceSprite(piece, gameModel.pieceTheme);
    }
    _initSpritePositions();
    if (gameModel.isAIsTurn) {
      _aiMove();
    }
  }

  @override
  void onTapDown(TapDownInfo details) {
    if (gameModel.gameOver || !(gameModel.isAIsTurn)) {
      var tile = _vector2ToTile(details.eventPosition.widget);
      var touchedPiece = board.tiles[tile];
      if (touchedPiece == selectedPiece) {
        validMoves = [];
        selectedPiece = null;
      } else {
        if (selectedPiece != null &&
            touchedPiece != null &&
            touchedPiece.player == selectedPiece?.player) {
          if (validMoves.contains(tile)) {
            _movePiece(tile);
          } else {
            validMoves = [];
            _selectPiece(touchedPiece);
          }
        } else if (selectedPiece == null) {
          _selectPiece(touchedPiece);
        } else {
          _movePiece(tile);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    _drawBoard(canvas);
    if (gameModel.showHints) {
      _drawCheckHint(canvas);
      _drawLatestMove(canvas);
    }
    _drawSelectedPieceHint(canvas);
    _drawPieces(canvas);
    if (gameModel.showHints) {
      _drawMoveHints(canvas);
    }
  }

  @override
  void update(double t) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece]?.update(tileSize ?? 0, gameModel, piece);
    }
  }

  void _initSpritePositions() {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece]?.initSpritePosition(tileSize ?? 0, gameModel);
    }
  }

  void _selectPiece(ChessPiece? piece) {
    if (piece != null) {
      if (piece.player == gameModel.turn) {
        selectedPiece = piece;
        if (selectedPiece != null) {
          validMoves = movesForPiece(piece, board);
        }
        if (validMoves.isEmpty) {
          selectedPiece = null;
        }
      }
    }
  }

  void _movePiece(int tile) {
    if (validMoves.contains(tile)) {
      validMoves = [];
      var meta =
          push(Move(selectedPiece?.tile ?? 0, tile), board, getMeta: true);
      if (meta.promotion) {
        gameModel.requestPromotion();
      }
      _moveCompletion(meta, changeTurn: !meta.promotion);
    }
  }

  void _aiMove() async {
    await Future.delayed(Duration(milliseconds: 500));
    var args = Map();
    args['aiPlayer'] = gameModel.aiTurn;
    args['aiDifficulty'] = gameModel.aiDifficulty;
    args['board'] = board;
    aiOperation = CancelableOperation.fromFuture(
      compute(calculateAIMove, args),
    );
    aiOperation?.value.then((move) {
      if (move == null || gameModel.gameOver) {
        gameModel.endGame();
      } else {
        validMoves = [];
        var meta = push(move, board, getMeta: true);
        _moveCompletion(meta, changeTurn: !meta.promotion);
        if (meta.promotion) {
          promote(move.promotionType);
        }
      }
    });
  }

  void cancelAIMove() {
    aiOperation?.cancel();
  }

  void undoMove() {
    board.redoStack.add(pop(board));
    if (gameModel.moveMetaList.length > 1) {
      var meta = gameModel.moveMetaList[gameModel.moveMetaList.length - 2];
      _moveCompletion(meta, clearRedo: false, undoing: true);
    } else {
      _undoOpeningMove();
      gameModel.changeTurn();
    }
  }

  void undoTwoMoves() {
    board.redoStack.add(pop(board));
    board.redoStack.add(pop(board));
    gameModel.popMoveMeta();
    if (gameModel.moveMetaList.length > 1) {
      _moveCompletion(gameModel.moveMetaList[gameModel.moveMetaList.length - 2],
          clearRedo: false, undoing: true, changeTurn: false);
    } else {
      _undoOpeningMove();
    }
  }

  void _undoOpeningMove() {
    selectedPiece = null;
    validMoves = [];
    latestMove = null;
    checkHintTile = null;
    gameModel.popMoveMeta();
  }

  void redoMove() {
    _moveCompletion(pushMSO(board.redoStack.removeLast(), board),
        clearRedo: false);
  }

  void redoTwoMoves() {
    _moveCompletion(pushMSO(board.redoStack.removeLast(), board),
        clearRedo: false, updateMetaList: true);
    _moveCompletion(pushMSO(board.redoStack.removeLast(), board),
        clearRedo: false, updateMetaList: true);
  }

  void promote(ChessPieceType type) {
    board.moveStack.last.movedPiece?.type = type;
    board.moveStack.last.promotionType = type;
    addPromotedPiece(board, board.moveStack.last);
    gameModel.moveMetaList.last.promotionType = type;
    _moveCompletion(gameModel.moveMetaList.last, updateMetaList: false);
  }

  void _moveCompletion(
    MoveMeta meta, {
    bool clearRedo = true,
    bool undoing = false,
    bool changeTurn = true,
    bool updateMetaList = true,
  }) {
    if (clearRedo) {
      board.redoStack = [];
    }
    validMoves = [];
    latestMove = meta.move;
    checkHintTile = null;
    var oppositeTurn = oppositePlayer(gameModel.turn);
    if (kingInCheck(oppositeTurn, board)) {
      meta.isCheck = true;
      checkHintTile = kingForPlayer(oppositeTurn, board)?.tile;
    }
    if (kingInCheckmate(oppositeTurn, board)) {
      if (!meta.isCheck) {
        gameModel.stalemate = true;
        meta.isStalemate = true;
      }
      meta.isCheck = false;
      meta.isCheckmate = true;
      gameModel.endGame();
    }
    if (undoing) {
      gameModel.popMoveMeta();
      gameModel.undoEndGame();
    } else if (updateMetaList) {
      gameModel.pushMoveMeta(meta);
    }
    if (changeTurn) {
      gameModel.changeTurn();
    }
    selectedPiece = null;
    if (gameModel.isAIsTurn && clearRedo && changeTurn) {
      _aiMove();
    }
  }

  int _vector2ToTile(Vector2 vector2) {
    if (gameModel.flip &&
        gameModel.playingWithAI &&
        gameModel.playerSide == Player.player2) {
      return (7 - (vector2.y / (tileSize ?? 0)).floor()) * 8 +
          (7 - (vector2.x / (tileSize ?? 0)).floor());
    } else {
      return (vector2.y / (tileSize ?? 0)).floor() * 8 +
          (vector2.x / (tileSize ?? 0)).floor();
    }
  }

  void _drawBoard(Canvas canvas) {
    for (int tileNo = 0; tileNo < 64; tileNo++) {
      canvas.drawRect(
        Rect.fromLTWH(
          (tileNo % 8) * (tileSize ?? 0),
          (tileNo / 8).floor() * (tileSize ?? 0),
          (tileSize ?? 0),
          (tileSize ?? 0),
        ),
        Paint()
          ..color = (tileNo + (tileNo / 8).floor()) % 2 == 0
              ? gameModel.theme.lightTile
              : gameModel.theme.darkTile,
      );
    }
  }

  void _drawPieces(Canvas canvas) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece]?.sprite?.render(
            canvas,
            size: Vector2((tileSize ?? 0) - 10, (tileSize ?? 0) - 10),
            position: Vector2(
              (spriteMap[piece]?.spriteX ?? 0) + 5,
              (spriteMap[piece]?.spriteY ?? 0) + 5,
            ),
          );
    }
  }

  void _drawMoveHints(Canvas canvas) {
    for (var tile in validMoves) {
      canvas.drawCircle(
        Offset(
          getXFromTile(tile, (tileSize ?? 0), gameModel) +
              ((tileSize ?? 0) / 2),
          getYFromTile(tile, (tileSize ?? 0), gameModel) +
              ((tileSize ?? 0) / 2),
        ),
        (tileSize ?? 0) / 5,
        Paint()..color = gameModel.theme.moveHint,
      );
    }
  }

  void _drawLatestMove(Canvas canvas) {
    if (latestMove != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(latestMove!.from, tileSize ?? 0, gameModel),
          getYFromTile(latestMove!.from, tileSize ?? 0, gameModel),
          tileSize ?? 0,
          tileSize ?? 0,
        ),
        Paint()..color = gameModel.theme.latestMove,
      );
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(latestMove!.to, tileSize ?? 0, gameModel),
          getYFromTile(latestMove!.to, tileSize ?? 0, gameModel),
          tileSize ?? 0,
          tileSize ?? 0,
        ),
        Paint()..color = gameModel.theme.latestMove,
      );
    }
  }

  void _drawCheckHint(Canvas canvas) {
    if (checkHintTile != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(checkHintTile!, tileSize ?? 0, gameModel),
          getYFromTile(checkHintTile!, tileSize ?? 0, gameModel),
          tileSize ?? 0,
          tileSize ?? 0,
        ),
        Paint()..color = gameModel.theme.checkHint,
      );
    }
  }

  void _drawSelectedPieceHint(Canvas canvas) {
    if (selectedPiece != null) {
      canvas.drawRect(
        Rect.fromLTWH(
          getXFromTile(selectedPiece!.tile, tileSize ?? 0, gameModel),
          getYFromTile(selectedPiece!.tile, tileSize ?? 0, gameModel),
          tileSize ?? 0,
          tileSize ?? 0,
        ),
        Paint()..color = gameModel.theme.moveHint,
      );
    }
  }
}
