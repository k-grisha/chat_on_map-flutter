import 'package:chat_on_map/dto/message-dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../dto/user-dto.dart';

part 'chat-clietn.g.dart';

@RestApi(baseUrl: "http://192.168.31.154:8020/api/v1")
abstract class ChatClient {
  factory ChatClient(Dio dio, {String baseUrl}) = _ChatClient;

  @POST("/user")
  Future<UserDto> createUser(@Body() UserDto userDto);

  @GET("/user/{uuid}")
  Future<UserDto> getUser(@Path("uuid") String uuid);

  @GET("/message/{uuid}")
  Future<List<MessageDto>> getMessage(@Path("uuid") String uuid, @Query("lastId") int lastId);

  @POST("/message/{uuid}")
  Future<MessageDto> sendMessage(@Path("uuid") String uuid, @Body() MessageDto messageDto);
}
