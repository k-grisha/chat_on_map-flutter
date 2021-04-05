import 'package:json_annotation/json_annotation.dart';

// part 'message-dto.g.dart';

@JsonSerializable()
class OutcomeMessageDto {
  final String senderId;
  final String recipientId;
  final int type;
  final String body;

  OutcomeMessageDto(this.senderId, this.recipientId, this.body, this.type);

  Map<String, dynamic> toJson() => _$MessageDtoToJson(this);

  factory OutcomeMessageDto.fromJson(Map<String, dynamic> json) {
    return OutcomeMessageDto(
      json['senderId'] as String,
      json['recipientId'] as String,
      json['body'] as String,
      json['type'] as int,
    );
  }

  Map<String, dynamic> _$MessageDtoToJson(OutcomeMessageDto instance) =>
      <String, dynamic>{
        'senderId': instance.senderId,
        'recipientId': instance.recipientId,
        'type': instance.type,
        'body': instance.body,
      };
}
