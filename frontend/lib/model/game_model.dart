import "dart:async";
import "dart:math";

import "package:flame/palette.dart";

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
  int addingOnMove = 0;
  bool showMoveHistory = true;
  bool allowUndoRedo = true;
  bool showMoves = true;
  bool showHint = true;
  bool flip = true;
  bool isPersonalityMode = false;

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

  int player1Advantage = 0;
  int player2Advantage = 0;

  void setPlayersAdvantage(int player1Advantage, int player2Advantage) {
    this.player1Advantage = player1Advantage;
    this.player2Advantage = player2Advantage;
    notifyListeners();
  }

  int advantageForPlayer(Player player) {
    return player == Player.player1 ? player1Advantage : player2Advantage;
  }

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
    player1Advantage = 0;
    player2Advantage = 0;
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
    timer =
        Timer.periodic(const Duration(milliseconds: timerAccuracyMs), (timer) {
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

  void setAddingOnMove(int duration) {
    addingOnMove = duration;
    notifyListeners();
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

  void incrementPlayer1Timer() {
    if (player1TimeLeft.inMilliseconds > 0 && !gameOver) {
      player1TimeLeft = Duration(
          seconds: player1TimeLeft.inSeconds + addingOnMove);
      notifyListeners();
    }
  }

  void incrementPlayer2Timer() {
    if (player2TimeLeft.inMilliseconds > 0 && !gameOver) {
      player2TimeLeft = Duration(
          seconds: player2TimeLeft.inSeconds + addingOnMove);
      notifyListeners();
    }
  }

  void setShowMoveHistory(bool show) async {
    showMoveHistory = show;
    notifyListeners();
  }

  Future<void> setShowMoves(bool show) async {
    showMoves = show;
    notifyListeners();
  }

  Future<void> setShowHint(bool show) async {
    showHint = show;
    notifyListeners();
  }

  void setIsPersonalityMode(bool show) {
    isPersonalityMode = show;
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
