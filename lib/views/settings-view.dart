import 'dart:async';

import 'package:chat_on_map/dto/create-user-dto.dart';
import 'package:chat_on_map/service/preferences-service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../client/chat-clietn.dart';
import 'auth/sign_in_view.dart';
import 'auth/utils.dart';

class SettingsView extends StatefulWidget {
  final ChatClient mapClient;
  final PreferencesService _preferences;

  SettingsView(this.mapClient, this._preferences);

  @override
  State<StatefulWidget> createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> with WidgetsBindingObserver {
  var logger = Logger();

  // static final RegExp nameRegExp = RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]');
  static final RegExp nameRegExp = RegExp(r'^[a-zA-Z](([\._\-][a-zA-Z0-9])|[a-zA-Z0-9])*[a-z0-9]$');
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eCtrl = new TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // GoogleSignInAccount? _currentUser;
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
    }
    // var token = await _currentUser?.getIdToken();
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

    var fbsToken = await _firebaseMessaging.getToken();
    var createdUser = await widget.mapClient.createUser(new CreateUserDto(_eCtrl.text, fbsToken!, ""));

    if (createdUser.uuid.isEmpty) {
      logger.w("Unable to registered new user " + _eCtrl.text);
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

    // _googleSignIn.signIn();
    //
    // // FirebaseAuth.instance.authStateChanges()
    // // .listen((User? user) {
    // //   if (user == null) {
    // //     print('User is currently signed out!');
    // //   } else {
    // //     print('User is signed in!');
    // //   }
    // // });
    // //
    // _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
    //   setState(() {
    //     _currentUser = account;
    //   });
    //   if (_currentUser != null) {
    //     _handleGetContact(_currentUser!);
    //   }
    // });
    // _googleSignIn.signInSilently();
  }

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      //await Firebase.initializeApp();
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

    _listener = _auth.authStateChanges().listen((User? user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  // GoogleSignIn _googleSignIn = GoogleSignIn(
  //   // Optional clientId
  //   // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
  //   scopes: <String>[
  //     'email',
  //     'https://www.googleapis.com/auth/contacts.readonly',
  //   ],
  // );
  //
  // Future<void> _handleGetContact(GoogleSignInAccount user) async {
  //   setState(() {
  //     _contactText = "Loading contact info...";
  //   });
  //   final http.Response response = await http.get(
  //     Uri.parse('https://people.googleapis.com/v1/people/me/connections'
  //         '?requestMask.includeField=person.names'),
  //     headers: await user.authHeaders,
  //   );
  //   if (response.statusCode != 200) {
  //     setState(() {
  //       _contactText = "People API gave a ${response.statusCode} "
  //           "response. Check logs for details.";
  //     });
  //     print('People API ${response.statusCode} response: ${response.body}');
  //     return;
  //   }
  //   final Map<String, dynamic> data = json.decode(response.body);
  //   final String? namedContact = _pickFirstNamedContact(data);
  //   setState(() {
  //     if (namedContact != null) {
  //       _contactText = "I see you know $namedContact!";
  //     } else {
  //       _contactText = "No contacts to display.";
  //     }
  //   });
  // }

  // String? _pickFirstNamedContact(Map<String, dynamic> data) {
  //   final List<dynamic>? connections = data['connections'];
  //   final Map<String, dynamic>? contact = connections?.firstWhere(
  //     (dynamic contact) => contact['names'] != null,
  //     orElse: () => null,
  //   );
  //   if (contact != null) {
  //     final Map<String, dynamic>? name = contact['names'].firstWhere(
  //       (dynamic name) => name['displayName'] != null,
  //       orElse: () => null,
  //     );
  //     if (name != null) {
  //       return name['displayName'];
  //     }
  //   }
  //   return null;
  // }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
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
