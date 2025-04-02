// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roster.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Roster _$RosterFromJson(Map<String, dynamic> json) => Roster(
      starters: (json['starters'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      settings:
          RosterSettings.fromJson(json['settings'] as Map<String, dynamic>),
      rosterId: (json['roster_id'] as num).toInt(),
      reserve:
          (json['reserve'] as List<dynamic>?)?.map((e) => e as String).toList(),
      players:
          (json['players'] as List<dynamic>?)?.map((e) => e as String).toList(),
      ownerId: json['owner_id'] as String,
      leagueId: json['league_id'] as String,
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
