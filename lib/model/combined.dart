import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:guillotine_recap/model/matchup_week.dart';
import 'package:guillotine_recap/model/roster.dart';
import 'package:guillotine_recap/model/roster_league.dart';
import 'package:guillotine_recap/model/user.dart';

@immutable
class Combined {
  //rosterid : league member info
  final Map<int, RosterLeague> _rosterMap;

  Combined._(this._rosterMap);

  factory Combined({
    required List<Roster> rosters,
    required List<User> users,
    required Map<int, Map<int, MatchupWeek>> weeklyData,
  }) {
    final combined = Combined._createBase(
        rosters: rosters, users: users, weeklyData: weeklyData);
    return GuillotineCalculator.applyGuillotineLogic(combined);
  }

  // Public factory constructor
  static Map<int, RosterLeague> _createBase({
    required List<Roster> rosters,
    required List<User> users,
    required Map<int, Map<int, MatchupWeek>> weeklyData,
  }) {
    final userMap = {for (var user in users) user.userId: user};
    final rosterMap = <int, RosterLeague>{};

    for (final roster in rosters) {
      final user = userMap[roster.ownerId];
      final rosterID = roster.rosterId;

      if (user != null) {
        final weeksMap = <int, MatchupWeek>{};

        for (final weekEntry in weeklyData.entries) {
          final matchup = weekEntry.value[rosterID];
          if (matchup != null) {
            weeksMap[weekEntry.key] = matchup;
          }
        }

        final rosterWeek = RosterLeague(
          userId: user.userId,
          displayName: user.displayName,
          rosterId: roster.rosterId,
          avatar: user.avatar,
          weeks: weeksMap,
        );

        rosterMap[rosterWeek.rosterId] = rosterWeek;
      }
    }

    return rosterMap;
  }

  // Getter for immutable access
  Map<int, RosterLeague> get rosterMap => UnmodifiableMapView(_rosterMap);

  List<RosterLeague> get rosters => _rosterMap.values.toList();
  List<int> get rosterIds => _rosterMap.keys.toList();

  RosterLeague? getRoster(int rosterId) => _rosterMap[rosterId];

  void _calculateGuilotineInfo() {
    // Find all weeks
    final firstRosterWeeks = _rosterMap.values.first.weeks.keys;
    final allWeeks = firstRosterWeeks.toSet();
    final sortedWeeks = allWeeks.isNotEmpty
        ? (allWeeks.toList()..sort()) // Fixed: Use cascade operator
        : <int>[1];

    // Set of rosterIDs (added if they have the lowest score of the week. once added they are out and can't be added again)
    final deadRosters = <int>{};

    // maps rosterID to death week
    final rosterDeathWeeks = <int, int>{};

    for (final week in allWeeks) {
      double lowestScore = double.infinity;
      int lowestScoreRosterId = -1;
      for (final roster in _rosterMap.values) {
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

    for (final roster in _rosterMap.values) {
      final truePoints = <double>[];

      final deathWeek = (deadRosters.contains(roster.rosterId))
          ? rosterDeathWeeks[roster.rosterId]
          : 100;
      final deadFlag = (deadRosters.contains(roster.rosterId)) ? true : false;

      for (final week in sortedWeeks) {
        final weekScore = roster.weeks[week]!.points;
        if (deadFlag == false || week <= deathWeek!) {
          truePoints.add(weekScore);
        } else {
          truePoints.add(0.0);
        }
      }

      roster.truePoints = truePoints;

      roster.deathPoints =
          deathWeek != null ? roster.weeks[deathWeek]?.points : null;

      roster.deathPlayers = deathWeek != null
          ? roster.weeks[deathWeek]?.players
          : roster.weeks[sortedWeeks.last]?.players;

      roster.deathStarters = deathWeek != null
          ? roster.weeks[deathWeek]?.starters
          : roster.weeks[sortedWeeks.last]?.starters;
    }
  }
}

class GuillotineCalculator {
  static Combined applyGuillotineLogic(Map<int, RosterLeague> rosterMap) {
    if (rosterMap.isEmpty) return Combined._(rosterMap);

    // Find all weeks
    final firstRosterWeeks = rosterMap.values.first.weeks.keys;
    final allWeeks = firstRosterWeeks.toSet();
    final sortedWeeks = allWeeks.isNotEmpty
        ? (allWeeks.toList()..sort()) // Fixed: Use cascade operator
        : <int>[1];

    // Set of rosterIDs (added if they have the lowest score of the week. once added they are out and can't be added again)
    final deadRosters = <int>{};

    // maps rosterID to death week
    final rosterDeathWeeks = <int, int>{};

    for (final week in allWeeks) {
      double lowestScore = double.infinity;
      int lowestScoreRosterId = -1;
      for (final roster in rosterMap.values) {
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

    // for (final roster in rosterMap.values) {
    //   final truePoints = <double>[];

    //   final deathWeek = (deadRosters.contains(roster.rosterId))
    //       ? rosterDeathWeeks[roster.rosterId]
    //       : 100;
    //   final deadFlag = (deadRosters.contains(roster.rosterId)) ? true : false;

    //   for (final week in sortedWeeks) {
    //     final weekScore = roster.weeks[week]!.points;
    //     if (deadFlag == false || week <= deathWeek!) {
    //       truePoints.add(weekScore);
    //     } else {
    //       truePoints.add(0.0);
    //     }
    //   }

    //   final deathPoints =
    //       deathWeek != null ? roster.weeks[deathWeek]?.points : null;

    //   final deathPlayers = deathWeek != null
    //       ? roster.weeks[deathWeek]?.players
    //       : roster.weeks[sortedWeeks.last]?.players;

    //   final deathStarters = deathWeek != null
    //       ? roster.weeks[deathWeek]?.starters
    //       : roster.weeks[sortedWeeks.last]?.starters;

    //   // roster.copyWith(
    //   //     truePoints: truePoints,
    //   //     deathPoints: deathPoints,
    //   //     deathPlayers: deathPlayers,
    //   //     deathStarters: deathStarters);
    // }

    // Create a new updated map
    final updatedRosterMap = {
      for (final roster in rosterMap.values)
        roster.rosterId:
            _updateRoster(roster, sortedWeeks, rosterDeathWeeks, deadRosters)
    };

    return Combined._(updatedRosterMap);
  }

  static Combined filterRosterMember(
      Map<int, RosterLeague> rosterMap, int rosterId) {
    for (final roster in rosterMap.values) {
      if (roster.rosterId == rosterId) {
        rosterMap.remove(roster.rosterId);
      }
    }

    return Combined._(rosterMap);
  }

  static RosterLeague _updateRoster(RosterLeague roster, List<int> sortedWeeks,
      Map<int, int> rosterDeathWeeks, Set<int> deadRosters) {
    final truePoints = <double>[];

    final deathWeek = deadRosters.contains(roster.rosterId)
        ? rosterDeathWeeks[roster.rosterId]
        : 100;

    final isDead = deadRosters.contains(roster.rosterId);

    for (final week in sortedWeeks) {
      final weekScore = roster.weeks[week]?.points ?? 0.0;
      truePoints.add((!isDead || week <= deathWeek!) ? weekScore : 0.0);
    }

    final deathPoints =
        deathWeek != null ? roster.weeks[deathWeek]?.points : null;

    final deathPlayers = deathWeek != null
        ? roster.weeks[deathWeek]?.players
        : roster.weeks[sortedWeeks.last]?.players;

    final deathStarters = deathWeek != null
        ? roster.weeks[deathWeek]?.starters
        : roster.weeks[sortedWeeks.last]?.starters;

    return roster.copyWith(
      truePoints: truePoints,
      deathPoints: deathPoints,
      deathPlayers: deathPlayers,
      deathStarters: deathStarters,
    );
  }
}
