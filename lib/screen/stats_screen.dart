import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guillotine_recap/app/convert.dart';
import 'package:guillotine_recap/model/head_to_head.dart';
import 'package:guillotine_recap/model/roster_league.dart';
import 'package:guillotine_recap/provider/provider.dart';
import 'package:guillotine_recap/widgets/matchup_card.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
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
    final contentWidth = getContentWidth(context);

    final closestMatchups = calculateClosestMatchups(statsRoster);
    final furthestBottomTwo = calculateFurthestBottomTwo(statsRoster);
    final largestTopBottom = calculateAbsoulteDemolition(statsRoster);

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: contentWidth, // Constrain max width, use min to avoid overflows
          ),
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 12,
            runSpacing: 12,
            children: [
              MatchupCard(matchups: closestMatchups, title: "Tight Race", subtitle: "Ouch Matchup"),
              MatchupCard(matchups: furthestBottomTwo, title: "Not Even Close", subtitle: "Furthest Matchup"),
              MatchupCard(matchups: largestTopBottom, title: "David vs Goliath", subtitle: "Demolished"),
              // MatchupCard(matchups: closestMatchups, title: "Closest Bottom Two", subtitle: "Closest Matchup"),
              // MatchupCard(matchups: closestMatchups, title: "Closest Bottom Two", subtitle: "Closest Matchup"),
              // MatchupCard(matchups: closestMatchups, title: "Closest Bottom Two", subtitle: "Closest Matchup"),
              // MatchupCard(matchups: closestMatchups, title: "Closest Bottom Two", subtitle: "Closest Matchup"),
              // MatchupCard(matchups: closestMatchups, title: "Closest Bottom Two", subtitle: "Closest Matchup"),
              // MatchupCard(matchups: closestMatchups, title: "Closest Bottom Two", subtitle: "Closest Matchup"),
              // MatchupCard(matchups: closestMatchups, title: "Closest Bottom Two", subtitle: "Closest Matchup"),
            ],
          ),
        ),
      ),
    );
  }

  // go through each week and find the two smallest. after adding all to list, sort and return the top 5
  List<MatchupData> calculateClosestMatchups(List<RosterLeague> allRosters) {
    List<MatchupData> weekToWeekBottomTwo = [];

    final totalWeeksLength = allRosters.first.truePoints.length;
    final totalWeeksList = List.generate(totalWeeksLength, (generator) => generator);

    for (final week in totalWeeksList) {
      var lowest = double.infinity;
      var second_lowest = double.infinity;
      var player1 = '';
      var player2 = '';

      allRosters.sort((a, b) => a.truePoints[week].compareTo(b.truePoints[week]));

      for (final roster in allRosters) {
        final weekPoint = roster.truePoints[week];
        final playerName = roster.displayName;

        if (weekPoint == 0.0) continue;

        if (lowest == double.infinity) {
          lowest = weekPoint;
          player1 = playerName;
        } else {
          if (second_lowest == double.infinity) {
            second_lowest = weekPoint;
            player2 = playerName;
            break;
          }
        }
      }

      if (lowest != double.infinity && second_lowest != double.infinity) {
        MatchupData weekData = MatchupData(
            week: week + 1,
            player1Name: player1,
            player1Score: lowest,
            player2Name: player2,
            player2Score: second_lowest);
        weekToWeekBottomTwo.add(weekData);
      }
    }

    weekToWeekBottomTwo.sort((a, b) => a.scoreDifference.compareTo(b.scoreDifference));
    List<MatchupData> topFive = weekToWeekBottomTwo.take(5).toList();

    return topFive;
  }

  // The furthest distance between the bottom two lowest
  List<MatchupData> calculateFurthestBottomTwo(List<RosterLeague> allRosters) {
    List<MatchupData> weekToWeekBottomTwo = [];

    final totalWeeksLength = allRosters.first.truePoints.length;
    final totalWeeksList = List.generate(totalWeeksLength, (generator) => generator);

    for (final week in totalWeeksList) {
      var lowest = double.infinity;
      var second_lowest = double.infinity;
      var player1 = '';
      var player2 = '';

      allRosters.sort((a, b) => a.truePoints[week].compareTo(b.truePoints[week]));

      for (final roster in allRosters) {
        final weekPoint = roster.truePoints[week];
        final playerName = roster.displayName;

        if (weekPoint == 0.0) continue;

        if (lowest == double.infinity) {
          lowest = weekPoint;
          player1 = playerName;
        } else {
          if (second_lowest == double.infinity) {
            second_lowest = weekPoint;
            player2 = playerName;
            break;
          }
        }
      }

      if (lowest != double.infinity && second_lowest != double.infinity) {
        MatchupData weekData = MatchupData(
            week: week + 1,
            player1Name: player1,
            player1Score: lowest,
            player2Name: player2,
            player2Score: second_lowest);
        weekToWeekBottomTwo.add(weekData);
      }
    }

    weekToWeekBottomTwo.sort((a, b) => b.scoreDifference.compareTo(a.scoreDifference));
    List<MatchupData> topFive = weekToWeekBottomTwo.take(5).toList();

    return topFive;
  }

  // The furthest distance between top scorer and lowest scorer
  List<MatchupData> calculateAbsoulteDemolition(List<RosterLeague> allRosters) {
    List<MatchupData> weekToWeekBottomTwo = [];

    final totalWeeksLength = allRosters.first.truePoints.length;
    final totalWeeksList = List.generate(totalWeeksLength, (generator) => generator);

    for (final week in totalWeeksList) {
      var lowest = double.infinity;
      var highest = 0.0;
      var player1 = '';
      var player2 = '';

      //allRosters.sort((a, b) => a.truePoints[week].compareTo(b.truePoints[week]));

      for (final roster in allRosters) {
        final weekPoint = roster.truePoints[week];
        final playerName = roster.displayName;

        if (weekPoint == 0.0) continue;

        if (lowest > weekPoint) {
          lowest = weekPoint;
          player1 = playerName;
        } else if (highest < weekPoint) {
          highest = weekPoint;
          player2 = playerName;
        }
      }

      if (lowest != double.infinity && highest != 0.0) {
        MatchupData weekData = MatchupData(
            week: week + 1, player1Name: player1, player1Score: lowest, player2Name: player2, player2Score: highest);
        weekToWeekBottomTwo.add(weekData);
      }
    }

    weekToWeekBottomTwo.sort((a, b) => b.scoreDifference.compareTo(a.scoreDifference));
    List<MatchupData> topFive = weekToWeekBottomTwo.take(5).toList();

    return topFive;
  }
}
