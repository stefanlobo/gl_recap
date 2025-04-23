import 'package:flutter/material.dart';
import 'package:guillotine_recap/model/head_to_head.dart';
import 'package:guillotine_recap/model/superlative.dart';

class SuperlativesCard extends StatelessWidget {
  final List<Superlative> superlatives;
  final String title;
  final String subtitle;

  SuperlativesCard({
    Key? key,
    required this.superlatives,
    required this.title,
    required this.subtitle,
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
              child: Text(title),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: superlatives.length,
                itemBuilder: (context, index) {
                  final superlative = superlatives[index];
                  final scoreDifference = superlative.scoreDifference;

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
                              if (superlatives.length > 1)
                                Text(
                                  "TIE $subtitle",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                                  ),
                                ),
                              if (superlatives.length == 1)
                                Text(
                                  "$subtitle",
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
                                "Week ${superlative.week} - Week ${superlative.week + superlative.scores.length - 1}",
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
                          superlative.playerName ?? "Player",
                          superlative.scores,
                        ),
                        SizedBox(height: 12),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerScoreRow(BuildContext context, String playerName, List<double> scores) {
    // Format the scores as a list, e.g., "97.0 - 67.0"
    String formattedScores = scores.map((score) => score.toStringAsFixed(1)).join(' - ');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              playerName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            formattedScores,
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
