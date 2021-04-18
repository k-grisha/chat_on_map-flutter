import 'package:json_annotation/json_annotation.dart';

// part 'user-dto.g.dart';

@JsonSerializable()
class CreateUserDto {
  final String name;
  final String fbsMsgToken;
  final String fbsJwt;

  CreateUserDto(this.name, this.fbsMsgToken, this.fbsJwt);

  // factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserDto(this);

  factory CreateUserDto.fromJson(Map<String, dynamic> json) {
    return CreateUserDto(
      json['name'] as String,
      json['fbsMsgToken'] as String,
      json['fbsJwt'] as String,
    );
  }

  Map<String, dynamic> _$CreateUserDto(CreateUserDto instance) => <String, dynamic>{
    'name': instance.name,
    'fbsMsgToken': instance.fbsMsgToken,
    'fbsJwt': instance.fbsJwt,
  };
}
