import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:guillotine_recap/model/player.dart';

final playersProvider = FutureProvider<Map<String, Player>>((ref) async {
  return await PlayerDataService().loadPlayers();
});

class PlayerDataService {
  Future<Map<String, Player>> loadPlayers() async {
    final jsonString = await rootBundle.loadString('assets/players.json');
    final Map<String, dynamic> raw = json.decode(jsonString);

    final Map<String, Player> players = {
      for (var entry in raw.entries) entry.key: Player.fromJson(entry.key, entry.value),
    };

    return players;
  }
}