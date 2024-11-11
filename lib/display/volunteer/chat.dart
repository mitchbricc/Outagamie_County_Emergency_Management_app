import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
/**
Name:Mitchell Bricco
Date:
Description: 
Reflection: 
*/
///
class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final String eventName = "Community Clean-up";

  // List of chat messages
  final List<Map<String, dynamic>> messages = [
    {
      'name': 'John Doe',
      'message': 'Excited for the event!',
      'time': DateTime.now().subtract(const Duration(minutes: 15)),
    },
    {
      'name': 'Jane Smith',
      'message': 'Looking forward to helping out.',
      'time': DateTime.now().subtract(const Duration(minutes: 10)),
    },
    {
      'name': 'Mike Johnson',
      'message': 'What tools should we bring?',
      'time': DateTime.now().subtract(const Duration(minutes: 5)),
    },
  ];

  // Controller for the text input
  final TextEditingController _controller = TextEditingController();

  // Function to format date and time for display
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
  }

  // Function to handle sending a new message
  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        messages.add({
          'name': 'You', // Assuming the current user is "You"
          'message': _controller.text,
          'time': DateTime.now(),
        });
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eventName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message['name']),
                  subtitle: Text(
                      '${message['message']}\n${_formatDateTime(message['time'])}'),
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