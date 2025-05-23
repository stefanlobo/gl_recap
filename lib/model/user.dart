import 'package:guillotine_recap/model/user_metadata.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'display_name')
  final String displayName;

  @JsonKey(name: 'avatar')
  final String avatar;

  @JsonKey(name: 'metadata')
  final UserMetadata? metadata;

  // @JsonKey(name: 'is_owner')
  // final bool isOwner;

  User({
    required this.userId,
    required this.displayName,
    required String avatar,
    this.metadata,
  }) : avatar = metadata?.avatar ?? avatar;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
