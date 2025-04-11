import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:guillotine_recap/model/roster_league.dart';
import 'package:guillotine_recap/provider/provider.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  List<RosterLeague> statsRoster = [];
  List<MatchupData> closestMatchups = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filteredRoster = ref.watch(filteredRosterLeaguesProvider);
    statsRoster = List.from(filteredRoster);
    closestMatchups = calculateClosestMatchups(statsRoster);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text("Top 5 Closest Lowest Two Scores"),
        ),
        Expanded(
            child: ListView.builder(
          itemCount: closestMatchups.length,
          itemBuilder: (context, index) {
            final matchup = closestMatchups[index];
            final scoreDifference =
                (closestMatchups[index].scoreDifference).abs();

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 6.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "#${index + 1} Closest Matchup",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                        SizedBox(width: 6),
                        if (index == 0)
                          Icon(
                            Icons.emoji_events,
                            color: Colors.amber,
                            size: 18,
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          "Week ${matchup.week}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "Diff: ${scoreDifference.toStringAsFixed(1)} pts",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildPlayerScoreRow(
                    context,
                    matchup.player1Name,
                    matchup.player1Score,
                    matchup.player1Score > matchup.player2Score,
                  ),
                  Divider(height: 1),
                  _buildPlayerScoreRow(
                    context,
                    matchup.player2Name,
                    matchup.player2Score,
                    matchup.player2Score > matchup.player1Score,
                  ),
                  SizedBox(height: 12),
                ],
              ),
            );
          },
        ))
      ],
    );
  }

  Widget _buildPlayerScoreRow(
      BuildContext context, String playerName, double score, bool isWinner) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        children: [
          if (isWinner)
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 16,
            ),
          if (isWinner) SizedBox(width: 8),
          Expanded(
            child: Text(
              playerName,
              style: TextStyle(
                fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            score.toStringAsFixed(1),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // go through each week and find the two smallest. after adding all to list, sort and return the top 5
  List<MatchupData> calculateClosestMatchups(List<RosterLeague> allRosters) {
    List<MatchupData> weekToWeekBottomTwo = [];

    final totalWeeksLength = allRosters.first.truePoints.length;
    final totalWeeksList =
        List.generate(totalWeeksLength, (generator) => generator);

    for (final week in totalWeeksList) {
      var lowest = double.infinity;
      var second_lowest = double.infinity;
      var player1 = '';
      var player2 = '';

      allRosters
          .sort((a, b) => a.truePoints[week].compareTo(b.truePoints[week]));

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

    weekToWeekBottomTwo
        .sort((a, b) => a.scoreDifference.compareTo(b.scoreDifference));
    List<MatchupData> topFive = weekToWeekBottomTwo.take(5).toList();

    return topFive;
  }
}

// Model class to represent a matchup
class MatchupData {
  final int week;
  final String player1Name;
  final double player1Score;
  final String player2Name;
  final double player2Score;

  MatchupData({
    required this.week,
    required this.player1Name,
    required this.player1Score,
    required this.player2Name,
    required this.player2Score,
  });

  // Helper method to calculate score difference
  double get scoreDifference => (player1Score - player2Score).abs();
}
