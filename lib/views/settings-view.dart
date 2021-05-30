import 'dart:async';

import 'package:chat_on_map/dto/create-user-dto.dart';
import 'package:chat_on_map/service/preferences-service.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../client/chat-clietn.dart';
import 'auth/sign_in_view.dart';

class SettingsView extends StatefulWidget {
  final ChatClient chatClient;
  final PreferencesService _preferences;

  SettingsView(this.chatClient, this._preferences);

  @override
  State<StatefulWidget> createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> with WidgetsBindingObserver {
  var _logger = Logger();

  // static final RegExp nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
  static final RegExp nameRegExp = RegExp(r'^[a-zA-Z](([\._\-][a-zA-Z0-9])|[a-zA-Z0-9])*[a-z0-9]$');
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eCtrl = new TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String _contactText = '';
  User? _currentUser;
  late FirebaseAuth _auth;
  late StreamSubscription<User?> _listener;
  bool _error = false;
  bool _initialized = false;

  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return new SignInScreen(
        header: new Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Text("Chose the authorisation method"),
          ),
        ),
      );
    } else {
      _eCtrl.text = _currentUser?.displayName ?? "";
      return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => _popIfRegistered(context),
            ),
            title: Text('Настройки'),
            backgroundColor: Colors.orange,
          ),
          body: Container(
              padding: EdgeInsets.all(10.0),
              child: new Form(
                  key: _formKey,
                  child: Column(children: [
                    new Text(
                      'Имя пользователя:',
                      style: TextStyle(fontSize: 10.0),
                    ),
                    new TextFormField(
                        controller: _eCtrl,
                        validator: (value) {
                          return _isNameValid(value);
                        }),
                    new SizedBox(height: 10.0),
                    new ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                          _registerNewUser(context);
                        }
                      },
                      child: Text('Регистрация'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue, // background
                        onPrimary: Colors.white, // foreground
                      ),
                    )
                  ]))));
    }
  }

  void _registerNewUser(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    var fbsMsgToken = await _firebaseMessaging.getToken();
    var fbsJwt = await _currentUser?.getIdToken();
    var name = _currentUser?.displayName;

    if (fbsMsgToken == null || fbsMsgToken.isEmpty) {
      _logger.w("Unable to get fbsMsgToken or JWT or name");
      return;
    }
    if (fbsJwt == null || fbsJwt.isEmpty) {
      _logger.w("Unable to get fbsJwt or JWT or name");
      return;
    }
    if (name == null || name.isEmpty) {
      _logger.w("Unable to get a name of current user");
      return;
    }

    var createdUser =
        await widget.chatClient.createUser(new CreateUserDto(name, fbsMsgToken, fbsJwt)).catchError((Object obj) {
      switch (obj.runtimeType) {
        case DioError:
          final res = (obj as DioError).response;
          _logger.e("Unable to create a user : ${res?.statusCode} -> ${res?.statusMessage}");
          break;
        default:
          _logger.e("Unable to create a user");
      }
    });

    if (createdUser.uuid.isEmpty) {
      _logger.w("Unable to registered new user " + _eCtrl.text);
      return;
    }

    await widget._preferences.setUuid(createdUser.uuid);
    Navigator.pop(context); //pop dialog
    Navigator.pop(context);
  }

  @override
  // fixme: it doesn't work
  Future<bool> didPopRoute() async {
    super.didPopRoute();
    String? myUuid = await widget._preferences.getUuid();
    if (myUuid != null) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  void initializeFlutterFire() async {
    try {
      setState(() {
        _auth = FirebaseAuth.instance;
        _initialized = true;
        _checkCurrentUser();
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  void _checkCurrentUser() async {
    _currentUser = _auth.currentUser;
    _currentUser?.getIdToken(true);
    _listener = _auth.userChanges().listen((User? user) {
      if (user != null && user.displayName != null) {
        setState(() {
          _currentUser = user;
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _listener.cancel();
    _eCtrl.dispose();
    super.dispose();
  }

  String? _isNameValid(String? name) {
    if (name == null || name.isEmpty || name.length > 50 || name.length < 3) {
      return "Пожалуйста введите имя, от 3 до 50 символа";
    }
    name = name.trim();
    if (name.length < 3 || !nameRegExp.hasMatch(name)) {
      return "Пожалуйста введите корректное имя";
    }
    return null;
  }

  void _popIfRegistered(BuildContext context) async {
    String? myUuid = await widget._preferences.getUuid();
    if (myUuid != null) {
      Navigator.of(context).pop();
    }
  }
}
