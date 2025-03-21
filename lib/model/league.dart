import 'package:json_annotation/json_annotation.dart';

part 'league.g.dart';

@JsonSerializable()
class League {
  @JsonKey(name: 'total_rosters')
  int? total_rosters;

  @JsonKey(name: 'status')
  String? status;

  @JsonKey(name: "sport")
  String? sport;

  //@JsonKey(name: "settings")
  //String settings;

  @JsonKey(name: "season_type")
  String? season_type;

  @JsonKey(name: "season")
  String? season;

  //@JsonKey(name: "scoring_settings") // Leaving it blank for now. Might need later for calculations of scores
  //String scoring_settings;

  @JsonKey(name: "roster_positions")
  List<String>? rosterPositions;

  @JsonKey(name: "previous_league_id")
  String? previous_league_id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "league_id")
  String? league_id;

  @JsonKey(name: "draft_id")
  String? draft_id;

  @JsonKey(name: "avatar")
  String? avatar;

  League();

  /// Connect the generated [_$LeagueFromJson] function to the `fromJson`
  /// factory.
  factory League.fromJson(Map<String, dynamic> json) => _$LeagueFromJson(json);

  /// Connect the generated [_$LeagueToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LeagueToJson(this);
}
