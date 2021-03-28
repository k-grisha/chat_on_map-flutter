import 'dart:ui';

import 'package:flutter/material.dart';

class CustomInfoWindow extends StatefulWidget {
  final String name, description, text;
  final Image img;

  const CustomInfoWindow({Key key, this.name, this.description, this.text, this.img}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomInfoWindowState();
}

class _CustomInfoWindowState extends State<CustomInfoWindow> {
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  left: Constants.padding,
                  top: Constants.avatarRadius,
                  right: Constants.padding,
                  bottom: Constants.padding),
              margin: EdgeInsets.only(
                  left: Constants.padding,
                  top: Constants.avatarRadius,
                  right: Constants.padding,
                  bottom: Constants.padding),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Constants.padding),
                  boxShadow: [
                    BoxShadow(color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    widget.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                        onPressed: () {
                          print("KUKUKU");
                        },
                        child: Text(
                          "Chat",
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                ],
              ),
            ),
            Positioned(
              left: Constants.padding,
              right: Constants.padding,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: Constants.avatarRadius,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                    child: Icon(
                      Icons.emoji_emotions,
                      size: 64.0,
                      // color: Colors.orange,
                    )),
              ),
            ),
          ],
        ));
  }
}

class Constants {
  Constants._();

  static const double padding = 10;
  static const double avatarRadius = 35;
}
