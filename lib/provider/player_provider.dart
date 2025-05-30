import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:guillotine_recap/model/player.dart';

// Create a provider that loads data at startup
final playerDataInitProvider = Provider<Future<Map<String, Player>>>((ref) {
  // This will be created only once
  return PlayerDataService().loadPlayers();
});

// Then create a consumer provider that uses the init provider
final playersProvider = FutureProvider<Map<String, Player>>((ref) async {
  // This just returns the data that was already loaded
  return await ref.watch(playerDataInitProvider);
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
