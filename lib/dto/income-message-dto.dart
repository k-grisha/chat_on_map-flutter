import 'package:json_annotation/json_annotation.dart';

// part 'message-dto.g.dart';

@JsonSerializable()
class IncomeMessageDto {
  final int id;
  final String senderId;
  final String recipientId;
  final int type;
  final String body;

  IncomeMessageDto(this.senderId, this.recipientId, this.body, this.type, this.id);

  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);

  factory IncomeMessageDto.fromJson(Map<String, dynamic> json) {
    return IncomeMessageDto(
      json['senderId'] as String,
      json['recipientId'] as String,
      json['body'] as String,
      json['type'] as int,
      json['id'] as int,
    );
  }

  Map<String, dynamic> _$MessageDtoToJson(IncomeMessageDto instance) =>
      <String, dynamic>{
        'id': instance.id,
        'senderId': instance.senderId,
        'recipientId': instance.recipientId,
        'type': instance.type,
        'body': instance.body,
      };
}
