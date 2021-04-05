import 'package:chat_on_map/model/chat-item.dart';
import 'package:chat_on_map/repository/user-repository.dart';

import 'preferences-service.dart';

class ChatItemService {
  final UserRepository _userRepository;
  final PreferencesService _preferences;

  ChatItemService(this._userRepository, this._preferences);

  Future<List<ChatItem>> getAllItems() async {
    String? uuid = await _preferences.getUuid();
    if (uuid == null) {
      return <ChatItem>[];
    }
    var result = await _userRepository.getChatList(uuid);
    result.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    return result;
  }

// Future<int> getSize() async {
//   String uuid = await _preferences.getUuid();
//   return (await _userRepository.getChatList(uuid)).length;
// }

}
