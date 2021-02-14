import 'package:chat_on_map/service/handlers/handlers-registry.dart';

class MessageType {
  final int value;
  final MsgHandler Function(MsgHandlersRegistry) getHandler;

  const MessageType._internal(this.value, this.getHandler);

  static const TEXT_MSG = const MessageType._internal(1, getTextMsgHandler);
  static const UNKNOWN_MSG = const MessageType._internal(0, getUnknownMsgHandler);

  static const List<MessageType> values = [TEXT_MSG, UNKNOWN_MSG];

  static MsgHandler getTextMsgHandler(MsgHandlersRegistry r) => r.getTextMessageHandler();

  static MsgHandler getUnknownMsgHandler(MsgHandlersRegistry r) => r.getUnknownMessageHandler();

  static MessageType valueOf(int val) {
    for (MessageType value in values) {
      if (value.value == val) {
        return value;
      }
    }
    return UNKNOWN_MSG;
  }
}
