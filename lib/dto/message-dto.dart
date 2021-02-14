import 'package:json_annotation/json_annotation.dart';

part 'message-dto.g.dart';

@JsonSerializable()
class MessageDto {
  final int id;
  final String sender;
  final String recipient;
  final int type;
  final String body;

  MessageDto(this.sender, this.recipient, this.body, this.type, {this.id});

  factory MessageDto.fromJson(Map<String, dynamic> json) => _$MessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);
}
