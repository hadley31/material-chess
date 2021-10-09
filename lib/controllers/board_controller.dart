import 'dart:collection';

import 'package:chess/chess.dart' as chess;
import 'package:chess_app/models/DrawType.dart';
import 'package:chess_app/models/WinType.dart';
import 'package:flutter/material.dart';
import 'package:chess_app/extensions/chess.dart';

typedef void WinCallback(WinType type, chess.Color color);
typedef void MoveCallback(chess.Move move);
typedef void DrawCallback(DrawType type);

class BoardController extends ChangeNotifier {
  final chess.Chess game;
  final WinCallback onWin;
  final MoveCallback onMove;
  final DrawCallback onDraw;

  final Map<chess.Color, List<chess.PieceType>> _capturedPieces =
      Map.unmodifiable({
    chess.Color.WHITE: <chess.PieceType>[],
    chess.Color.BLACK: <chess.PieceType>[],
  });
  final Queue<chess.Move> _undoneMoves = Queue<chess.Move>(); // Used as stack

  BoardController({
    required this.onMove,
    required this.onDraw,
    required this.onWin,
    required this.game,
  });

  List<chess.PieceType> get whiteCapturedPieces =>
      _capturedPieces[chess.Color.WHITE]!;
  List<chess.PieceType> get blackCapturedPieces =>
      _capturedPieces[chess.Color.BLACK]!;

  bool move(String from, String to, {chess.PieceType? promotion}) {
    if (_undoneMoves.isNotEmpty) {
      _undoneMoves.clear();
    }

    bool result = game.move({
      'from': from,
      'to': to,
      'promotion': promotion?.name,
    });

    if (result) {
      final move = lastMove!;
      this.notifyListeners();
      this.onMove(move);
      if (move.captured != null) {
        _capturedPieces[lastMove?.color]?.add(move.captured!);
      }
    }

    if (game.in_checkmate) {
      this.onWin(WinType.CHECKMATE, winner!);
    } else if (game.in_draw) {
      if (game.in_threefold_repetition) {
        this.onDraw(DrawType.THREEFOLD_REPETITION);
      } else if (game.in_stalemate) {
        this.onDraw(DrawType.STALEMATE);
      } else if (game.insufficient_material) {
        this.onDraw(DrawType.INSUFFICIENT_MATERIAL);
      }
    }

    return result;
  }

  undoMove() {
    final move = game.undo();
    if (move != null) {
      this.notifyListeners();
      if (lastMove != null) {
        this.onMove(lastMove!);
      }

      final ugly = _makeUgly(move);

      if (ugly?.captured != null &&
          (_capturedPieces[ugly!.color]?.isNotEmpty ?? false)) {
        _capturedPieces[ugly.color]?.removeLast();
      }

      _undoneMoves.add(ugly!);
    }
  }

  void redoMove() {
    if (_undoneMoves.isEmpty) return;
    final move = _undoneMoves.removeLast();
    this.move(move.fromAlgebraic, move.toAlgebraic, promotion: move.promotion);
  }

  void reset() {
    game.reset();
    _undoneMoves.clear();
    _capturedPieces.forEach((x, y) => y.clear());
    this.notifyListeners();
  }

  chess.Color? get winner {
    if (game != null && game.in_checkmate) {
      final bool whiteWins = game.king_attacked(chess.Color.BLACK);

      return whiteWins ? chess.Color.WHITE : chess.Color.BLACK;
    }
    return null;
  }

  chess.Move? get lastMove {
    return game.history.length > 0 ? game.history.last.move : null;
  }

  chess.Color get turn {
    return game.turn;
  }

  List<chess.Move> getMovesForSquare(String? square) {
    return game.generate_moves({'square': square});
  }

  bool squareIsLight(String square) {
    return game.square_color(square) == 'light';
  }

  chess.Piece? getPiece(String square) {
    return game.get(square);
  }

  List<chess.PieceType> getCapturedPieces(chess.Color color) {
    return _capturedPieces[color]!;
  }

  chess.Move? _makeUgly(move) {
    if (move is chess.Move) {
      return move;
    }

    List<chess.Move> moves = game.generate_moves();

    if (move is Map) {
      /* convert the pretty move object to an ugly move object */
      for (var i = 0; i < moves.length; i++) {
        if (move['from'] == moves[i].fromAlgebraic &&
            move['to'] == moves[i].toAlgebraic &&
            (moves[i].promotion == null ||
                move['promotion'] == moves[i].promotion?.name)) {
          return moves[i];
        }
      }
    } else if (move is String) {
      /* convert the move string to a move object */
      for (int i = 0; i < moves.length; i++) {
        if (move == game.move_to_san(moves[i])) {
          return moves[i];
        }
      }
    }
    return null;
  }
}
