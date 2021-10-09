import 'dart:math';

import 'package:chess_app/controllers/clock_controller.dart';
import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  final ClockController controller;

  Clock({required this.controller});

  @override
  createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  ClockController get controller => widget.controller;

  @override
  void initState() {
    super.initState();

    controller.addListener(_tick);
  }

  void _tick() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final int minutes = (controller.value / 60).floor();
    final int seconds = (controller.value % 60).floor();
    final int deciseconds = (controller.value % 1 * 10).floor();

    final String secondsString = seconds.toString().padLeft(2, "0");

    final StringBuffer time = StringBuffer('$minutes:$secondsString');

    if (minutes == 0 && seconds < 15) {
      time.write('.$deciseconds');
    }

    return Container(
      width: 50,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      padding: EdgeInsets.all(3),
      alignment: Alignment.center,
      child: Text(
        time.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  void didUpdateWidget(Clock old) {
    super.didUpdateWidget(old);

    if (old.controller != controller) {
      old.controller.removeListener(_tick);
      controller.addListener(_tick);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(_tick);
  }

  String _formatSeconds(int minutes, double seconds) {
    if (minutes == 0 && seconds < 10) {
      return seconds.toStringAsFixed(1).padLeft(4, "0");
    } else {
      return min(seconds, 59.0).toStringAsFixed(0).padLeft(2, "0");
    }
  }
}
