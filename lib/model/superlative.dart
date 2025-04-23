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

  double get scoreDifference => (scores[0] - scores[1]);
}
