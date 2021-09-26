import 'package:flutter/material.dart';

class MoveIndicator extends StatelessWidget {
  final Color color;
  final int alpha;
  final double sizeFactor;

  MoveIndicator({this.color, this.sizeFactor = 0.7, this.alpha = 100});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: sizeFactor,
      heightFactor: sizeFactor,
      child: Container(
        decoration: BoxDecoration(
          color: color.withAlpha(alpha),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
