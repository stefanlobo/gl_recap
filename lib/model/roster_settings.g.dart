// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roster_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RosterSettings _$RosterSettingsFromJson(Map<String, dynamic> json) =>
    RosterSettings(
      wins: (json['wins'] as num).toInt(),
      waiverPosition: (json['waiver_position'] as num).toInt(),
      waiverBudgetUsed: (json['waiver_budget_used'] as num).toInt(),
      totalMoves: (json['total_moves'] as num).toInt(),
      ties: (json['ties'] as num).toInt(),
      losses: (json['losses'] as num).toInt(),
      fptsDecimal: (json['fpts_decimal'] as num).toInt(),
      fptsAgainstDecimal: (json['fpts_against_decimal'] as num).toInt(),
      fptsAgainst: (json['fpts_against'] as num).toInt(),
      fpts: (json['fpts'] as num).toInt(),
    );

Map<String, dynamic> _$RosterSettingsToJson(RosterSettings instance) =>
    <String, dynamic>{
      'wins': instance.wins,
      'waiver_position': instance.waiverPosition,
      'waiver_budget_used': instance.waiverBudgetUsed,
      'total_moves': instance.totalMoves,
      'ties': instance.ties,
      'losses': instance.losses,
      'fpts_decimal': instance.fptsDecimal,
      'fpts_against_decimal': instance.fptsAgainstDecimal,
      'fpts_against': instance.fptsAgainst,
      'fpts': instance.fpts,
    };
