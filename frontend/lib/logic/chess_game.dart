import "dart:async";
import "package:async/async.dart";
import "package:flutter/material.dart";
import "package:flame/events.dart";
import "package:flame/game.dart";
import "package:flutter/foundation.dart";
import "../exports.dart";

class ChessGame extends Game with TapDetector {
  double? width;
  double? tileSize;
  GameModel gameModel;
  BuildContext context;
  ChessBoard board = ChessBoard();
  Map<ChessPiece, ChessPieceSprite> spriteMap = {};
  Timer t = Timer(const Duration(seconds: 1), () {});

  CancelableOperation? aiOperation;
  List<int> validMoves = [];
  ChessPiece? selectedPiece;
  List<int> checkHintTiles = [];
  Move? latestMove;

  ChessGame(this.gameModel, this.context) {
    t.cancel();
    double screenWidth = MediaQuery.of(context).size.width;
    width = (screenWidth * (1 - LogicConsts.boardWidthMarginRatio * 2))
        .ceil()
        .toDouble();
    tileSize = (width ?? 0) / LogicConsts.lenOfRow;
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece] = ChessPieceSprite(piece);
    }
    _initSpritePositions();
    if (gameModel.isAIsTurn) {
      _aiMove();
    } else {
      t = Timer(Duration(seconds: gameModel.hintDelay), () {
        if (!gameModel.isMoveCompletion) {
          gameModel.setIsHintNeeded(true);
        }
      });
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    if ((gameModel.gameOver || !(gameModel.isAIsTurn)) &&
        !gameModel.isPromotionForPlayer) {
      var tile = _vector2ToTile(info.eventPosition.widget);
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
            _selectPiece(touchedPiece, null);
          }
        } else if (selectedPiece == null) {
          _selectPiece(touchedPiece, null);
        } else {
          _movePiece(tile);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    _drawBoard(canvas);
    if (gameModel.showMoves) {
      _drawCheckHint(canvas);
      _drawLatestMove(canvas);
    }
    _drawSelectedPieceHint(canvas);
    _drawPieces(canvas);
    if (gameModel.showMoves) {
      _drawMoveHints(canvas);
    }
  }

  @override
  void update(double dt) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece]?.update(tileSize ?? 0, gameModel, piece);
    }
  }

  void _initSpritePositions() {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece]?.initSpritePosition(tileSize ?? 0, gameModel);
    }
  }

  void _selectPiece(ChessPiece? piece, int? hintTile) {
    if (piece != null) {
      if (piece.player == gameModel.turn) {
        selectedPiece = piece;
        if (selectedPiece != null) {
          if (hintTile == null) {
            validMoves = movesForPiece(piece, board);
          } else {
            validMoves = [
              hintTile,
            ];
          }
        }
        if (validMoves.isEmpty) {
          selectedPiece = null;
        }
      }
    }
  }

  void _movePiece(int tile) async {
    if (validMoves.contains(tile)) {
      var meta =
          push(Move(selectedPiece?.tile ?? 0, tile), board, getMeta: true);
      if (selectedPiece?.type == ChessPieceType.promotion &&
          (tileToRow(tile) == 0 ||
              tileToRow(tile) == LogicConsts.lenOfRow - 1)) {
        gameModel.isPromotionForPlayer = true;
        _moveCompletion(meta, changeTurn: false);
        _promotionWaiter(gameModel)
            .then((value) => promote(gameModel.pieceForPromotion, meta));
      } else {
        _moveCompletion(meta, changeTurn: true);
      }
    }
    gameModel.setIsMoveCompletion(true);
  }

  Future<bool> _promotionWaiter(GameModel gameModel) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (gameModel.pieceForPromotion == ChessPieceType.promotion) {
      return _promotionWaiter(gameModel);
    } else {
      return true;
    }
  }

  void _aiMove() async {
    await Future.delayed(const Duration(milliseconds: 500));
    var args = {};
    args["aiPlayer"] = gameModel.aiTurn;
    args["aiDifficulty"] = gameModel.aiDifficulty;
    args["board"] = board;
    aiOperation = CancelableOperation.fromFuture(
      compute(calculateAIMove, args),
    );
    aiOperation?.value.then((move) {
      if (move == null || gameModel.gameOver) {
        t.cancel();
        gameModel.endGame();
      } else {
        validMoves = [];
        var meta = push(move, board, getMeta: true);
        _moveCompletion(meta, changeTurn: !meta.promotion);
        if (meta.promotion) {
          promote(move.promotionType, meta);
        }
      }
    });
    gameModel.setIsMoveCompletion(false);
    t.cancel();
    t = Timer(Duration(seconds: gameModel.hintDelay), () {
      if (!gameModel.isMoveCompletion) {
        gameModel.setIsHintNeeded(true);
      }
    });
  }

  void cancelAIMove() {
    aiOperation?.cancel();
  }

  void undoMove() {
    board.redoStack.add(pop(board));
    gameModel.redoPosList.add(gameModel.posList.removeLast());
    gameModel.lastPos = gameModel.posList.last;
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
    gameModel.redoPosList.add(gameModel.posList.removeLast());
    gameModel.redoPosList.add(gameModel.posList.removeLast());
    gameModel.lastPos = gameModel.posList.last;
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
    checkHintTiles = [];
    gameModel.lastPos = GamePageConst.startPos;
    gameModel.posList = [GamePageConst.startPos];
    gameModel.popMoveMeta();
  }

  void redoMove() {
    gameModel.posList.add(gameModel.redoPosList.removeLast());
    gameModel.lastPos = gameModel.posList.last;
    _moveCompletion(pushMSO(board.redoStack.removeLast(), board),
        clearRedo: false);
  }

  void redoTwoMoves() {
    gameModel.posList.add(gameModel.redoPosList.removeLast());
    gameModel.posList.add(gameModel.redoPosList.removeLast());
    gameModel.lastPos = gameModel.posList.last;
    _moveCompletion(pushMSO(board.redoStack.removeLast(), board),
        clearRedo: false, updateMetaList: true);
    _moveCompletion(pushMSO(board.redoStack.removeLast(), board),
        clearRedo: false, updateMetaList: true);
  }

  void promote(ChessPieceType type, MoveMeta meta) {
    board.moveStack.last.movedPiece?.type = type;
    board.moveStack.last.promotionType = type;
    addPromotedPiece(board, board.moveStack.last);
    gameModel.moveMetaList.last.promotionType = type;
    gameModel.lastPos = updatePos(meta, gameModel);
    _moveCompletion(gameModel.moveMetaList.last, updateMetaList: false);
    gameModel.pieceForPromotion = ChessPieceType.promotion;
    gameModel.isPromotionForPlayer = false;
  }

  void _moveCompletion(
    MoveMeta meta, {
    bool clearRedo = true,
    bool undoing = false,
    bool changeTurn = true,
    bool updateMetaList = true,
  }) {
    gameModel.setIsHintNeeded(false);
    if (clearRedo) {
      board.redoStack = [];
    }
    validMoves = [];
    latestMove = meta.move;
    checkHintTiles = [];
    var oppositeTurn = oppositePlayer(gameModel.turn);
    if (kingInCheck(oppositeTurn, board)) {
      meta.isCheck = true;
      checkHintTiles.add(kingForPlayer(oppositeTurn, board)!.tile);
    }
    if (pieceInCheck(oppositeTurn, board).isNotEmpty &&
        gameModel.isThreatsPicked && gameModel.playerCount == 1 && !meta.isCheck
        && !meta.isDraw && !meta.isStalemate && !meta.isCheckmate) {
      for (int tile in pieceInCheck(oppositeTurn, board)) {
        checkHintTiles.add(tile);
      }
    }
    if (kingInCheckmate(oppositeTurn, board)) {
      if (!meta.isCheck) {
        gameModel.stalemate = true;
        meta.isStalemate = true;
      }
      meta.isCheck = false;
      meta.isCheckmate = true;
      t.cancel();
      gameModel.endGame();
    }
    if (board.player1Pieces.length <= 2 && board.player2Pieces.length <= 2) {
      if (board.player1Pieces.length == 1 && board.player2Pieces.length == 1) {
        gameModel.draw = true;
        meta.isDraw = true;
        t.cancel();
        gameModel.endGame();
      }
      List<ChessPieceType> player1Pieces = [];
      List<ChessPieceType> player2Pieces = [];
      for (var piece in board.player1Pieces) {
        player1Pieces.add(piece.type);
      }
      for (var piece in board.player2Pieces) {
        player2Pieces.add(piece.type);
      }
      if ((player1Pieces.contains(ChessPieceType.bishop) ||
              player1Pieces.contains(ChessPieceType.knight)) &&
          (player2Pieces.contains(ChessPieceType.bishop) ||
              player2Pieces.contains(ChessPieceType.knight))) {
        gameModel.draw = true;
        meta.isDraw = true;
        t.cancel();
        gameModel.endGame();
      }
    }
    if (!meta.promotion && !undoing && clearRedo) {
      gameModel.lastPos = updatePos(meta, gameModel);
      if (checkDraw(gameModel, gameModel.lastPos)) {
        gameModel.draw = true;
        meta.isDraw = true;
        t.cancel();
        gameModel.endGame();
      }
    }
    if (undoing) {
      gameModel.popMoveMeta();
      gameModel.undoEndGame();
    } else if (updateMetaList) {
      gameModel.pushMoveMeta(meta);
    }
    if (changeTurn) {
      if(clearRedo) {
        addTimeOnMove();
      }
      gameModel.changeTurn();
    }
    selectedPiece = null;
    _sendAdvantagesToProvider();
    if (gameModel.isAIsTurn && clearRedo && changeTurn) {
      _aiMove();
    }
  }

  void addTimeOnMove() {
    if (gameModel.turn == Player.player1) {
      gameModel.incrementPlayer1Timer();
    } else {
      gameModel.incrementPlayer2Timer();
    }
  }

  void aiHint() {
    gameModel.setIsHintNeeded(false);
    var args = {};
    args["aiPlayer"] = gameModel.turn;
    args["aiDifficulty"] = 3;
    args["board"] = board;
    aiOperation = CancelableOperation.fromFuture(
      compute(calculateAIMove, args),
    );
    aiOperation?.value.then((move) {
      _selectPiece(board.tiles[move.from], move.to);
    });
  }

  void _sendAdvantagesToProvider() {
    int player1Advantage = 0;
    int player2Advantage = 0;
    for (var piece in board.player1Pieces) {
      player1Advantage += piece.advantage ?? 0;
    }
    for (var piece in board.player2Pieces) {
      player2Advantage += piece.advantage ?? 0;
    }
    gameModel.setPlayersAdvantage(player1Advantage, player2Advantage);
  }

  int _vector2ToTile(Vector2 vector2) {
    if (gameModel.flip &&
        gameModel.playingWithAI &&
        gameModel.playerSide == Player.player2) {
      return (7 - (vector2.y / (tileSize ?? 0)).floor()) *
              LogicConsts.lenOfRow +
          (7 - (vector2.x / (tileSize ?? 0)).floor());
    } else {
      return (vector2.y / (tileSize ?? 0)).floor() * LogicConsts.lenOfRow +
          (vector2.x / (tileSize ?? 0)).floor();
    }
  }

  void _drawBoard(Canvas canvas) {
    for (int tileNo = 0; tileNo < LogicConsts.countOfSquares; tileNo++) {
      canvas.drawRect(
        Rect.fromLTWH(
          (tileNo % LogicConsts.lenOfRow) * (tileSize ?? 0),
          (tileNo / LogicConsts.lenOfRow).floor() * (tileSize ?? 0),
          (tileSize ?? 0),
          (tileSize ?? 0),
        ),
        Paint()
          ..color = (tileNo + (tileNo / LogicConsts.lenOfRow).floor()) % 2 == 0
              ? ColorsConst.secondaryColor0
              : ColorsConst.secondaryColor200,
      );
    }
  }

  void _drawPieces(Canvas canvas) {
    for (var piece in board.player1Pieces + board.player2Pieces) {
      spriteMap[piece]?.sprite?.render(
            canvas,
            size: Vector2((tileSize ?? 0) - LogicConsts.height,
                (tileSize ?? 0) - LogicConsts.height),
            position: Vector2(
              (spriteMap[piece]?.spriteX ?? 0) + LogicConsts.offset,
              (spriteMap[piece]?.spriteY ?? 0) + LogicConsts.offset,
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
        (tileSize ?? 0) / LogicConsts.offset,
        Paint()..color = ColorsConst.primaryColor100,
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
        Paint()..color = ColorsConst.feedback300,
      );
      if (!checkHintTiles.contains(latestMove!.to)) {
        canvas.drawRect(
          Rect.fromLTWH(
            getXFromTile(latestMove!.to, tileSize ?? 0, gameModel),
            getYFromTile(latestMove!.to, tileSize ?? 0, gameModel),
            tileSize ?? 0,
            tileSize ?? 0,
          ),
          Paint()..color = ColorsConst.feedback300,
        );
      }
    }
  }

  void _drawCheckHint(Canvas canvas) {
    if (checkHintTiles.isNotEmpty) {
      for (int tile in checkHintTiles) {
        canvas.drawRect(
          Rect.fromLTWH(
            getXFromTile(tile, tileSize ?? 0, gameModel),
            getYFromTile(tile, tileSize ?? 0, gameModel),
            tileSize ?? 0,
            tileSize ?? 0,
          ),
          Paint()..color = ColorsConst.feedback100,
        );
      }
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
        Paint()..color = ColorsConst.primaryColor100,
      );
    }
  }
}
