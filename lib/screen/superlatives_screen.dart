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
                SuperlativesCard(superlatives: biggestDrop, title: "Biggest Drop to Death", subtitle: "Largest Drop"),
              SizedBox(
                height: 12,
              ),
              if (unluckyStreak != null && unluckyStreak.isNotEmpty)
                SuperlativesCard(superlatives: unluckyStreak, title: "Unlucky Streak", subtitle: "Unlucky"),
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

      if (deathPoints != null && deathWeek != null && deathWeek > 1) {
        var prevWeek = deathWeek -
            1; // this is the index where the prev week is. for example, if you died week 2, the prev week index should be 0
        var prevWeekIndex = prevWeek - 1;
        var prevPoints = roster.truePoints[prevWeekIndex];
        List<double> scores = [];
        scores.add(prevPoints);
        scores.add(deathPoints!);

        Superlative player = Superlative(week: prevWeek, playerName: playerName, scores: scores);

        rostersDeathAndPrev.add(player);
      }
    }

    if (rostersDeathAndPrev.isNotEmpty) {
      // Sort descending by scoreDifference
      rostersDeathAndPrev.sort((a, b) => b.scoreDifference.compareTo(a.scoreDifference));

      final topScoreDiff = rostersDeathAndPrev[0].scoreDifference;

      biggestDrop = rostersDeathAndPrev.where((r) => r.scoreDifference == topScoreDiff).toList();
    }

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

      List<double> scores = [currentPoints];

      for (int j = i + 1; j < allRosters.length; j++) {
        final nextPoints = allRosters[j].deathPoints;
        if (nextPoints != null && nextPoints < currentPoints) {
          scores.add(nextPoints);
        } else {
          break;
        }
      }

      result.add(Superlative(
        week: currentWeek,
        playerName: currentName,
        scores: scores,
      ));
    }

    if (result.isNotEmpty) {
      // Sort descending by scoreDifference
      result.sort((a, b) => b.scores.length.compareTo(a.scores.length));

      final top = result[0].scores.length;

      result = result.where((r) => r.scores.length == top).toList();
    }

    return result;
  }
}
