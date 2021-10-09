import 'package:chess_app/screens/play_sceen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Material Chess'),
      ),
      body: Center(
        child: Column(
          children: [
            MaterialButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlayScreen()),
              ),
              color: Colors.green,
              child: Text('Play'),
            ),
          ],
        ),
      ),
    );
  }
}
