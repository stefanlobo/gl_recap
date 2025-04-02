// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'matchup_week.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MatchupWeek _$MatchupWeekFromJson(Map<String, dynamic> json) => MatchupWeek(
      rosterId: (json['roster_id'] as num).toInt(),
      points: (json['points'] as num).toDouble(),
      players:
          (json['players'] as List<dynamic>?)?.map((e) => e as String).toList(),
      starters: (json['starters'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MatchupWeekToJson(MatchupWeek instance) =>
    <String, dynamic>{
      'starters': instance.starters,
      'roster_id': instance.rosterId,
      'players': instance.players,
      'points': instance.points,
    };
