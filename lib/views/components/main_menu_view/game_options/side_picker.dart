import 'package:flutter/cupertino.dart';

import 'picker.dart';

enum Player { player1, random, player2 }

class SidePicker extends StatelessWidget {
  final Map<Player, Text> colorOptions = const <Player, Text>{
    Player.player1: Text('White'),
    Player.random: Text('Random'),
    Player.player2: Text('Black'),
  };

  final Player playerSide;
  final Function(Player?) setFunc;
  
  SidePicker(this.playerSide, this.setFunc);

  @override
  Widget build(BuildContext context) {
    return Picker<Player>(
      label: 'Side',
      options: colorOptions,
      selection: playerSide,
      setFunc: setFunc,
    );
  }
}
