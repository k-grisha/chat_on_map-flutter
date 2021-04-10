library firebase_ui;

export 'utils.dart';

import 'package:flutter/material.dart';
import 'login_view.dart';
import 'utils.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen(
    this.showBar,
    this.avoidBottomInset,
    this.bottomPadding,
    this.horizontalPadding,
    this.title, {
    Key? key,
    this.header,
    this.footer,
    this.signUpPasswordCheck,
    this.providers,
    this.color,
    this.twitterConsumerKey,
    this.twitterConsumerSecret,
    this.appleSignInAvailable,
  }) : super(key: key);

  final String title;
  final Widget? header;
  final Widget? footer;
  final List<ProvidersTypes>? providers;
  final Color? color;
  final bool? signUpPasswordCheck;
  final String? twitterConsumerKey;
  final String? twitterConsumerSecret;
  final bool showBar;
  final bool avoidBottomInset;
  final double horizontalPadding;
  final double bottomPadding;
  final bool? appleSignInAvailable;

  @override
  _SignInScreenState createState() => new _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  Widget get _header => widget.header ?? new Container();

  Widget get _footer => widget.footer ?? new Container();

  bool get _passwordCheck => widget.signUpPasswordCheck ?? false;

  List<ProvidersTypes> get _providers => widget.providers ?? [ProvidersTypes.email];

  @override
  Widget build(BuildContext context) => new Scaffold(
      appBar: widget.showBar
          ? new AppBar(
              title: new Text(widget.title),
              elevation: 4.0,
            )
          : null,
      resizeToAvoidBottomInset: widget.avoidBottomInset,
      body: new Builder(
        builder: (BuildContext context) {
          return new Container(
              decoration: new BoxDecoration(color: widget.color),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _header,
                  new Expanded(
                    child: new Padding(
                        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
                        child: LoginView(_providers, widget.bottomPadding,
                            passwordCheck: _passwordCheck,
                            twitterConsumerKey: widget.twitterConsumerKey,
                            twitterConsumerSecret: widget.twitterConsumerSecret,
                            appleSignIn: widget.appleSignInAvailable)),
                  ),
                  _footer
                ],
              ));
        },
      ));
}
