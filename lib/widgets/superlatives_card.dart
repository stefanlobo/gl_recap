import 'package:flutter/material.dart';
import 'package:guillotine_recap/model/head_to_head.dart';
import 'package:guillotine_recap/model/superlative.dart';

class SuperlativesCard extends StatelessWidget {
  final List<Superlative> superlatives;
  final String title;
  final String subtitle;
  final bool diffTag;

  SuperlativesCard({
    Key? key,
    required this.superlatives,
    required this.title,
    required this.subtitle,
    required this.diffTag,
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
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          child: Row(
                            children: [
                              Text(
                                _getWeekRangeText(superlative),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Spacer(),
                              if (diffTag)
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

  // Helper method to get a formatted week range
  String _getWeekRangeText(Superlative superlative) {
    if (superlative.weeks.isEmpty) {
      return "No Weeks";
    } else if (superlative.weeks.length == 1) {
      return "Week ${superlative.weeks[0]}";
    } else {
      // Sort the weeks to make sure they are in ascending order
      List<int> sortedWeeks = List.from(superlative.weeks)..sort();

      bool areConsecutive = true;
      for (int i = 0; i < sortedWeeks.length - 1; i++) {
        if (sortedWeeks[i + 1] - sortedWeeks[i] != 1) {
          areConsecutive = false;
          break;
        }
      }
      if (areConsecutive) {
        return "Week ${sortedWeeks.first} - Week ${sortedWeeks.last}";
      } else {
        return "Weeks ${sortedWeeks.join(', ')}";
      }
    }
  }

  Widget _buildPlayerScoreRow(BuildContext context, String playerName, List<double> scores) {
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
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).textTheme.bodyLarge?.color, // Default text color
              ),
              children: _buildScoreTextSpans(scores),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildScoreTextSpans(List<double> scores) {
    List<TextSpan> spans = [];

    for (int i = 0; i < scores.length; i++) {
      // Add the score with appropriate color
      spans.add(
        TextSpan(
          text: scores[i].toStringAsFixed(2),
          style: TextStyle(
            color: i == 0 ? Colors.green : Colors.red,
          ),
        ),
      );

      // Add separator except after the last item
      if (i < scores.length - 1) {
        spans.add(
          TextSpan(
            text: ' - ',
          ),
        );
      }
    }

    return spans;
  }
}
