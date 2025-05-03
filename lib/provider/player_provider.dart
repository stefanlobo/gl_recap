import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:guillotine_recap/model/player.dart';

Future<Map<String, Player>> loadPlayers() async {
  final jsonString = await rootBundle.loadString('assets/players.json');
  final Map<String, dynamic> raw = json.decode(jsonString);

  final Map<String, Player> players = {
    for (var entry in raw.entries) entry.key: Player.fromJson(entry.key, entry.value),
  };

  return players;
}
