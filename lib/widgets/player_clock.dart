import 'package:chess/chess.dart' as chess;
import 'package:chess_app/controllers/clock_controller.dart';
import 'package:chess_app/widgets/piece_image.dart';
import 'package:chess_app/widgets/clock.dart';
import 'package:flutter/material.dart';

class PlayerClock extends StatelessWidget {
  final String playerName;
  final ClockController clockController;
  final Iterable<chess.Piece>? pieces;

  PlayerClock(this.playerName, this.clockController, {this.pieces});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            playerName,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          if (pieces != null && (pieces?.isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: pieces!
                    .map<PieceImage>((p) => PieceImage(p, size: 15))
                    .toList(),
              ),
            ),
          Spacer(),
          Clock(controller: clockController),
        ],
      ),
    );
  }
}
