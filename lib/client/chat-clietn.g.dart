// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat-clietn.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ChatClient implements ChatClient {
  _ChatClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    baseUrl ??= 'http://192.168.31.154:8020/api/v1';
  }

  final Dio _dio;

  String baseUrl;

  @override
  Future<UserDto> createUser(userDto) async {
    ArgumentError.checkNotNull(userDto, 'userDto');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(userDto?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>('/user',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = UserDto.fromJson(_result.data);
    return value;
  }

  @override
  Future<UserDto> getUser(uuid) async {
    ArgumentError.checkNotNull(uuid, 'uuid');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<Map<String, dynamic>>('/user/$uuid',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = UserDto.fromJson(_result.data);
    return value;
  }

  @override
  Future<List<MessageDto>> getMessage(uuid, lastId) async {
    ArgumentError.checkNotNull(uuid, 'uuid');
    ArgumentError.checkNotNull(lastId, 'lastId');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'lastId': lastId};
    final _data = <String, dynamic>{};
    final _result = await _dio.request<List<dynamic>>('/message/$uuid',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    var value = _result.data
        .map((dynamic i) => MessageDto.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<MessageDto> sendMessage(uuid, messageDto) async {
    ArgumentError.checkNotNull(uuid, 'uuid');
    ArgumentError.checkNotNull(messageDto, 'messageDto');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(messageDto?.toJson() ?? <String, dynamic>{});
    final _result = await _dio.request<Map<String, dynamic>>('/message/$uuid',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = MessageDto.fromJson(_result.data);
    return value;
  }
}
