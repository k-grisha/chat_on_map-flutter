import 'package:json_annotation/json_annotation.dart';

part 'user-dto.g.dart';

@JsonSerializable()
class UserDto {
  final String uuid;
  final String name;

  UserDto(this.name, {this.uuid});

  factory UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}
