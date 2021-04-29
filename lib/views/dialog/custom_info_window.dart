import 'dart:ui';

import 'package:chat_on_map/model/chat-user.dart';
import 'package:flutter/material.dart';

class CustomInfoWindow extends StatefulWidget {
  final ChatUser chatUser;

  const CustomInfoWindow(Key? key, this.chatUser) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomInfoWindowState();
}

class _CustomInfoWindowState extends State<CustomInfoWindow> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    // TODO improve animation
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 100));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        child: ScaleTransition(
          scale: scaleAnimation,
          child: _getInfoWindow(),
        ));
  }

  _getInfoWindow() {
    return Stack(
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
                widget.chatUser.name,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "I'd like to chat",
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () => Navigator.pushNamed(context, '/chat', arguments: widget.chatUser),
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    backgroundColor: Colors.orange,
                    child: const Icon(Icons.forum, size: 36.0),
                  )
                  // FlatButton(
                  //     onPressed: () {
                  //       Navigator.pushNamed(context, '/chat', arguments: widget.chatUser);
                  //     },
                  //     child: const Icon(Icons.forum, size: 36.0, color: Colors.orange,)),
                  ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(backgroundColor: Colors.transparent, radius: Constants.avatarRadius, child: _getAvatar()
              // child: ClipRRect(
              //     borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
              //     child: Icon(
              //       Icons.emoji_emotions,
              //       color: Colors.orange,
              //       size: 64.0,
              //       // color: Colors.orange,
              //     )),
              ),
        ),
      ],
    );
  }

  _getAvatar() {
    var image = widget.chatUser.avatar?.isEmpty == false
        ? Image.network(
            widget.chatUser.avatar!,
            width: 64,
            height: 64,
          )
        : Icon(
            Icons.emoji_emotions,
            color: Colors.orange,
            size: 64.0,
          );
    return ClipRRect(borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)), child: image);
  }
}

class Constants {
  Constants._();

  static const double padding = 10;
  static const double avatarRadius = 35;
}
