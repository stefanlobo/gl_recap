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
