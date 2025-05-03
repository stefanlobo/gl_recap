// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      type: json['type'] as String?,
      transaction_id: json['transaction_id'] as String?,
      status_updated: (json['status_updated'] as num?)?.toInt(),
      status: json['status'] as String?,
      settings: json['settings'] == null
          ? null
          : TransactionSettings.fromJson(
              json['settings'] as Map<String, dynamic>),
      roster_ids: (json['roster_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      metadata: json['metadata'],
      leg: (json['leg'] as num?)?.toInt(),
      drops: (json['drops'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      creator: json['creator'] as String?,
      created: (json['created'] as num?)?.toInt(),
      consenter_ids: (json['consenter_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      adds: (json['adds'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
      waiver_budget: (json['waiver_budget'] as List<dynamic>?)
          ?.map((e) => WaiverBudget.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'type': instance.type,
      'transaction_id': instance.transaction_id,
      'status_updated': instance.status_updated,
      'status': instance.status,
      'settings': instance.settings,
      'roster_ids': instance.roster_ids,
      'metadata': instance.metadata,
      'leg': instance.leg,
      'drops': instance.drops,
      'creator': instance.creator,
      'created': instance.created,
      'consenter_ids': instance.consenter_ids,
      'adds': instance.adds,
      'waiver_budget': instance.waiver_budget,
    };

TransactionSettings _$TransactionSettingsFromJson(Map<String, dynamic> json) =>
    TransactionSettings(
      waiver_bid: (json['waiver_bid'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TransactionSettingsToJson(
        TransactionSettings instance) =>
    <String, dynamic>{
      'waiver_bid': instance.waiver_bid,
    };

WaiverBudget _$WaiverBudgetFromJson(Map<String, dynamic> json) => WaiverBudget(
      sender: (json['sender'] as num?)?.toInt(),
      receiver: (json['receiver'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WaiverBudgetToJson(WaiverBudget instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'receiver': instance.receiver,
      'amount': instance.amount,
    };
