class TextMessage {
  int id;
  String sender;
  String recipient;
  String message;
  DateTime received;

  TextMessage(this.id, this.sender, this.recipient, this.message, [DateTime received]) {
    this.received = received ?? DateTime.now();
  }
}
