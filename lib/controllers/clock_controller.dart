import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

typedef void ClockFinishedCallback();

class ClockController extends ValueNotifier<double> {
  static const double _deltaTime = 0.1;

  double seconds;
  double increment;
  double delay;

  final ClockFinishedCallback? onFinished;

  Timer? _timer;
  bool _isFinished = false;
  bool _isRunning = false;

  bool get isRunning => _isRunning;
  bool get isFinished => _isFinished;

  ClockController({
    required this.seconds,
    this.increment = 0,
    this.delay = 0,
    this.onFinished,
  }) : super(seconds);

  void start([bool doDelay = true]) async {
    if (_isRunning) return;
    _isRunning = true;

    if (doDelay) {
      await Future.delayed(Duration(milliseconds: _millis(delay)));
    }

    if (_isRunning && _timer == null) {
      _timer = Timer.periodic(
        Duration(milliseconds: _millis(_deltaTime)),
        _tick,
      );
    }
  }

  void stop({bool reset = false, bool doIncrement = true}) {
    if (reset) this.reset();
    if (_isFinished) return;
    if (!_isRunning) return;
    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    if (doIncrement) value += increment;
  }

  void reset() {
    value = seconds;
    _isFinished = false;
  }

  void toggle() {
    _isRunning ? stop() : start();
  }

  void setRunning(bool running) {
    if (running) {
      start();
    } else {
      stop();
    }
  }

  void _tick(Timer t) {
    if (t != _timer) {
      t.cancel();
      return;
    }

    value = max(0, value - _deltaTime);

    if (value == 0) {
      _isFinished = true;
      _isRunning = false;
      onFinished?.call();
      t.cancel();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  String toString() {
    return "Clock";
  }
}

int _millis(double seconds) {
  return (seconds * 1000).round();
}
