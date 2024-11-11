import 'package:flutter/material.dart';

class OnCallWidget extends StatefulWidget {
  const OnCallWidget({super.key});

@override
  State<OnCallWidget> createState() => _OnCallWidgetState();
}

class _OnCallWidgetState extends State<OnCallWidget> {
  // List of team members with their info and on-call status
  final List<Map<String, dynamic>> teamMembers = [
    {
      'firstName': 'John',
      'lastName': 'Doe',
      'email': 'john.doe@example.com',
      'phone': '555-1234',
      'onCall': true,
    },
    {
      'firstName': 'Jane',
      'lastName': 'Smith',
      'email': 'jane.smith@example.com',
      'phone': '555-5678',
      'onCall': false,
    },
    {
      'firstName': 'Mike',
      'lastName': 'Johnson',
      'email': 'mike.johnson@example.com',
      'phone': '555-8765',
      'onCall': false,
    },
    {
      'firstName': 'Emily',
      'lastName': 'Williams',
      'email': 'emily.williams@example.com',
      'phone': '555-2345',
      'onCall': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('On-Call'),
      ),
      body: ListView.builder(
        itemCount: teamMembers.length,
        itemBuilder: (context, index) {
          final member = teamMembers[index];
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(
                member['onCall'] ? Icons.check_circle : Icons.remove_circle,
                color: member['onCall'] ? Colors.green : Colors.red,
              ),
              title: Text('${member['firstName']} ${member['lastName']}'),
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
    );
  }
}