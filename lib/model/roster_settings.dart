import 'package:json_annotation/json_annotation.dart';

part 'roster_settings.g.dart';

@JsonSerializable()
class RosterSettings {
  @JsonKey(name: 'wins')
  final int wins; 

  @JsonKey(name: 'waiver_position')
  final int waiverPosition; 

  @JsonKey(name: 'waiver_budget_used')
  final int waiverBudgetUsed; 

  @JsonKey(name: 'total_moves')
  final int totalMoves; 

  @JsonKey(name: 'ties')
  final int ties; 

  @JsonKey(name: 'losses')
  final int losses;

  @JsonKey(name: 'fpts_decimal')
  final int fptsDecimal; 

  @JsonKey(name: 'fpts_against_decimal')
  final int fptsAgainstDecimal; 

  @JsonKey(name: 'fpts_against')
  final int fptsAgainst; 

  @JsonKey(name: 'fpts')
  final int fpts; 

  RosterSettings({
    required this.wins,
    required this.waiverPosition,
    required this.waiverBudgetUsed,
    required this.totalMoves,
    required this.ties,
    required this.losses,
    required this.fptsDecimal,
    required this.fptsAgainstDecimal,
    required this.fptsAgainst,
    required this.fpts,
  });

  factory RosterSettings.fromJson(Map<String, dynamic> json) => _$RosterSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$RosterSettingsToJson(this);
}
