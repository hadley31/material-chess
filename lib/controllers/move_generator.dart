import 'dart:async';

import 'package:chess/chess.dart';
import 'package:chess_app/controllers/board_controller.dart';

typedef PrettyMove = Map<String, String>;

class MoveGenerator {
  final StreamController<PrettyMove> _moveStream = StreamController();
  final List<StreamSubscription<Map<String, String>>> subscribers = [];

  MoveGenerator();

  void addListener(Function(PrettyMove) listener) {
    final sub = _moveStream.stream.listen(listener);
  }

  void close() {
    _moveStream.close();
  }
}

class NetworkMoveGenerator extends MoveGenerator {}
