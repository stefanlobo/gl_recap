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

  /// Get a valid avatar URL or return null if none exists
  String? getAvatarUrl() {
    // Check if avatar is null or empty
    if (avatar == null || avatar!.isEmpty) {
      return null;
    }

    // If the URL is already absolute, return it
    if (avatar!.startsWith('http')) {
      return avatar;
    }

    return 'https://sleepercdn.com/avatars/thumbs/$avatar';
  }

  /// Get default avatar if none exists
  String getAvatarUrlWithDefault() {
    return getAvatarUrl() ?? 'https://sleepercdn.com/images/v2/icons/league/nfl/red.png';
  }

  /// Connect the generated [_$LeagueFromJson] function to the `fromJson`
  /// factory.
  factory League.fromJson(Map<String, dynamic> json) => _$LeagueFromJson(json);

  /// Connect the generated [_$LeagueToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$LeagueToJson(this);
}
