import 'package:guillotine_recap/model/matchup_week.dart';

class RosterLeague {
  final String userId;
  final String displayName;
  final int rosterId;
  final String avatar;

  // Glitch in SleeperAPI needing me to have to implement this
  late final List<double> truePoints;

  // Death Data
  late final List<String>? deathStarters;
  late final List<String>? deathPlayers;
  late final double? deathPoints;

  // Weeks data
  // week # : Matchup Info (points, players, etc)
  final Map<int, MatchupWeek> weeks;

  int get weeksLength => weeks.length;

  int get deathWeek {
    int index = truePoints.indexWhere((value) => value == 0.0);
    return index != -1 ? index : truePoints.length - 1; //Returns the death week
  }

  RosterLeague({
    required this.userId,
    required this.displayName,
    required this.rosterId,
    this.avatar = '',
    required this.weeks,
  });

}

class RosterLeagueCalculator {
  static void calculateAllRosterStats(List<RosterLeague> allRosterLeagues) {
    // Find all weeks
    final firstRosterWeeks = allRosterLeagues.first.weeks.keys;
    final allWeeks = firstRosterWeeks.toSet();

    final sortedWeeks = allWeeks.toList()..sort();

    // Set of rosterIDs (added if they have the lowest score of the week. once added they are out and can't be added again)
    final deadRosters = <int>{};

    // maps rosterID to their last week aka death week
    final rosterDeathWeeks = <int, int>{};

    for (final week in allWeeks) {
      double lowestScore = double.infinity;
      int lowestScoreRosterId = -1;
      for (final roster in allRosterLeagues) {
        final weekData = roster.weeks[week];
        final currentRosterId = roster.rosterId;

        if (weekData != null) {
          if (weekData.points < lowestScore &&
              !deadRosters.contains(currentRosterId)) {
            lowestScore = weekData.points;
            lowestScoreRosterId = currentRosterId;
          }
        }
      }

      if (lowestScoreRosterId != -1) {
        deadRosters.add(lowestScoreRosterId);
        rosterDeathWeeks[lowestScoreRosterId] = week;
      }
    }

    for (final roster in allRosterLeagues) {
      roster.truePoints = [];

      // check if dead
      final isDead = deadRosters.contains(roster.rosterId);

      final deathWeek = deadRosters.contains(roster.rosterId)
          ? rosterDeathWeeks[roster.rosterId]
          : 100;

      for (final week in allWeeks) {
        final weekScore = roster.weeks[week]?.points ?? 0.0;
        roster.truePoints
            .add((!isDead || week <= deathWeek!) ? weekScore : 0.0);
      }

      roster.deathPlayers = deathWeek != null
          ? roster.weeks[deathWeek]?.players
          : roster.weeks[sortedWeeks.last]?.players;

      roster.deathPoints = deathWeek != null
          ? roster.weeks[deathWeek]?.points
          : roster.weeks[sortedWeeks.last]?.points;

      roster.deathStarters = deathWeek != null
          ? roster.weeks[deathWeek]?.starters
          : roster.weeks[sortedWeeks.last]?.starters;
    }
  }
}
