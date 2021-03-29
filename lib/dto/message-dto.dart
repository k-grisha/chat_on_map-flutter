import 'package:json_annotation/json_annotation.dart';

part 'message-dto.g.dart';

@JsonSerializable()
class MessageDto {
  final int id;
  final String senderId;
  final String recipientId;
  final int type;
  final String body;

  MessageDto(this.senderId, this.recipientId, this.body, this.type, {this.id});

  factory MessageDto.fromJson(Map<String, dynamic> json) => _$MessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);
}
