class ChatItem {
  String id;
  String name;
  String lastMessage;
  DateTime lastMessageTime;
  int unread;
  String avatar;

  ChatItem(this.id, this.name, this.lastMessage, this.lastMessageTime, this.avatar, [this.unread = 0]);
}
