import 'package:chess_app/util/UserSettings.dart';
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
            FutureBuilder(
              future: UserSettings.flipBoardEachTurn,
              builder: (context, AsyncSnapshot<bool> snapshot) {
                return CheckboxListTile(
                  title: Text('Flip Board After Each Move'),
                  value: snapshot.hasData ? snapshot.data! : false,
                  onChanged: (value) {
                    this.setState(() {
                      UserSettings.setFlipBoardEachTurn(value!);
                    });
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
