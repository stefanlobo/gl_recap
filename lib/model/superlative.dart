// Model class to represent a matchup
class Superlative {
  int week;
  String? playerName;
  List<double> scores;

  Superlative({
    required this.week,
    this.playerName,
    required this.scores,
  });

  double get scoreDifference {
    if (scores.isEmpty) {
      return 0.0; // Return 0 if there are no scores
    } else if (scores.length == 1) {
      return scores[0]; // Return just the first score if only one exists
    } else {
      return scores[0] - scores[1]; // Return difference when both scores exist
    }
  }
}
