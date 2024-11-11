import 'package:flutter/material.dart';

class ContactInfoWidget extends StatefulWidget {
  const ContactInfoWidget({super.key});

@override
  State<ContactInfoWidget> createState() => _ContactInfoWidgetState();
}

class _ContactInfoWidgetState extends State<ContactInfoWidget> {
  // List of people with contact and volunteer info
  List<Map<String, dynamic>> people = [
    {
      'firstName': 'John',
      'lastName': 'Doe',
      'email': 'john.doe@example.com',
      'phone': '555-1234',
      'hoursVolunteered': 25,
      'points': 50
    },
    {
      'firstName': 'Jane',
      'lastName': 'Smith',
      'email': 'jane.smith@example.com',
      'phone': '555-5678',
      'hoursVolunteered': 30,
      'points': 75
    },
    {
      'firstName': 'Mike',
      'lastName': 'Johnson',
      'email': 'mike.johnson@example.com',
      'phone': '555-8765',
      'hoursVolunteered': 20,
      'points': 60
    },
    {
      'firstName': 'Emily',
      'lastName': 'Williams',
      'email': 'emily.williams@example.com',
      'phone': '555-2345',
      'hoursVolunteered': 40,
      'points': 90
    },
    {
      'firstName': 'David',
      'lastName': 'Brown',
      'email': 'david.brown@example.com',
      'phone': '555-3456',
      'hoursVolunteered': 15,
      'points': 45
    },
  ];

  // Sort criteria
  String _sortBy = 'firstName';

  // Sort the list based on selected criteria
  void _sortList(String criterion) {
    setState(() {
      _sortBy = criterion;
      if (criterion == 'firstName') {
        people.sort((a, b) => a['firstName'].compareTo(b['firstName']));
      } else if (criterion == 'lastName') {
        people.sort((a, b) => a['lastName'].compareTo(b['lastName']));
      } else if (criterion == 'hoursVolunteered') {
        people.sort((a, b) => b['hoursVolunteered'].compareTo(a['hoursVolunteered']));
      } else if (criterion == 'points') {
        people.sort((a, b) => b['points'].compareTo(a['points']));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Info'),
      ),
      body: Column(
        children: [
          // Sort options
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sort by'),
                DropdownButton<String>(
                  value: _sortBy,
                  items: const [
                    DropdownMenuItem(value: 'firstName', child: Text('First Name')),
                    DropdownMenuItem(value: 'lastName', child: Text('Last Name')),
                    DropdownMenuItem(value: 'hoursVolunteered', child: Text('Hours Volunteered')),
                    DropdownMenuItem(value: 'points', child: Text('Points')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      _sortList(value);
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: people.length,
              itemBuilder: (context, index) {
                final person = people[index];
                return ListTile(
                  title: Text('${person['firstName']} ${person['lastName']}'),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${person['email']}'),
                      const SizedBox(width: 20,),
                      Text('Phone: ${person['phone']}'),
                      const SizedBox(width: 20,),
                      Text('Hours Volunteered: ${person['hoursVolunteered']}'),
                      const SizedBox(width: 20,),
                      Text('Points: ${person['points']}'),
                    ],
                  ),
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
