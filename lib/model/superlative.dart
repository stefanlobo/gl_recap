// Base Superlative class with common properties
class Superlative {
  String title;           // Title of the superlative (e.g., "Biggest Drop")
  String? subtitle;       // Optional subtitle or description
  String? playerName;     // Player who achieved this superlative
  List<int> weeks;        // List of weeks relevant to this superlative 
  List<double> scores;    // Relevant scores for the superlative
  
  Superlative({
    required this.title,
    this.subtitle,
    this.playerName,
    required this.weeks,
    required this.scores,
  });
  
  // Basic score difference calculation
  double get scoreDifference {
    if (scores.isEmpty) {
      return 0.0;
    } else if (scores.length == 1) {
      return scores[0];
    } else {
      return scores[0] - scores[1]; 
    }
  }
  
  // For display in UI - the weeks covered by this superlative
  String get weeksDisplay {
    if (weeks.isEmpty) return "N/A";
    if (weeks.length == 1) return "Week ${weeks[0]}";
    return "Week ${weeks.first} - Week ${weeks.last}";
  }
  
  // Factory constructor for creating specific types of superlatives
  static Superlative biggestDrop({
    required String playerName, 
    required int week, 
    required double beforeScore, 
    required double afterScore
  }) {
    return Superlative(
      title: "Biggest Drop",
      subtitle: "Largest score decrease between consecutive weeks",
      playerName: playerName,
      weeks: [week-1, week],
      scores: [beforeScore, afterScore],
    );
  }
  
  static Superlative unluckyStreak({
    required String playerName,
    required int deathWeek,
    required double deathScore,
    required List<int> beatenWeeks,
    required List<double> beatenScores,
  }) {
    List<int> allWeeks = [deathWeek, ...beatenWeeks];
    List<double> allScores = [deathScore, ...beatenScores];
    
    return Superlative(
      title: "Unlucky Streak",
      subtitle: "Score that would have won in subsequent weeks",
      playerName: playerName,
      weeks: allWeeks,
      scores: allScores,
    );
  }
  
  static Superlative mostWeeksAtPosition({
    required String playerName,
    required List<int> weeks,
    required String position,
    required List<double> relevantScores,
  }) {
    return Superlative(
      title: "Most Weeks at $position",
      subtitle: "Consistency at the $position position",
      playerName: playerName,
      weeks: weeks,
      scores: relevantScores,
    );
  }
}
