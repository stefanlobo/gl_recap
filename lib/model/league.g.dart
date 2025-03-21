// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'league.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

League _$LeagueFromJson(Map<String, dynamic> json) => League()
  ..total_rosters = (json['total_rosters'] as num?)?.toInt()
  ..status = json['status'] as String?
  ..sport = json['sport'] as String?
  ..season_type = json['season_type'] as String?
  ..season = json['season'] as String?
  ..rosterPositions = (json['roster_positions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList()
  ..previous_league_id = json['previous_league_id'] as String?
  ..name = json['name'] as String?
  ..league_id = json['league_id'] as String?
  ..draft_id = json['draft_id'] as String?
  ..avatar = json['avatar'] as String?;

Map<String, dynamic> _$LeagueToJson(League instance) => <String, dynamic>{
      'total_rosters': instance.total_rosters,
      'status': instance.status,
      'sport': instance.sport,
      'season_type': instance.season_type,
      'season': instance.season,
      'roster_positions': instance.rosterPositions,
      'previous_league_id': instance.previous_league_id,
      'name': instance.name,
      'league_id': instance.league_id,
      'draft_id': instance.draft_id,
      'avatar': instance.avatar,
    };
