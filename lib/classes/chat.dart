

class Chat {
  String eventName;
  String eventId;
  List<ChatMessage> messages;

  Chat({
    required this.eventName,
    required this.eventId,
    required this.messages,
  });

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      eventName: map['eventName'] ?? '',
      eventId: map['eventId'] ?? '',
      messages: (map['messages'] as List<dynamic>? ?? [])
          .map((message) => ChatMessage.fromMap(Map<String, dynamic>.from(message)))
          .toList(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'eventName': eventName,
      'eventId' : eventId,
      'messages': messages.map((message) => message.toMap()).toList(),
    };
  }

  void addMessage(String name, String message, DateTime time) {
    messages.add(ChatMessage(name: name, message: message, time: time));
  }
}

class ChatMessage {
  final String name;
  final String message;
  final DateTime time;

  ChatMessage({
    required this.name,
    required this.message,
    required this.time,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      name: map['name'] ?? '',
      message: map['message'] ?? '',
      time: DateTime.parse(map['time']),
    );
  }

  /// Converts the Message instance to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'message': message,
      'time': time.toIso8601String(),
    };
  }
}