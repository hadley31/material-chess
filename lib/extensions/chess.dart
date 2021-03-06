import 'package:chess/chess.dart';
import 'package:flutter/foundation.dart';

typedef ColorFlags = int;

extension ColorFlagsExtensions on ColorFlags {
  static const ColorFlags none = 0;
  static const ColorFlags white = 1;
  static const ColorFlags black = 2;
  static const ColorFlags both = 3;

  static ColorFlags getFlag(Color color) {
    return color == Color.WHITE ? white : black;
  }

  bool contains(Color color) {
    return this & color.flag != none;
  }
}

extension ChessColorExtensions on Color {
  Color get other => Chess.swap_color(this);
  String toPrintString() => this == Color.BLACK ? 'Black' : 'White';
  int get flag => this == Color.BLACK
      ? ColorFlagsExtensions.black
      : ColorFlagsExtensions.white;

  ColorFlags operator |(Color other) {
    return this.flag | other.flag;
  }
}

extension ChessMoveExtensions on Move {
  Piece? get capturedPiece {
    return captured == null ? Piece(captured!, color.other) : null;
  }
}

extension PieceExtensions on Piece {
  String getImageFileName() {
    String color = describeEnum(this.color)[0].toLowerCase();
    String type = this.type.name;

    return "${color}_${type}_png_128px.png";
  }
}
