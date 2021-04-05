import 'package:chat_on_map/dto/income-message-dto.dart';
import 'package:logger/logger.dart';

import '../handlers-registry.dart';

class UnknownMsgHandler implements MsgHandler {
  final _logger = Logger();

  @override
  handleMsg(IncomeMessageDto msgDto) {
    _logger.e("Unknown message received type: " +
        msgDto.type.toString() +
        ", from " +
        msgDto.senderId +
        ", to " +
        msgDto.recipientId +
        ", body:\n " +
        msgDto.body);
  }
}
