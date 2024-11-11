import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date

class FeedWidget extends StatefulWidget {
  const FeedWidget({super.key});

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  // List of feed messages (reminders and information)
  final List<Map<String, dynamic>> feedMessages = [
    {
      'from': 'Event Coordinator',
      'message': "Don't forget the Community Clean-up event this Saturday!",
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'from': 'Volunteer Manager',
      'message': 'We still need 5 more volunteers for the Food Drive next week.',
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'from': 'Coordinator Jane',
      'message': 'Tree planting event is rescheduled to next Friday due to rain.',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
    },
    {
      'from': 'Team Leader Mike',
      'message': 'Great job on the Charity Run! Thanks to everyone who participated!',
      'date': DateTime.now().subtract(const Duration(hours: 12)),
    },
    {
      'from': 'Organizer Emily',
      'message': 'Reminder: Animal Shelter volunteering this Sunday at 11:00 AM.',
      'date': DateTime.now().subtract(const Duration(days: 3)),
    },
  ];

  // Function to format date for display
  String _formatDate(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
  }

  // Boolean to track whether the input field is shown
  bool _isPostingMessage = false;

  // Controller for the message input field
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
      ),
      body: Column(
        children: [
          // Scrollable list of feed messages
          Expanded(
            child: ListView.builder(
              itemCount: feedMessages.length,
              itemBuilder: (context, index) {
                final message = feedMessages[index];
                return ListTile(
                  title: Text(message['from']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(message['message']),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(message['date']),
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                );
              },
            ),
          ),
          // Show text field for message posting or button
          _isPostingMessage
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your message...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          if (_messageController.text.isNotEmpty) {
                            setState(() {
                              feedMessages.add({
                                'from': 'You', // Change this to reflect the actual user
                                'message': _messageController.text,
                                'date': DateTime.now(),
                              });
                              _messageController.clear();
                              _isPostingMessage = false; // Hide the input field after posting
                            });
                          }
                        },
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isPostingMessage = true;
                      });
                    },
                    child: const Text('Post Message'),
                  ),
                ),
        ],
      ),
    );
  }
}
