// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outagamie_emergency_management_app/models/feed.dart';

import '../../classes/user.dart'; 

class FeedWidget extends StatefulWidget {
  final FeedModel model;
  final User user;
  const FeedWidget({super.key, required this.model, required this.user});

  @override
  State<FeedWidget> createState() => _FeedWidgetState(model: model, user: user,);
}

class _FeedWidgetState extends State<FeedWidget> {
  final FeedModel model;
  final User user;
  _FeedWidgetState({required this.model, required this.user});
  final String eventId = 'feed';
  final String eventName = 'Feed';
  @override
  void initState() {
    super.initState();
    model.getChat(eventId,eventName).then((onValue){
      setState(() {
        
      });
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return model.isLoaded ? scaffold() : const Text('Loading');
  }

  Scaffold scaffold() {
    return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
        centerTitle: true,
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
      ],
    ),
  );
  }
}
