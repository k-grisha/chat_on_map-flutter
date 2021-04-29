import 'package:chat_on_map/model/chat-user.dart';
import 'package:chat_on_map/repository/user-repository.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../client/chat-clietn.dart';
import '../dto/user-dto.dart';

class UserService {
  final ChatClient _chatClient;
  final UserRepository _userRepository;
  var _logger = Logger();

  UserService(this._chatClient, this._userRepository);

  Future<ChatUser> getUser(String uuid) async {
    var user = await _userRepository.getUser(uuid);
    if (user != null) {
      return user;
    }
    // todo try id user notFound
    UserDto userDto = await _chatClient.getUser(uuid).catchError((Object obj) {
      final res = (obj as DioError).response;
      _logger.e("Unable to fetch a user $uuid : ${res?.statusCode} -> ${res?.statusMessage}");
      throw ("Unable to fetch a user $uuid : ${res?.statusCode} -> ${res?.statusMessage}");
    });

    user = ChatUser(userDto.uuid, userDto.name, userDto.picture);
    await _userRepository.save(user);
    return user;
  }
}
