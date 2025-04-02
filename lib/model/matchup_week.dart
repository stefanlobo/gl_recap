import 'package:json_annotation/json_annotation.dart';

part 'matchup_week.g.dart';

@JsonSerializable()
class MatchupWeek {
  @JsonKey(name: 'starters')
  final List<String>? starters;

  @JsonKey(name: 'roster_id')
  final int rosterId;

  @JsonKey(name: 'players')
  final List<String>? players;

  // @JsonKey(name: 'matchup_id')
  // final int matchupId;

  @JsonKey(name: 'points')
  final double points;

  MatchupWeek(
      {required this.rosterId,
      required this.points,
      this.players,
      this.starters});

  /// Connect the generated [_$MatchupWeekFromJson] function to the `fromJson`
  /// factory.
  factory MatchupWeek.fromJson(Map<String, dynamic> json) => _$MatchupWeekFromJson(json);

  /// Connect the generated [_$MatchupWeekFromJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$MatchupWeekToJson(this);
}
