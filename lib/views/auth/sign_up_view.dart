import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'utils.dart';

class SignUpView extends StatefulWidget {
  final String email;
  final bool passwordCheck;

  SignUpView(this.email, this.passwordCheck, {Key? key}) : super(key: key);

  @override
  _SignUpViewState createState() => new _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  late TextEditingController _controllerEmail;
  late TextEditingController _controllerDisplayName;
  late TextEditingController _controllerPassword;
  late TextEditingController _controllerCheckPassword;

  final FocusNode _focusPassword = FocusNode();

  bool _valid = false;

  @override
  dispose() {
    _focusPassword.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    _controllerEmail = new TextEditingController(text: widget.email);
    _controllerDisplayName = new TextEditingController();
    _controllerPassword = new TextEditingController();
    _controllerCheckPassword = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _controllerEmail.text = widget.email;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("signUp"),
        elevation: 4.0,
      ),
      body: new Builder(
        builder: (BuildContext context) {
          return new Padding(
            padding: const EdgeInsets.all(16.0),
            child: new ListView(
              children: <Widget>[
                new TextField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  onSubmitted: _submit,
                  decoration: new InputDecoration(
                      labelText: "email"),
                ),
                const SizedBox(height: 8.0),
                new TextField(
                  controller: _controllerDisplayName,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  onChanged: _checkValid,
                  onSubmitted: _submitDisplayName,
                  decoration: new InputDecoration(
                      labelText: "name"),
                ),
                const SizedBox(height: 8.0),
                new TextField(
                  controller: _controllerPassword,
                  obscureText: true,
                  autocorrect: false,
                  onSubmitted: _submit,
                  focusNode: _focusPassword,
                  decoration: new InputDecoration(
                      labelText: "password"),
                ),
                !widget.passwordCheck
                    ? new Container()
                    : new TextField(
                        controller: _controllerCheckPassword,
                        obscureText: true,
                        autocorrect: false,
                        decoration: new InputDecoration(
                            labelText: "password check"),
                      ),
              ],
            ),
          );
        },
      ),
      persistentFooterButtons: <Widget>[
        new ButtonBar(
          alignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new FlatButton(
                onPressed: _valid ? () => _connexion(context) : null,
                child: new Row(
                  children: <Widget>[
                    new Text("save"),
                  ],
                )),
          ],
        )
      ],
    );
  }

  _submitDisplayName(String submitted) {
    FocusScope.of(context).requestFocus(_focusPassword);
  }

  _submit(String submitted) {
    _connexion(context);
  }

  _connexion(BuildContext context) async {
    if (widget.passwordCheck &&
        _controllerPassword.text != _controllerCheckPassword.text) {
      showErrorDialog(context, "password Check Error");
      return;
    }

    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      User? user = authResult.user;
      try {
        var displayName = _controllerDisplayName.text;
        await user?.updateProfile(displayName: displayName);
        Navigator.pop(context, true);
      } catch (e) {
        showErrorDialog(context, e.toString());
      }
    } on PlatformException catch (e) {
      print(e.details);
      //TODO improve errors catching
      String msg = "The password must be 6 characters long or more";
      showErrorDialog(context, msg);
    }
  }

  void _checkValid(String value) {
    setState(() {
      _valid = _controllerDisplayName.text.isNotEmpty;
    });
  }
}
