// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roster.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Roster _$RosterFromJson(Map<String, dynamic> json) => Roster(
      (json['starters'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['settings'] == null
          ? null
          : RosterSettings.fromJson(json['settings'] as Map<String, dynamic>),
      (json['roster_id'] as num?)?.toInt(),
      (json['reserve'] as List<dynamic>?)?.map((e) => e as String).toList(),
      (json['players'] as List<dynamic>?)?.map((e) => e as String).toList(),
      json['owner_id'] as String?,
      json['league_id'] as String?,
    );

Map<String, dynamic> _$RosterToJson(Roster instance) => <String, dynamic>{
      'starters': instance.starters,
      'settings': instance.settings,
      'roster_id': instance.rosterId,
      'reserve': instance.reserve,
      'players': instance.players,
      'owner_id': instance.ownerId,
      'league_id': instance.leagueId,
    };
