import 'package:chess_app/controllers/board_controller.dart';
import 'package:chess_app/controllers/clock_controller.dart';
import 'package:chess_app/models/DrawType.dart';
import 'package:chess_app/models/WinType.dart';
import 'package:chess_app/screens/play_settings_screen.dart';
import 'package:chess_app/util/UserSettings.dart';
import 'package:chess_app/widgets/board.dart';
import 'package:chess_app/widgets/player_clock.dart';
import 'package:flutter/material.dart';
import 'package:chess/chess.dart' as chess;
import 'package:chess_app/extensions/chess.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  BoardController? _boardController;
  Map<chess.Color, ClockController>? _clockControllerMap;
  Map<chess.Color, String>? _nameMap;

  bool flipped = false;

  @override
  void initState() {
    super.initState();

    this._boardController = BoardController(
      onDraw: onDrawCallback,
      onMove: onMoveCallback,
      onWin: onWinCallback,
      game: chess.Chess(),
    );

    _clockControllerMap = {
      chess.Color.WHITE: ClockController(
        seconds: 180.0,
        delay: 3.0,
        increment: 2.0,
        onFinished: () => onWinCallback(WinType.TIMEOUT, chess.Color.BLACK),
      ),
      chess.Color.BLACK: ClockController(
        seconds: 180.0,
        delay: 0.0,
        increment: 2.0,
        onFinished: () => onWinCallback(WinType.TIMEOUT, chess.Color.WHITE),
      ),
    };

    _nameMap = {
      chess.Color.WHITE: 'White',
      chess.Color.BLACK: 'Black',
    };
  }

  @override
  Widget build(BuildContext context) {
    final bottomColor = _getBottomColor();
    final topColor = bottomColor.other;
    final ClockController topClock = _clockControllerMap![topColor]!;
    final ClockController bottomClock = _clockControllerMap![bottomColor]!;

    final String topName = _nameMap![topColor]!;
    final String bottomName = _nameMap![bottomColor]!;

    final topCaptures = _boardController!.getCapturedPieces(topColor);
    final bottomCaptures = _boardController!.getCapturedPieces(bottomColor);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Play'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_rounded),
            onPressed: () async {
              // TODO: We won't want to pause clock for network game
              // Store current clock states
              final clockStates = _clockControllerMap!.map(
                (key, value) => MapEntry(key, value.isRunning),
              );

              // Stop all clocks
              _clockControllerMap!.values.forEach(
                (clock) => clock.stop(doIncrement: false),
              );

              // Open Settings Menu
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlaySettings()),
              );

              // Restore clock states
              _clockControllerMap!.forEach(
                (key, clock) => clock.setRunning(clockStates[key]!),
              );
            },
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(Icons.menu_rounded),
              onPressed: () => showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  height: 300,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: new Icon(Icons.flag_rounded),
                        title: new Text('Resign'),
                        onTap: () {
                          _boardController?.undoMove();
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: new Icon(FontAwesomeIcons.handshake, size: 20),
                        title: new Text('Offer Draw'),
                        onTap: () {
                          _boardController?.undoMove();
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: new Icon(Icons.undo),
                        title: new Text('Undo Move'),
                        onTap: () {
                          _boardController?.undoMove();
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: new Icon(Icons.autorenew_rounded),
                        title: new Text('Flip Board'),
                        onTap: () {
                          flipBoard();
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: new Icon(Icons.refresh_rounded),
                        title: new Text('Reset Board'),
                        onTap: () {
                          resetBoard();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.lightbulb_outline_rounded),
              onPressed: () => null,
            ),
            IconButton(
              icon: Icon(Icons.arrow_back_rounded),
              onPressed: () => _boardController?.undoMove(),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_rounded),
              onPressed: () => _boardController?.redoMove(),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Column(
              children: [
                PlayerClock(
                  topName,
                  topClock,
                  pieces: topCaptures
                      .map<chess.Piece>((p) => chess.Piece(p, bottomColor)),
                ),
                Board(
                  controller: _boardController!,
                  flipped: flipped,
                  squareColors: SquareColorTheme.lichess,
                ),
                PlayerClock(
                  bottomName,
                  bottomClock,
                  pieces: bottomCaptures
                      .map<chess.Piece>((p) => chess.Piece(p, topColor)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onMoveCallback(chess.Move move) async {
    print('${move.fromAlgebraic} -> ${move.toAlgebraic}');
    setActiveClock(move.color.other);

    setState(() {});

    if (await UserSettings.flipBoardEachTurn) {
      _setBottomColor(move.color.other);
    }
  }

  void onDrawCallback(DrawType type) {
    print('Draw.');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Draw!'),
        content: Text('Would you like to play again?'),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Rematch'),
            onPressed: () {
              resetBoard();
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('New Game'),
            onPressed: () {
              resetBoard();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void onWinCallback(WinType type, chess.Color winner) {
    print('Winner: ${winner.toPrintString()} by $type');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${winner.toPrintString()} wins!'),
        content: Text('Would you like to play again?'),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Rematch'),
            onPressed: () {
              resetBoard();
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text('New Game'),
            onPressed: () {
              resetBoard();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void setActiveClock(chess.Color color) {
    _clockControllerMap?.forEach((c, clock) => clock.setRunning(c == color));
  }

  chess.Color _getBottomColor() {
    return flipped ? chess.Color.BLACK : chess.Color.WHITE;
  }

  void _setBottomColor(chess.Color color) {
    if (color != _getBottomColor()) {
      flipBoard();
    }
  }

  void flipBoard() {
    setState(() {
      flipped = !flipped;
    });
  }

  void resetBoard() {
    _boardController?.reset();
    _clockControllerMap?.values.forEach(
      (clock) => clock.stop(reset: true, doIncrement: false),
    );

    setState(() {
      // TODO: Add setting if playing as black, make true
      flipped = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _boardController?.dispose();
    _clockControllerMap?.values.forEach((clock) => clock.dispose());
  }
}
