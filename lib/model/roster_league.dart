import 'package:guillotine_recap/model/matchup_week.dart';

class RosterLeague {
  final String userId;
  final String displayName;
  final String avatar;
  final int rosterId;
  List<double>? truePoints;

  // Death Data
  List<String>? deathStarters;
  List<String>? deathPlayers;
  double? deathPoints;

  // Weeks data
  // week # : Matchup Info (points, players, etc)
  final Map<int, MatchupWeek> weeks;

  int get weeksLength => weeks.length;

  RosterLeague({
    required this.userId,
    required this.displayName,
    required this.rosterId,
    this.avatar = '',
    this.deathStarters,
    this.deathPlayers,
    this.deathPoints = 0,
    this.weeks = const {},// Initialize with an empty map
    this.truePoints = const [] 
  });

  RosterLeague copyWith({
    String? userId,
    String? displayName,
    String? avatar,
    int? rosterId,
    List<String>? deathStarters,
    List<String>? deathPlayers,
    double? deathPoints,
    Map<int, MatchupWeek>? weeks,
  }) {
    return RosterLeague(
      userId: userId ?? this.userId,
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
