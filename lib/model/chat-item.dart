class ChatItem {
  String id;
  String name;
  String lastMessage;
  DateTime lastMessageTime;
  int unread;

  ChatItem(this.id, this.name, this.lastMessage, this.lastMessageTime, [this.unread = 0]);
}
