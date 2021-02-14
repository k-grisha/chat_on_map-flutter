import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:chat_on_map/service/handlers/handlers-registry.dart';
import 'package:chat_on_map/service/handlers/impl/text-msg-handler.dart';
import 'package:chat_on_map/service/handlers/impl/unknown-msg-handler.dart';
import 'package:chat_on_map/views/chat-list-view.dart';
import 'package:chat_on_map/views/chat-view.dart';
import 'package:chat_on_map/views/map-view.dart';
import 'package:flutter_simple_dependency_injection/injector.dart';

import 'client/chat-clietn.dart';
import 'client/map-client.dart';
import 'environment.dart';
import 'repository/message-repository.dart';
import 'repository/user-repository.dart';
import 'service/chat-item-service.dart';
import 'service/chat-message-service.dart';
import 'service/marker-service.dart';
import 'service/position-service.dart';
import 'service/preferences-service.dart';
import 'service/user-service.dart';
import 'views/settings-view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var injector = ModuleContainer().initialise(Injector(), Environment.DEV);
    injector.get<ChatMessageService>().runMessageUpdater();
    return MaterialApp(initialRoute: '/', routes: {
      '/': (BuildContext context) => MapWidget(injector.get<MarkerService>(), injector.get<PreferencesService>(),
          injector.get<PositionService>(), injector.get<UserService>()),
      '/chat-list': (BuildContext context) => ChatListView(injector.get<ChatItemService>()),
      '/chat': (BuildContext context) => ChatView(injector.get<ChatMessageService>()),
      '/registration': (BuildContext context) =>
          SettingsView(injector.get<ChatClient>(), injector.get<PreferencesService>()),
    });
  }
}

class ModuleContainer {
  Injector initialise(Injector injector, Environment env) {
    injector.map<EnvSettings>((i) => env.settings, isSingleton: true);
    injector.map<PositionService>((i) => PositionService(i.get<PreferencesService>(), i.get<MapClient>()),
        isSingleton: true);
    injector.map<PreferencesService>((i) => PreferencesService(), isSingleton: true);
    injector.map<ChatClient>((i) => ChatClient(Dio()), isSingleton: true);
    injector.map<MapClient>((i) => MapClient(Dio()), isSingleton: true);
    injector.map<MarkerService>((i) => MarkerService(i.get<MapClient>(), i.get<PreferencesService>()),
        isSingleton: true);
    injector.map<ChatItemService>((i) => ChatItemService(i.get<UserRepository>(), i.get<PreferencesService>()),
        isSingleton: true);
    injector.map<MessageRepository>((i) => MessageRepository(), isSingleton: true);
    injector.map<UserRepository>((i) => UserRepository(), isSingleton: true);
    injector.map<TextMsgHandler>((i) => TextMsgHandler(i.get<MessageRepository>()), isSingleton: true);
    injector.map<UserService>((i) => UserService(i.get<ChatClient>(), i.get<UserRepository>()), isSingleton: true);
    injector.map<UnknownMsgHandler>((i) => UnknownMsgHandler(), isSingleton: true);
    injector.map<MsgHandlersRegistry>((i) => MsgHandlersRegistry(i.get<TextMsgHandler>(), i.get<UnknownMsgHandler>()),
        isSingleton: true);
    injector.map<ChatMessageService>(
            (i) => ChatMessageService(
            i.get<MessageRepository>(), i.get<ChatClient>(), i.get<PreferencesService>(), i.get<MsgHandlersRegistry>()),
        isSingleton: true);

    return injector;
  }
}
