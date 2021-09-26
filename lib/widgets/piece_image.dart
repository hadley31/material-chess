import 'package:chess/chess.dart';
import 'package:flutter/material.dart';
import 'package:chess_app/extensions/piece.dart';

class PieceImage extends StatelessWidget {
  final Piece piece;
  final double size;

  PieceImage(this.piece, {this.size}) {
    assert(this.piece != null);
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/${piece.getImageFileName()}',
      width: size,
      height: size,
    );
  }
}
