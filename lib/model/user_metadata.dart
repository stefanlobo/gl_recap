import 'package:json_annotation/json_annotation.dart';

part 'user_metadata.g.dart';

@JsonSerializable()
class UserMetadata {
  @JsonKey(name: 'team_name')
  final String? teamName;

  @JsonKey(name: "avatar")
  final String? avatar;

  UserMetadata({
    this.teamName,
    this.avatar,
  });

  factory UserMetadata.fromJson(Map<String, dynamic> json) => _$UserMetadataFromJson(json);

  Map<String, dynamic> toJson() => _$UserMetadataToJson(this);
}
