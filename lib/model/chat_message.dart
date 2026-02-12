// class ChatMessage {
//   final int id;
//   final String userId;
//   final String username;
//   final String message;
//   final DateTime timestamp;
//
//   ChatMessage({
//     required this.id,
//     required this.userId,
//     required this.username,
//     required this.message,
//     required this.timestamp
//   });
// }


class ChatMessage{
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}