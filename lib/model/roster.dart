import 'package:guillotine_recap/model/roster_settings.dart';
import 'package:json_annotation/json_annotation.dart';

part 'roster.g.dart';

@JsonSerializable()
class Roster {
  @JsonKey(name: 'starters')
  final List<String>? starters;

  @JsonKey(name: 'settings')
  final RosterSettings? settings;

  @JsonKey(name: 'roster_id')
  final int? rosterId;

  @JsonKey(name: 'reserve')
  final List<String>? reserve;

  @JsonKey(name: 'players')
  final List<String>? players;

  @JsonKey(name: 'owner_id')
  final String? ownerId;

  @JsonKey(name: 'league_id')
  final String? leagueId;

  Roster(
    this.starters,
    this.settings,
    this.rosterId,
    this.reserve,
    this.players,
    this.ownerId,
    this.leagueId,
  );

  factory Roster.fromJson(Map<String, dynamic> json) => _$RosterFromJson(json);

  Map<String, dynamic> toJson() => _$RosterToJson(this);
}
