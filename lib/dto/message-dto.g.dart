// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message-dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) {
  return MessageDto(
    json['sender'] as String,
    json['recipient'] as String,
    json['body'] as String,
    json['type'] as int,
    id: json['id'] as int,
  );
}

Map<String, dynamic> _$MessageDtoToJson(MessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'recipient': instance.recipient,
      'type': instance.type,
      'body': instance.body,
    };
