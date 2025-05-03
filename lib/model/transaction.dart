import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  final String? type;
  final String? transaction_id;
  final int? status_updated;
  final String? status;
  final TransactionSettings? settings;
  final List<int>? roster_ids;
  final dynamic metadata;
  final int? leg;
  final Map<String, int>? drops;
  final String? creator;
  final int? created;
  final List<int>? consenter_ids;
  final Map<String, int>? adds;
  final List<WaiverBudget>? waiver_budget;

  Transaction({
    this.type,
    this.transaction_id,
    this.status_updated,
    this.status,
    this.settings,
    this.roster_ids,
    this.metadata,
    this.leg,
    this.drops,
    this.creator,
    this.created,
    this.consenter_ids,
    this.adds,
    this.waiver_budget,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  
  Map<String, dynamic> toJson() => _$TransactionToJson(this);

  @override
  String toString() {
    return 'Transaction{type: $type, transaction_id: $transaction_id, status: $status, settings: $settings}';
  }
}

@JsonSerializable()
class TransactionSettings {
  final int? waiver_bid;

  TransactionSettings({
    this.waiver_bid,
  });

  factory TransactionSettings.fromJson(Map<String, dynamic> json) => _$TransactionSettingsFromJson(json);
  
  Map<String, dynamic> toJson() => _$TransactionSettingsToJson(this);

  @override
  String toString() {
    return 'TransactionSettings{waiver_bid: $waiver_bid}';
  }
}

@JsonSerializable()
class WaiverBudget {
  final int? sender;
  final int? receiver;
  final int? amount;

  WaiverBudget({
    this.sender,
    this.receiver,
    this.amount,
  });

  factory WaiverBudget.fromJson(Map<String, dynamic> json) => _$WaiverBudgetFromJson(json);
  
  Map<String, dynamic> toJson() => _$WaiverBudgetToJson(this);

  @override
  String toString() {
    return 'WaiverBudget{sender: $sender, receiver: $receiver, amount: $amount}';
  }
}
