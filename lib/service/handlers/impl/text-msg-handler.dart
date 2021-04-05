import 'package:chat_on_map/dto/income-message-dto.dart';
import 'package:chat_on_map/model/chat-message.dart';
import 'package:chat_on_map/repository/message-repository.dart';

import '../handlers-registry.dart';

class TextMsgHandler implements MsgHandler {
  final MessageRepository _messageRepository;

  TextMsgHandler(this._messageRepository);

  @override
  handleMsg(IncomeMessageDto messageDto) {
    var textMessage = new TextMessage(messageDto.id, messageDto.senderId, messageDto.recipientId, messageDto.body);
    _messageRepository.save(textMessage);
  }
}
