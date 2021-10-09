import 'package:flutter/material.dart';

class MoveNavigator extends StatelessWidget {
  final Function onMoveForward;
  final Function onMoveBackward;

  MoveNavigator({required this.onMoveBackward, required this.onMoveForward});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          color: Colors.green,
          icon: Icon(Icons.arrow_back_ios_outlined),
          onPressed: () => onMoveBackward(),
        ),
        IconButton(
          color: Colors.green,
          icon: Icon(Icons.arrow_forward_ios_outlined),
          onPressed: () => onMoveForward(),
        ),
      ],
    );
  }
}
