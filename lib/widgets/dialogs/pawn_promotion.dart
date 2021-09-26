import 'package:chess_app/widgets/piece_image.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_app/extensions/piece.dart';

class PawnPromotionDialog extends StatelessWidget {
  static final _pieces = List<chess.PieceType>.unmodifiable([
    chess.PieceType.QUEEN,
    chess.PieceType.ROOK,
    chess.PieceType.BISHOP,
    chess.PieceType.KNIGHT
  ]);

  final chess.Color color;

  PawnPromotionDialog(this.color);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pawn Promotion'),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.from(
          _pieces.map((type) {
            chess.Piece p = chess.Piece(type, color);
            final String fileName = 'assets/images/${p.getImageFileName()}';
            return Flexible(
              child: Container(
                padding: EdgeInsets.all(4.0),
                height: 50,
                child: MaterialButton(
                  child: PieceImage(p),
                  onPressed: () => Navigator.of(context).pop(type),
                ),
              ),
            );
          }),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(null),
        )
      ],
    );
  }
}
