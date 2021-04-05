import 'package:json_annotation/json_annotation.dart';
// part 'point-dto.g.dart';

@JsonSerializable()
class PointDto {
  final String uuid;
  final int lat;
  final int lon;

  PointDto(this.uuid, this.lat, this.lon);

  // factory PointDto.fromJson(Map<String, dynamic> json) => _$PointDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PointDtoToJson(this);


  factory PointDto.fromJson(Map<String, dynamic> json) {
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
}
