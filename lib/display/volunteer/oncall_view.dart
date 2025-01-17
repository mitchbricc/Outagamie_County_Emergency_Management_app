import 'package:flutter/material.dart';
import 'package:outagamie_emergency_management_app/classes/user.dart';
import 'package:outagamie_emergency_management_app/models/oncall.dart';

class OnCallWidget extends StatefulWidget {
  final OnCallModel model;
  final User user;
  const OnCallWidget({super.key, required this.model, required this.user});

@override
  State<OnCallWidget> createState() => _OnCallWidgetState();
}

class _OnCallWidgetState extends State<OnCallWidget> {
  late OnCallModel model;
  late User user;
  int pIndex = 0;

  @override
  void initState() {
    model = widget.model;
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return model.loaded ? Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('On-Call'),
      ),
      body: ListView.builder(
        itemCount: model.teamMembers.length,
        itemBuilder: (context, index) {
          final member = model.teamMembers[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(
                member['onCall'] ? Icons.check_circle : Icons.remove_circle,
                color: member['onCall'] ? Colors.green : Colors.red,
              ),
              title: Text(model.onCallPeople[pIndex++]),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${member['email']}'),
                  Text('Phone: ${member['phone']}'),
                  Text(member['onCall']
                      ? 'Status: On Call'
                      : 'Status: Not On Call'),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
    ) : const Text('Loading');
  }
}