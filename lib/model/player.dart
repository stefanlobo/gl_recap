class Player {
  final String playerId;
  final String fullName;
  final String position;

  Player({
    required this.playerId,
    required this.fullName,
    required this.position,
  });

  factory Player.fromJson(String playerId, Map<String, dynamic> json) {
    return Player(
      playerId: playerId,
      fullName: json['full_name'] ?? 'Unknown',
      position: json['position'] ?? 'N/A',
    );
  }
}
