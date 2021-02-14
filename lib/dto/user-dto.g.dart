// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user-dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) {
  return UserDto(
    json['name'] as String,
    uuid: json['uuid'] as String,
  );
}

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
    };
