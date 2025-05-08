// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String,
      avatar: json['avatar'] as String,
      metadata: json['metadata'] == null
          ? null
          : UserMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'user_id': instance.userId,
      'display_name': instance.displayName,
      'avatar': instance.avatar,
      'metadata': instance.metadata,
    };
