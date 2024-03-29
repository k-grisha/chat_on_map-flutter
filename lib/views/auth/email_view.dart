import 'package:chat_on_map/views/auth/password_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'sign_up_view.dart';
import 'utils.dart';

class EmailView extends StatefulWidget {
  final bool passwordCheck;

  EmailView(this.passwordCheck, {Key? key}) : super(key: key);

  @override
  _EmailViewState createState() => new _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
  final TextEditingController _controllerEmail = new TextEditingController();

  @override
  Widget build(BuildContext context) => new Scaffold(
        appBar: new AppBar(
          title: new Text("welcome"),
          elevation: 4.0,
        ),
        body: new Builder(
          builder: (BuildContext context) {
            return new Padding(
              padding: const EdgeInsets.all(16.0),
              child: new Column(
                children: <Widget>[
                  new TextField(
                    controller: _controllerEmail,
                    autofocus: true,
                    onSubmitted: _submit,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    decoration: new InputDecoration(labelText: "e-mail"),
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
                  onPressed: () => _connexion(context),
                  child: new Row(
                    children: <Widget>[
                      new Text("next"),
                    ],
                  )),
            ],
          )
        ],
      );

  _submit(String submitted) {
    _connexion(context);
  }

  _connexion(BuildContext context) async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      List<String> providers = await auth.fetchSignInMethodsForEmail(_controllerEmail.text);
      print(providers);

      if (providers == null || providers.isEmpty) {
        bool? connected = await Navigator.of(context).push(new MaterialPageRoute<bool>(builder: (BuildContext context) {
          return new SignUpView(_controllerEmail.text, widget.passwordCheck);
        }));

        if (connected == true) {
          Navigator.pop(context);
        }
      } else if (providers.contains('password')) {
        bool? connected = await Navigator.of(context).push(new MaterialPageRoute<bool>(builder: (BuildContext context) {
          return new PasswordView(_controllerEmail.text);
        }));

        if (connected == true) {
          Navigator.pop(context);
        }
      } else {
        String provider = await _showDialogSelectOtherProvider(_controllerEmail.text, providers);
        if (provider.isNotEmpty) {
          Navigator.pop(context, provider);
        }
      }
    } catch (exception) {
      print(exception);
    }
  }

  _showDialogSelectOtherProvider(String email, List<String> providers) {
    var providerName = _providersToString(providers);
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) => new AlertDialog(
        content: new SingleChildScrollView(
            child: new ListBody(
          children: <Widget>[
            new Text('You have already used $email. Sign in with $providerName to continue.'),
            new SizedBox(
              height: 16.0,
            ),
            new Column(
              children: providers.map((String p) {
                return new RaisedButton(
                  child: new Row(
                    children: <Widget>[
                      new Text(_providerStringToButton(p) ?? "non"),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(p);
                  },
                );
              }).toList(),
            )
          ],
        )),
        actions: <Widget>[
          new FlatButton(
            child: new Row(
              children: <Widget>[
                new Text("cancel"),
              ],
            ),
            onPressed: () {
              Navigator.of(context).pop('');
            },
          ),
        ],
      ),
    );
  }

  String _providersToString(List<String> providers) {
    return providers.map((String provider) {
      ProvidersTypes? type = stringToProvidersType(provider);
      return providersDefinitions()[type]?.name;
    }).join(", ");
  }

  String? _providerStringToButton(String provider) {
    ProvidersTypes? type = stringToProvidersType(provider);
    return providersDefinitions()[type]?.label;
  }
}
