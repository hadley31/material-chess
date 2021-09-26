import 'package:chess/chess.dart';

extension ChessColorExtensions on Color {
  Color get other => this == Color.BLACK ? Color.WHITE : Color.BLACK;
  String toPrintString() => this == Color.BLACK ? 'Black' : 'White';
}

extension ChessMoveExtensions on Move {
  Piece get capturedPiece => Piece(captured, color.other);
}
