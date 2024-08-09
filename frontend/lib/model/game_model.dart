import "dart:async";
import "dart:math";

import "../exports.dart";
import "package:flutter/material.dart";

const timerAccuracyMs = 100;

enum Player { player1, random, player2 }

class GameModel extends ChangeNotifier {
  int playerCount = 1;
  int aiDifficulty = 3;
  Player selectedSide = Player.player1;
  Player playerSide = Player.player1;
  int timeLimit = 10;
  bool showMoveHistory = true;
  bool allowUndoRedo = true;
  bool showHints = true;
  bool flip = true;

  ChessGame? game;
  Timer? timer;
  bool gameOver = false;
  bool stalemate = false;
  bool promotionRequested = false;
  bool isPromotionForPlayer = false;
  ChessPieceType pieceForPromotion = ChessPieceType.promotion;
  bool moveListUpdated = false;
  Player turn = Player.player1;
  List<MoveMeta> moveMetaList = [];
  Duration player1TimeLeft = Duration.zero;
  Duration player2TimeLeft = Duration.zero;

  Player get aiTurn {
    return oppositePlayer(playerSide);
  }

  bool get isAIsTurn {
    return playingWithAI && (turn == aiTurn);
  }

  bool get playingWithAI {
    return playerCount == 1;
  }

  void newGame(BuildContext context, {bool notify = true}) {
    game?.cancelAIMove();
    timer?.cancel();
    gameOver = false;
    stalemate = false;
    turn = Player.player1;
    moveMetaList = [];
    player1TimeLeft = Duration(minutes: timeLimit);
    player2TimeLeft = Duration(minutes: timeLimit);
    if (selectedSide == Player.random) {
      playerSide =
          Random.secure().nextInt(2) == 0 ? Player.player1 : Player.player2;
    }
    game = ChessGame(this, context);
    timer = Timer.periodic(const Duration(milliseconds: timerAccuracyMs),
        (timer) {
      turn == Player.player1
          ? decrementPlayer1Timer()
          : decrementPlayer2Timer();
      if ((player1TimeLeft == Duration.zero ||
              player2TimeLeft == Duration.zero) &&
          timeLimit != 0) {
        endGame();
      }
    });
    if (notify) {
      notifyListeners();
    }
  }

  void exitChessView() {
    game?.cancelAIMove();
    timer?.cancel();
    notifyListeners();
  }

  void pushMoveMeta(MoveMeta meta) {
    moveMetaList.add(meta);
    moveListUpdated = true;
    notifyListeners();
  }

  void popMoveMeta() {
    moveMetaList.removeLast();
    moveListUpdated = true;
    notifyListeners();
  }

  void endGame() {
    gameOver = true;
    notifyListeners();
  }

  void undoEndGame() {
    gameOver = false;
    notifyListeners();
  }

  void changeTurn() {
    turn = oppositePlayer(turn);
    notifyListeners();
  }

  void requestPromotion() {
    promotionRequested = true;
    notifyListeners();
  }

  void setPlayerCount(int? count) {
    if (count != null) {
      playerCount = count;
      notifyListeners();
    }
  }

  void setAIDifficulty(int? difficulty) {
    if (difficulty != null) {
      aiDifficulty = difficulty;
      notifyListeners();
    }
  }

  void setPlayerSide(Player? side) {
    if (side != null) {
      selectedSide = side;
      if (side != Player.random) {
        playerSide = side;
      }
      notifyListeners();
    }
  }

  void setTimeLimit(int? duration) {
    if (duration != null) {
      timeLimit = duration;
      player1TimeLeft = Duration(minutes: timeLimit);
      player2TimeLeft = Duration(minutes: timeLimit);
      notifyListeners();
    }
  }

  void setPieceForPromotion(ChessPieceType piece) async {
    pieceForPromotion = piece;
    notifyListeners();
  }

  void decrementPlayer1Timer() {
    if (player1TimeLeft.inMilliseconds > 0 && !gameOver) {
      player1TimeLeft = Duration(
          milliseconds: player1TimeLeft.inMilliseconds - timerAccuracyMs);
      notifyListeners();
    }
  }

  void decrementPlayer2Timer() {
    if (player2TimeLeft.inMilliseconds > 0 && !gameOver) {
      player2TimeLeft = Duration(
          milliseconds: player2TimeLeft.inMilliseconds - timerAccuracyMs);
      notifyListeners();
    }
  }

  void setShowMoveHistory(bool show) async {
    showMoveHistory = show;
    notifyListeners();
  }

  Future<void> setShowHints(bool show) async {
    showHints = show;
    notifyListeners();
  }

  void setFlipBoard(bool flip) async {
    this.flip = flip;
    notifyListeners();
  }

  Future<void> setAllowUndoRedo(bool allow) async {
    allowUndoRedo = allow;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }
}