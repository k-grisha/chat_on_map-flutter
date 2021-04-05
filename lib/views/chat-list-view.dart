import 'package:chat_on_map/model/chat-item.dart';
import 'package:chat_on_map/model/chat-user.dart';
import 'package:chat_on_map/service/chat-item-service.dart';
import 'package:chat_on_map/service/datatime-util.dart';
import 'package:flutter/material.dart';

class ChatListView extends StatelessWidget {
  final ChatItemService chatItemService;

  const ChatListView(this.chatItemService);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Чаты'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [getChatItemsWidget()],
        ),
      ),
    );
  }

  Widget getChatItemsWidget() {
    return FutureBuilder<List>(
        future: chatItemService.getAllItems(),
        initialData: <ChatItem>[],
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return Expanded(
                child: Text("No Messages", style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1)));
          } else {
            return Flexible(
                child: new ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemBuilder: (context, i) {
                return _buildRow(context, snapshot.data![i]);
                // return Text(""+ i.toString(), style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1));
              },
            ));
          }
        });
  }

  Widget _buildRow(context, ChatItem chatItem) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/chat', arguments: ChatUser(chatItem.id, chatItem.name));
        },
        child: Container(
            height: 50,
            // color: Colors.white,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Text(chatItem.name,
                            style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.left)),
                    Expanded(
                        child: Text(chatItem.lastMessage,
                            textAlign: TextAlign.left,
                            style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.9)))
                  ],
                ),
                Expanded(
                    child: Text(DateTimeUtil.getFormattedDateTime(chatItem.lastMessageTime),
                        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.8),
                        textAlign: TextAlign.right))
              ],
            )
            // child: Center(child: Text(chatItem.name)),
            ));
  }

// Widget getChatItemsWidget2() {
//   return ListView.separated(
//     padding: const EdgeInsets.all(8),
//     itemCount: chatItemService.getSize(),
//     itemBuilder: (BuildContext context, int index) {
//       var chatItem = chatItems[index];
//       return InkWell(
//           onTap: () {
//             Navigator.pushNamed(context, '/chat');
//           },
//           child: Container(
//               height: 50,
//               // color: Colors.white,
//               child: Row(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                           child: Text(chatItem.name,
//                               style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.left)),
//                       Expanded(
//                           child: Text(chatItem.lastMessage,
//                               textAlign: TextAlign.left,
//                               style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.9)))
//                     ],
//                   ),
//                   Expanded(
//                       child: Text(DateTimeUtil.getFormattedDateTime(chatItem.lastMessageTime),
//                           style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 0.8),
//                           textAlign: TextAlign.right))
//                 ],
//               )
//               // child: Center(child: Text(chatItem.name)),
//               ));
//     },
//     separatorBuilder: (BuildContext context, int index) => const Divider(),
//   );
// }

}
