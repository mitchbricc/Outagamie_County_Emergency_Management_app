// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../classes/user.dart';
import '../../models/chat.dart';

class ChatWidget extends StatefulWidget {
  final ChatModel model;
  final User user;
  final String eventId;
  final String eventName;
  const ChatWidget({super.key, required this.model, required this.user, required this.eventId, required this.eventName});

  @override
  State<ChatWidget> createState() => _ChatWidgetState(model: model, user: user, eventId: eventId, eventName: eventName);
}

class _ChatWidgetState extends State<ChatWidget> {
  final ChatModel model;
  User user;
  final String eventId;
  final String eventName;
  _ChatWidgetState({required this.model, required this.user, required this.eventId, required this.eventName});
  //List<ChatMessage> messages = [];
  @override
  void initState() {
    super.initState();
  //   messages = [
  //   ChatMessage(name: 'Mike Johnson', message: 'What tools should we bring?', time: DateTime.now().subtract(const Duration(minutes: 5))),
  //   ChatMessage(name: 'Jane Smith', message: 'Looking forward to helping out.', time:  DateTime.now().subtract(const Duration(minutes: 10))),
  //   ChatMessage(name: 'John Doe', message: 'Excited for the event!', time: DateTime.now().subtract(const Duration(minutes: 15))),
  // ];
    // model.updateChat(Chat(eventName: eventName, eventId: eventId, messages: messages)).then((onValue){
    //   setState(() {
        
    //   });
    // });
    model.getChat(eventId,eventName).then((onValue){
      setState(() {
        
      });
    });
  }

  final TextEditingController _controller = TextEditingController();

  // Function to format date and time for display
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        model.chat.addMessage(user.firstName + user.lastName, _controller.text, DateTime.now());
        });
      
      model.updateChat(model.chat);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return model.isLoaded ? scaffold() : const Text('Loading');
  }

  Scaffold scaffold() {
    return Scaffold(
    appBar: AppBar(
      title: Text(eventName),
    ),
    body: Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: model.chat.messages.length,
            itemBuilder: (context, index) {
              final message = model.chat.messages[index];
              return ListTile(
                title: Text(message.name),
                subtitle: Text(
                    '${message.message}\n${_formatDateTime(message.time)}'),
                isThreeLine: true,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Enter your message',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    ),
  );
  }
}