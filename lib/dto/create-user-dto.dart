import 'package:json_annotation/json_annotation.dart';

// part 'user-dto.g.dart';

@JsonSerializable()
class CreateUserDto {
  final String name;
  final String fbsToken;

  CreateUserDto(this.name, this.fbsToken);

  // factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUserDto(this);

  factory CreateUserDto.fromJson(Map<String, dynamic> json) {
    return CreateUserDto(
      json['name'] as String,
      json['fbsToken'] as String,
    );
  }

  Map<String, dynamic> _$CreateUserDto(CreateUserDto instance) => <String, dynamic>{
    'name': instance.name,
    'fbsToken': instance.fbsToken,
  };
}
