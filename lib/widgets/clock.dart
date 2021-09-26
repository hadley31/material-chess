import 'package:chess_app/controllers/clock_controller.dart';
import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  final ClockController controller;

  Clock({@required this.controller});

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
    final double seconds = (controller.value % 60);

    final String minutesString = minutes > 0 ? '$minutes:' : '';

    final String secondsString = _formatSeconds(minutes, seconds);

    final String time = '$minutesString$secondsString';
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
        time,
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
    if (minutes == 0) {
      if (seconds < 10) {
        return seconds.toStringAsFixed(1);
      } else {
        return seconds.toStringAsFixed(0);
      }
    } else {
      return seconds.floor().toString().padLeft(2, '0');
    }
  }
}
