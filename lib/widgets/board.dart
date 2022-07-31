import 'dart:async';

import 'package:collection/collection.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_app/controllers/board_controller.dart';
import 'package:chess_app/widgets/dialogs/pawn_promotion.dart';
import 'package:chess_app/widgets/move_indicator.dart';
import 'package:chess_app/widgets/piece_image.dart';
import 'package:chess_app/extensions/chess.dart';
import 'package:flutter/material.dart';

const SQUARES = [
  'a8', 'b8', 'c8', 'd8', 'e8', 'f8', 'g8', 'h8', //
  'a7', 'b7', 'c7', 'd7', 'e7', 'f7', 'g7', 'h7', //
  'a6', 'b6', 'c6', 'd6', 'e6', 'f6', 'g6', 'h6', //
  'a5', 'b5', 'c5', 'd5', 'e5', 'f5', 'g5', 'h5', // Comments for
  'a4', 'b4', 'c4', 'd4', 'e4', 'f4', 'g4', 'h4', // Forced Formatting
  'a3', 'b3', 'c3', 'd3', 'e3', 'f3', 'g3', 'h3', //
  'a2', 'b2', 'c2', 'd2', 'e2', 'f2', 'g2', 'h2', //
  'a1', 'b1', 'c1', 'd1', 'e1', 'f1', 'g1', 'h1', //
];

class Board extends StatefulWidget {
  final BoardController controller;
  final bool flipped;
  final SquareColorTheme? squareColors;
  final ColorFlags colorsAllowedToMove;
  final StreamController<chess.Move>? moveStreamController;

  Board({
    required this.controller,
    SquareColorTheme? squareColors,
    this.colorsAllowedToMove = ColorFlagsExtensions.none,
    this.flipped = false,
    this.moveStreamController,
  }) : this.squareColors = squareColors ?? SquareColorTheme.lichess;

  @override
  createState() => _BoardState();
}

class _BoardState extends State<Board> {
  String? selectedSquare;

  bool get flipped => widget.flipped;
  BoardController get controller => widget.controller;

  void updateSelectedSquare(dynamic s) {
    if (selectedSquare == null && s == null) return;
    if (selectedSquare == s) return;
    setState(() {
      selectedSquare = s;
    });
  }

  @override
  void initState() {
    super.initState();

    controller.addListener(_boardUpdateCallback);
  }

  void _boardUpdateCallback() => setState(() => {});

  void _onSquareTapped(Square s) async {
    // Did we tap the already selected square?
    // If so, remove selection
    if (s.name == selectedSquare) return updateSelectedSquare(null);

    bool canSelectSquare =
        s.piece?.color.within(widget.colorsAllowedToMove) ?? true;
    if (selectedSquare == null && !canSelectSquare)
      return updateSelectedSquare(null);

    // Is the square NOT a possible move?
    // If so, select the square if it has a piece
    if (!s.isPossibleMove)
      return updateSelectedSquare(s.piece != null ? s.name : null);

    _attemptMove(selectedSquare, s.name);
  }

  void _onSquareDragStart(Square square) {
    updateSelectedSquare(square.name);
  }

  void _onSquareDragEnd(Square from, Square to) {
    _attemptMove(from.name, to.name);
  }

  bool _canAcceptMove(Square from, Square to) {
    return controller
        .getMovesForSquare(from.name)
        .any((m) => m.toAlgebraic == to.name);
  }

  void _attemptMove(String? from, String target) async {
    if (selectedSquare == null) {
      return;
    }

    if (!widget.colorsAllowedToMove.contains(controller.turn)) {
      print("Color not allowed to move!");
      return;
    }

    // Generate list of possible moves from selectedSquare
    final moves = controller.getMovesForSquare(selectedSquare!);

    // Get the move that matches our selected squares
    chess.Move? move = moves.firstWhereOrNull(
      (m) => m.fromAlgebraic == selectedSquare && m.toAlgebraic == target,
    );

    // No move?? This shouldn't be possible logically, but check just in case
    if (move == null) return updateSelectedSquare(null);

    // Are we promoting?
    if (move.promotion != null) {
      // Open promotion dialog
      chess.PieceType? type = await showDialog<chess.PieceType>(
        context: context,
        builder: (_) => PawnPromotionDialog(move!.color),
      );

      // If player cancelled the promotion, cancel move
      if (type == null) return updateSelectedSquare(null);

      move = move.withPromotion(type);
    }

    // Send move to the move stream
    print("Pushing move...");
    pushMove(move);

    updateSelectedSquare(null);
  }

  void pushMove(chess.Move move) {
    widget.moveStreamController?.add(move);
  }

  @override
  Widget build(BuildContext context) {
    final possibleMoves = controller.getMovesForSquare(selectedSquare);

    return Container(
      child: GridView.count(
        crossAxisCount: 8,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: List.from(
          _iterateSquares(flipped: flipped).map<Square>((name) {
            final chess.Piece? piece = controller.getPiece(name);

            final bool isLight = controller.squareIsLight(name);
            final bool isSelected = name == selectedSquare;
            final bool isChecked = piece != null &&
                piece.type == chess.PieceType.KING &&
                controller.game.king_attacked(piece.color);
            return Square(
              name: name,
              isLight: isLight,
              colors: widget.squareColors!,
              piece: piece,
              onTap: _onSquareTapped,
              onDragStarted: _onSquareDragStart,
              onDragAccept: _onSquareDragEnd,
              canAcceptDragMove: _canAcceptMove,
              isSelected: isSelected,
              isPossibleMove: possibleMoves.any((s) => s.toAlgebraic == name),
              isChecked: isChecked,
              isPreviousMove: name == controller.lastMove?.toAlgebraic ||
                  name == controller.lastMove?.fromAlgebraic,
              showRank: name[0] == (flipped ? 'h' : 'a'),
              showFile: name[1] == (flipped ? '8' : '1'),
            );
          }),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(Board old) {
    super.didUpdateWidget(old);

    if (old.controller != controller) {
      old.controller.removeListener(_boardUpdateCallback);
      controller.addListener(_boardUpdateCallback);
    }
  }

  @override
  void dispose() {
    super.dispose();

    controller.removeListener(_boardUpdateCallback);
  }
}

typedef void SquareCallback(Square s);
typedef bool SquareDragMoveCallback(Square from, Square to);
typedef void SquareMoveCallback(Square from, Square to);

class SquareColorTheme {
  final Color light;
  final Color dark;
  final Color? selectedHighlight;
  final Color? checkHighlight;
  final Color? previousMoveHighlight;

  SquareColorTheme({
    required this.light,
    required this.dark,
    this.selectedHighlight,
    this.checkHighlight,
    this.previousMoveHighlight,
  });

  static final SquareColorTheme defaultTheme = SquareColorTheme(
    light: Colors.grey,
    dark: Colors.grey[700]!,
  );

  static final SquareColorTheme chesscom = SquareColorTheme(
    light: Color.fromARGB(255, 238, 238, 210),
    dark: Color.fromARGB(255, 118, 150, 86),
  );

  static final SquareColorTheme lichess = SquareColorTheme(
    light: Color.fromARGB(255, 240, 217, 181),
    dark: Color.fromARGB(255, 181, 136, 99),
  );

  Color get([bool light = true]) {
    return light ? this.light : this.dark;
  }
}

class Square extends StatelessWidget {
  final String name;
  final bool isSelected;
  final bool isChecked;
  final bool isLight;
  final SquareColorTheme colors;
  final bool isPossibleMove;
  final bool isPreviousMove;
  final bool showRank;
  final bool showFile;
  final chess.Piece? piece;
  final SquareCallback? onTap;
  final SquareCallback? onDragStarted;
  final SquareMoveCallback? onDragAccept;
  final SquareDragMoveCallback? canAcceptDragMove;

  String get rank => name[0];
  String get file => name[1];

  Square({
    required this.name,
    required this.isLight,
    required this.colors,
    this.piece,
    this.onTap,
    this.onDragStarted,
    this.onDragAccept,
    this.canAcceptDragMove,
    this.isSelected = false,
    this.isPossibleMove = false,
    this.isChecked = false,
    this.isPreviousMove = false,
    this.showRank = true,
    this.showFile = true,
  });

  Color getOverlayColor() {
    if (isPreviousMove) return Colors.amber[400]!.withAlpha(170);
    if (isSelected) return Colors.green[400]!.withAlpha(170);
    if (isChecked) return Colors.red[400]!.withAlpha(170);
    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<Square>(
      builder: (context, a, b) => Material(
        color: Color.alphaBlend(getOverlayColor(), colors.get(isLight)),
        child: InkWell(
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              if (piece != null)
                LayoutBuilder(
                  builder: (context, constraints) => Draggable<Square>(
                    data: this,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: PieceImage(piece!),
                    ),
                    feedback: SizedBox(
                      child: PieceImage(piece!),
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                    childWhenDragging: Container(),
                    onDragStarted: () => onDragStarted?.call(this),
                  ),
                ),
              if (isPossibleMove)
                MoveIndicator(
                  color: colors.get(!isLight),
                  alpha: 200,
                  sizeFactor: 0.6,
                ),
              if (showFile)
                Positioned(
                  bottom: 1.0,
                  right: 1.0,
                  child: Text(
                    name[0],
                    style: TextStyle(
                      color: colors.get(!isLight),
                      fontSize: 10,
                    ),
                  ),
                ),
              if (showRank)
                Positioned(
                  top: 1.0,
                  left: 1.0,
                  child: Text(
                    name[1],
                    style: TextStyle(
                      color: colors.get(!isLight),
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),
          onTap: () => onTap?.call(this),
        ),
      ),
      onWillAccept: (square) => canAcceptDragMove?.call(square!, this) ?? false,
      onAccept: (square) => onDragAccept?.call(square, this),
    );
  }
}

Iterable<String> _iterateSquares({bool flipped = false}) sync* {
  final squares = flipped ? SQUARES.reversed : SQUARES;
  for (final s in squares) {
    yield s;
  }
}
