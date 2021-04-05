import 'package:chat_on_map/dto/income-message-dto.dart';

import 'impl/text-msg-handler.dart';
import 'impl/unknown-msg-handler.dart';

class MsgHandlersRegistry {
  final TextMsgHandler _textMsgHandler;
  final UnknownMsgHandler _unknownMsgHandler;

  MsgHandlersRegistry(this._textMsgHandler, this._unknownMsgHandler);

  MsgHandler getTextMessageHandler() {
    return _textMsgHandler;
  }

  MsgHandler getUnknownMessageHandler() {
    return _unknownMsgHandler;
  }
}

abstract class MsgHandler {
  handleMsg(IncomeMessageDto msg);
}
