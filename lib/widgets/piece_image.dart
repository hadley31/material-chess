import 'package:chess/chess.dart';
import 'package:flutter/material.dart';
import 'package:chess_app/extensions/chess.dart';

class PieceImage extends StatelessWidget {
  final Piece piece;
  final double? size;

  PieceImage(this.piece, {this.size});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/${piece.getImageFileName()}',
      width: size,
      height: size,
    );
  }
}
