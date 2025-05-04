class Player {
  final String playerId;
  final String fullName;
  final String position;
  int count; 

  Player({
    required this.playerId,
    required this.fullName,
    required this.position,
    this.count = 0,
  });

  String get avatarUrl {
    if (playerId == null) {
      return 'https://sleepercdn.com/images/v2/icons/player_default.webp';
    } else {
      return 'https://sleepercdn.com/content/nfl/players/thumb/$playerId.jpg';
    }
  }

  factory Player.fromJson(String playerId, Map<String, dynamic> json) {
    return Player(
      playerId: playerId,
      fullName: json['full_name'] ?? 'Unknown',
      position: json['position'] ?? 'N/A',
    );
  }

  static Player mostPickup(
      {required String playerId, required String fullName, required String position, required int count}) {
    return Player(
      playerId: playerId,
      fullName: fullName,
      position: position,
      count: count
    );
  }
}
