import 'package:flutter/material.dart';
import 'package:guillotine_recap/model/head_to_head.dart';

class MatchupCard extends StatelessWidget {
  final List<MatchupData> matchups;
  final String title;
  final String subtitle;
  final String description;

  MatchupCard({
    Key? key,
    required this.matchups,
    required this.title,
    required this.subtitle,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 500,
      ),
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Tooltip(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: Theme.of(context).colorScheme.primaryContainer),
                  textStyle: TextStyle(color: Colors.white),
                  preferBelow: false,
                  message: description,
                  child: Text(title)),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: matchups.length,
              itemBuilder: (context, index) {
                final matchup = matchups[index];
                final scoreDifference = (matchups[index].scoreDifference).abs();

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                              "#${index + 1} $subtitle",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
                              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
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
                        matchup.player2Name,
                        matchup.player2Score,
                        matchup.player2Score > matchup.player1Score,
                      ),
                      Divider(height: 1),
                      _buildPlayerScoreRow(
                        context,
                        matchup.player1Name,
                        matchup.player1Score,
                        matchup.player1Score > matchup.player2Score,
                      ),
                      SizedBox(height: 12),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerScoreRow(BuildContext context, String playerName, double score, bool isWinner) {
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
}
