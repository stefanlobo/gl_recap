class Combined {
  final String userId; 
  final String username;
  final String displayName;
  final String avatar; 
  final int rosterId;

  // Death Data
  final List<String>? deathStarters;
  final List<String>? deathPlayers;
  final int deathPoints;

  // Weeks data
  final Map<String, Map> weeks;

  Combined({
    required this.userId,
    required this.username,
    required this.displayName,
    required this.rosterId,
    this.avatar = '', 
    this.deathStarters,
    this.deathPlayers,
    this.deathPoints = 0, 
    this.weeks = const {}, // Initialize with an empty map
  });

  Combined copyWith({
      String? userId, 
     String? username,
     String? displayName,
     String? avatar, 
     int? rosterId,
     List<String>? deathStarters,
     List<String>? deathPlayers,
     int? deathPoints,
     Map<String,Map>? weeks,
  }) {
    return Combined(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatar: avatar ?? this.avatar,
      rosterId: rosterId ?? this.rosterId,
      deathStarters: deathStarters ?? this.deathStarters,
      deathPlayers: deathPlayers ?? this.deathPlayers,
      deathPoints: deathPoints ?? this.deathPoints,
      weeks: weeks ?? this.weeks,
    );
  }
}