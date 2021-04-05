import 'package:json_annotation/json_annotation.dart';

// part 'user-dto.g.dart';

@JsonSerializable()
class UserDto {
  final String uuid;
  final String name;
  final String fbsToken;

  UserDto(this.name, this.fbsToken, this.uuid);

  // factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      json['name'] as String,
      json['fbsToken'] as String,
      json['uuid'] as String,
    );
  }

  Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
    'uuid': instance.uuid,
    'name': instance.name,
    'fbsToken': instance.fbsToken,
  };
}
