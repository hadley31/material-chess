import 'package:chess/chess.dart';

extension PieceExtensions on Piece {
  String getImageFileName() {
    String color = this.color.toString();
    String type = this.type.name;

    return "${color}_${type}_png_128px.png";
  }
}
