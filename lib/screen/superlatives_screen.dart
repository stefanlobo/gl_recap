import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fpdart/fpdart.dart';
import 'package:guillotine_recap/model/head_to_head.dart';
import 'package:guillotine_recap/model/roster.dart';
import 'package:guillotine_recap/model/roster_league.dart';
import 'package:guillotine_recap/model/superlative.dart';
import 'package:guillotine_recap/provider/provider.dart';
import 'package:guillotine_recap/widgets/matchup_card.dart';
import 'package:guillotine_recap/widgets/superlatives_card.dart';

class SuperlativesScreen extends ConsumerStatefulWidget {
  const SuperlativesScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<SuperlativesScreen> {
  List<RosterLeague> statsRoster = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filteredRoster = ref.watch(filteredRosterLeaguesProvider);
    statsRoster = List.from(filteredRoster);

    // Get the screen width to help with sizing
    final screenWidth = MediaQuery.of(context).size.width;

    List<Superlative>? biggestDrop = calculateBiggestDrop(statsRoster);
    List<Superlative>? unluckyStreak = calculateUnluckyStreak(statsRoster);
    List<Superlative>? regularSeason = calculateMostWeeksAtOne(statsRoster); // most weeks at 1 "Regular Season MVP"
    List<Superlative>? bridesmaid = calculateMostWeeksAtTwo(statsRoster); // most weeks at 2 "Always the Bridesmaid"

    // most weeks in bottom 50% "Survivor"
    // most weeks in top 50% "Not Riskin It"

    // Players
    // players with most unique teams "journeyman"
    // players with highest total cost "Sam Bradford Award"

    final List<Widget> cards = [];

    if (biggestDrop != null && biggestDrop.isNotEmpty) {
      cards.add(SuperlativesCard(
        superlatives: biggestDrop,
        title: "Biggest Drop to Death",
        subtitle: "Largest Drop",
        diffTag: true,
      ));
    }

    if (unluckyStreak != null && unluckyStreak.isNotEmpty) {
      cards.add(SuperlativesCard(
        superlatives: unluckyStreak,
        title: "Unlucky Streak",
        subtitle: "Unlucky",
        diffTag: false,
      ));
    }

    if (regularSeason != null && regularSeason.isNotEmpty) {
      cards.add(SuperlativesCard(
        superlatives: regularSeason,
        title: "Regular Season MVP",
        subtitle: "Most 1st Placements",
        diffTag: false,
      ));
    }

    if (bridesmaid != null && bridesmaid.isNotEmpty) {
      cards.add(SuperlativesCard(
        superlatives: bridesmaid,
        title: "Always the Bridesmaid",
        subtitle: "Most 2nd Placements",
        diffTag: false,
      ));
    }

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: min(screenWidth * 0.95, 1500), // Constrain max width, use min to avoid overflows
          ),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: cards.length,
            itemBuilder: (context, index) => cards[index],
          ),
        ),
      ),
    );
  }

  // The furthest distance between the bottom two lowest
  List<Superlative>? calculateBiggestDrop(List<RosterLeague> allRosters) {
    List<Superlative> rostersDeathAndPrev = [];
    List<Superlative> biggestDrop = [];

    for (final roster in allRosters) {
      final deathPoints = roster.deathPoints;
      final deathWeek = roster.deathWeek;
      final playerName = roster.displayName ?? "Player";

      if (deathPoints == null || deathWeek == null || deathWeek <= 1) continue;

      // Calculate previous week index (0-based)
      var prevWeekIndex = deathWeek - 2; // If death week is 2, we want index 0

      // Ensure the index is valid
      if (prevWeekIndex < 0 || prevWeekIndex >= roster.truePoints.length) continue;

      var prevPoints = roster.truePoints[prevWeekIndex];

      Superlative player = Superlative.biggestDrop(
          playerName: playerName, week: deathWeek, beforeScore: prevPoints, afterScore: deathPoints);

      rostersDeathAndPrev.add(player);
    }

    if (rostersDeathAndPrev.isEmpty) return null;

    // Sort descending by scoreDifference
    rostersDeathAndPrev.sort((a, b) => b.scoreDifference.compareTo(a.scoreDifference));

    final topScoreDiff = rostersDeathAndPrev[0].scoreDifference;

    biggestDrop = rostersDeathAndPrev.where((r) => r.scoreDifference == topScoreDiff).toList();

    return biggestDrop;
  }

  // The furthest distance between the bottom two lowest
  List<Superlative>? calculateUnluckyStreak(List<RosterLeague> allRosters) {
    allRosters.sort((a, b) {
      final aDeathWeek = a.deathWeek ?? 9999; // handle the winner being null
      final bDeathWeek = b.deathWeek ?? 9999;
      return aDeathWeek.compareTo(bDeathWeek);
    });

    List<Superlative> result = [];

    for (int i = 0; i < allRosters.length; i++) {
      final current = allRosters[i];
      final currentPoints = current.deathPoints;
      final currentWeek = current.deathWeek;
      final currentName = current.displayName ?? "Player";

      if (currentPoints == null || currentWeek == null) continue;

      List<double> beatenScores = [];
      List<int> beatenWeeks = [];

      for (int j = i + 1; j < allRosters.length; j++) {
        final nextPoints = allRosters[j].deathPoints;
        final nextWeek = allRosters[j].deathWeek;
        if (nextPoints != null && nextWeek != null && nextPoints < currentPoints) {
          beatenScores.add(nextPoints);
          beatenWeeks.add(nextWeek);
        } else {
          break;
        }
      }

      if (beatenScores.isNotEmpty) {
        result.add(Superlative.unluckyStreak(
          playerName: currentName,
          deathWeek: currentWeek,
          deathScore: currentPoints,
          beatenWeeks: beatenWeeks,
          beatenScores: beatenScores,
        ));
      }
    }

    if (result.isNotEmpty) {
      // Sort descending by scoreDifference
      result.sort((a, b) => b.scores.length.compareTo(a.scores.length));

      final top = result[0].scores.length;

      result = result.where((r) => r.scores.length == top).toList();
    }

    return result.isEmpty ? null : result;
  }

  // Calculates the most weeks that someone was at the top
  List<Superlative>? calculateMostWeeksAtOne(List<RosterLeague> allRosters) {
    List<Superlative> mostAtOneList = [];
    int maxWeek = allRosters.first.truePoints.length;
    Map<int, List<List<double>>> highMap = {};

    for (int week = 0; week < maxWeek; week++) {
      var realWeek = week + 1;

      var highestPoints = 0.0;
      var highestRosterId = -1;

      for (final roster in allRosters) {
        var weekPoints = roster.truePoints[week];
        var currRosterID = roster.rosterId;
        if (highestPoints < weekPoints) {
          highestPoints = weekPoints; // the highest points for the week
          highestRosterId = currRosterID; // the assoiciated roster ID that got this score
        }
      }

      var weekAndPoints = [realWeek.toDouble(), highestPoints];

      if (highMap.containsKey(highestRosterId)) {
        highMap[highestRosterId]!.add(weekAndPoints);
      } else {
        highMap[highestRosterId] = [weekAndPoints];
      }
    }

    if (highMap.isEmpty) return [];

    // Convert map entries to a list
    var sortedEntries = highMap.entries.toList();

    // Sort by the length of the value list (descending)
    sortedEntries.sort((a, b) => b.value.length.compareTo(a.value.length));

    final top = sortedEntries.first.value.length;

    final result = sortedEntries.where((r) => r.value.length == top).toList();

    for (var high in result) {
      RosterLeague matchingRoster = allRosters.firstWhere(
        (r) => r.rosterId == high.key,
      );

      List<int> weeks = [];
      List<double> points = [];

      for (final combo in high.value) {
        weeks.add(combo[0].toInt());
        points.add(combo[1]);
      }

      final mostOneRoster = Superlative.mostWeeksAtPosition(
          playerName: matchingRoster.displayName, weeks: weeks, position: "first", relevantScores: points);

      mostAtOneList.add(mostOneRoster);
    }

    return mostAtOneList;
  }

  List<Superlative>? calculateMostWeeksAtTwo(List<RosterLeague> allRosters) {
    List<Superlative> mostAtTwoList = [];
    int maxWeek = allRosters.first.truePoints.length;
    Map<int, List<List<double>>> highMap = {};

    for (int week = 0; week < maxWeek; week++) {
      var realWeek = week + 1;

      double first = -1;
      double second = -1;
      int secondRosterId = -1;

      for (final roster in allRosters) {
        var weekPoints = roster.truePoints[week];
        var currRosterID = roster.rosterId;
        if (weekPoints > first) {
          second = first;
          secondRosterId = secondRosterId == -1 ? -1 : currRosterID; // Temporarily hold
          first = weekPoints;
        } else if (weekPoints > second) {
          second = weekPoints;
          secondRosterId = currRosterID;
        }
      }

      var weekAndPoints = [realWeek.toDouble(), second];

      if (highMap.containsKey(secondRosterId)) {
        highMap[secondRosterId]!.add(weekAndPoints);
      } else {
        highMap[secondRosterId] = [weekAndPoints];
      }
    }

    if (highMap.isEmpty) return [];

    // Convert map entries to a list
    var sortedEntries = highMap.entries.toList();

    // Sort by the length of the value list (descending)
    sortedEntries.sort((a, b) => b.value.length.compareTo(a.value.length));

    final top = sortedEntries.first.value.length;

    final result = sortedEntries.where((r) => r.value.length == top).toList();

    for (var high in result) {
      RosterLeague matchingRoster = allRosters.firstWhere(
        (r) => r.rosterId == high.key,
      );

      List<int> weeks = [];
      List<double> points = [];

      for (final combo in high.value) {
        weeks.add(combo[0].toInt());
        points.add(combo[1]);
      }

      final mostOneRoster = Superlative.mostWeeksAtPosition(
          playerName: matchingRoster.displayName, weeks: weeks, position: "second", relevantScores: points);

      mostAtTwoList.add(mostOneRoster);
    }

    return mostAtTwoList;
  }
}
