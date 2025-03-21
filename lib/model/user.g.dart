// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['user_id'] as String,
      username: json['username'] as String,
      displayName: json['display_name'] as String,
      avatar: json['avatar'] as String,
      metadata: UserMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      isOwner: json['is_owner'] as bool,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'user_id': instance.userId,
      'username': instance.username,
      'display_name': instance.displayName,
      'avatar': instance.avatar,
      'metadata': instance.metadata,
      'is_owner': instance.isOwner,
    };
