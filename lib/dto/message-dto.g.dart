// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message-dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) {
  return MessageDto(
    json['senderId'] as String,
    json['recipientId'] as String,
    json['body'] as String,
    json['type'] as int,
    id: json['id'] as int,
  );
}

Map<String, dynamic> _$MessageDtoToJson(MessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderId': instance.senderId,
      'recipientId': instance.recipientId,
      'type': instance.type,
      'body': instance.body,
    };
