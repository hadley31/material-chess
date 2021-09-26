import 'package:flutter/material.dart';

class PlaySettings extends StatefulWidget {
  @override
  createState() => _PlaySettingsState();
}

class _PlaySettingsState extends State<PlaySettings> {
  bool flipBoard = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          children: [
            CheckboxListTile(
              title: Text('Flip Board'),
              value: flipBoard,
              onChanged: (value) => this.setState(() {
                flipBoard = value;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
