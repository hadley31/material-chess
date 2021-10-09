import 'package:chess/chess.dart';
import 'package:flutter/foundation.dart';

extension PieceExtensions on Piece {
  String getImageFileName() {
    String color = describeEnum(this.color)[0].toLowerCase();
    String type = this.type.name;

    return "${color}_${type}_png_128px.png";
  }
}
