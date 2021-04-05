import 'dart:async';

import 'package:chat_on_map/client/chat-clietn.dart';
import 'package:chat_on_map/dto/income-message-dto.dart';
import 'package:chat_on_map/dto/outcome-message-dto.dart';
import 'package:chat_on_map/model/chat-message.dart';
import 'package:chat_on_map/model/message-type.dart';
import 'package:chat_on_map/repository/message-repository.dart';
import 'package:logger/logger.dart';

import 'handlers/handlers-registry.dart';
import 'preferences-service.dart';

class ChatMessageService {
  final MessageRepository _messageRepository;
  final ChatClient _chatClient;
  final PreferencesService _preferences;
  var logger = Logger();
  final List<Function> _messageListeners = <Function>[];
  final MsgHandlersRegistry _handlersRegistry;

  ChatMessageService(this._messageRepository, this._chatClient, this._preferences, this._handlersRegistry);

  addListener(Function listener) {
    _messageListeners.add(listener);
  }

  removeListeners() {
    _messageListeners.clear();
  }

  sendAndSaveMessage(String recipient, String message) async {
    if (message.trim().isEmpty) {
      return;
    }
    String? uuid = await _preferences.getUuid();
    if (uuid == null) {
      logger.w("user unregistered");
      return;
    }
    IncomeMessageDto response =
        await _chatClient.sendMessage(uuid, OutcomeMessageDto(uuid, recipient, message, MessageType.TEXT_MSG.value));
    if (response.id <= 0) {
      logger.w(response.body);
    } else {
      _messageRepository
          .save(TextMessage(response.id, response.senderId, response.recipientId, response.body, DateTime.now()));
      updateListeners();
    }
  }

  Future<List<TextMessage>> getAllMessagesFrom(String sender) async {
    String? uuid = await _preferences.getUuid();
    if (uuid == null) {
      logger.w("user unregistered");
      return <TextMessage>[];
    }
    var res = await _messageRepository.getAll(uuid, sender);

    return res;
  }

  runMessageUpdater() async {
    while (true) {
      String? uuid = await _preferences.getUuid();
      if (uuid == null) {
        await new Future.delayed(const Duration(milliseconds: 3000));
        continue;
      }
      int? lastId = await _messageRepository.getMaxMessageId(uuid);
      var messageDtos = await _chatClient.getMessage(uuid, lastId == null ? 0 : lastId);

      for (IncomeMessageDto msg in messageDtos) {
        MessageType.valueOf(msg.type).getHandler(_handlersRegistry).handleMsg(msg);
      }

      if (messageDtos.length > 0) {
        updateListeners();
      }
    }
  }

  updateListeners() {
    for (final listener in _messageListeners) {
      listener();
    }
  }
}
