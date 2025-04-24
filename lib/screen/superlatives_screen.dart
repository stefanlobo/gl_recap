import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    // most weeks at 1 "Regular Season MVP"
    // most weeks at 2 "Always the Bridesmaid"
    // most weeks in bottom 50% "Survivor"
    // most weeks in top 50% "Not Riskin It"

    // Players
    // players with most unique teams "journeyman"
    // players with highest total cost "Sam Bradford Award"
    //

    print(biggestDrop);

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: min(screenWidth * 0.95, 2000), // Constrain max width, use min to avoid overflows
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 12,
            runSpacing: 12,
            children: [
              if (biggestDrop != null && biggestDrop.isNotEmpty)
                SuperlativesCard(
                  superlatives: biggestDrop,
                  title: "Biggest Drop to Death",
                  subtitle: "Largest Drop",
                  diffTag: true,
                ),
              SizedBox(
                height: 12,
              ),
              if (unluckyStreak != null && unluckyStreak.isNotEmpty)
                SuperlativesCard(
                  superlatives: unluckyStreak,
                  title: "Unlucky Streak",
                  subtitle: "Unlucky",
                  diffTag: false,
                ),
            ],
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

  List<Superlative>? calculateMostWeeksAtOne(List<RosterLeague> allRosters) {}
}
