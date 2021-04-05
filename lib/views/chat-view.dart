import 'package:chat_on_map/model/chat-message.dart';
import 'package:chat_on_map/model/chat-user.dart';
import 'package:chat_on_map/service/chat-message-service.dart';
import 'package:chat_on_map/service/datatime-util.dart';
import 'package:flutter/material.dart';

class ChatView extends StatefulWidget {
  final ChatMessageService _chatMessageService;

  const ChatView(this._chatMessageService);

  @override
  State<ChatView> createState() => ChatWidgetState();
}

class ChatWidgetState extends State<ChatView> {
  final TextEditingController _eCtrl = new TextEditingController();
  late ChatUser _opponent;

  @override
  Widget build(BuildContext context) {
    _opponent = ModalRoute.of(context)!.settings.arguments! as ChatUser;
    return new Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Чат c ' + _opponent.name),
          backgroundColor: Colors.orange,
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [getChatMessages(), getSendMessageFormWidget()],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    widget._chatMessageService.addListener(refresh);
  }

  refresh() {
    setState(() {});
  }

  @override
  void dispose() {
    widget._chatMessageService.removeListeners();
    _eCtrl.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Widget getChatMessages() {
    return FutureBuilder<List>(
        future: widget._chatMessageService.getAllMessagesFrom(_opponent.uuid),
        initialData: <TextMessage>[],
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return Expanded(
                child: Text("No Messages", style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1)));
          } else {
            return Flexible(
                child: new ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, i) {
                      return _buildRow(context, snapshot.data![i]);
                    }));
          }
        });
  }

  Widget _buildRow(context, TextMessage msg) {
    return Column(
      crossAxisAlignment: msg.sender != _opponent.uuid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Text(msg.message, style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(DateTimeUtil.getFormattedTime(msg.received),
                style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.8)),
            Icon(
              Icons.done_all,
              size: 17.0,
              color: Colors.orange,
            )
          ],
        ),
        Divider(),
      ],
    );
  }

  Widget getSendMessageFormWidget() {
    return TextField(
      keyboardType: TextInputType.multiline,
      maxLines: null,
      textInputAction: TextInputAction.newline,
      controller: _eCtrl,
      decoration: InputDecoration(
        hintText: 'Enter a message',
        suffixIcon: IconButton(
          icon: Icon(Icons.send),
          onPressed: () {
            widget._chatMessageService.sendAndSaveMessage(_opponent.uuid, _eCtrl.text);
            _eCtrl.clear();
            setState(() {});
          },
        ),
      ),
    );
  }
}
