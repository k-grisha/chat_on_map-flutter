// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'point-dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PointDto _$PointDtoFromJson(Map<String, dynamic> json) {
  return PointDto(
    json['uuid'] as String,
    json['lat'] as int,
    json['lon'] as int,
  );
}

Map<String, dynamic> _$PointDtoToJson(PointDto instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'lat': instance.lat,
      'lon': instance.lon,
    };
