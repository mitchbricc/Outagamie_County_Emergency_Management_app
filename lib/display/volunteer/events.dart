import 'package:flutter/material.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/event_detail.dart';
/**
Name:Mitchell Bricco
Date:
Description: 
Reflection: 
*/
///

class EventsWidget extends StatefulWidget {
  const EventsWidget({super.key});

  @override
  State<EventsWidget> createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget> {
  // Sample list of events
  final List<Map<String, dynamic>> events = [
    {
      'name': 'Community Clean-up',
      'date': '2024-10-01',
      'time': '10:00 AM',
      'location': 'Central Park',
      'volunteers': 15
    },
    {
      'name': 'Food Drive',
      'date': '2024-10-05',
      'time': '02:00 PM',
      'location': 'City Hall',
      'volunteers': 20
    },
    {
      'name': 'Charity Run',
      'date': '2024-10-10',
      'time': '09:00 AM',
      'location': 'Riverfront',
      'volunteers': 30
    },
    {
      'name': 'Tree Planting',
      'date': '2024-10-15',
      'time': '08:00 AM',
      'location': 'Greenwood Park',
      'volunteers': 25
    },
    {
      'name': 'Animal Shelter Volunteer',
      'date': '2024-10-20',
      'time': '11:00 AM',
      'location': 'Animal Shelter',
      'volunteers': 10
    },
  ];

  // List of events the user is signed up for (dummy example)
  final List<String> signedUpEvents = ['Food Drive', 'Charity Run'];

  // Boolean to toggle between all events and signed-up events
  bool showOnlySignedUp = false;

  // Method to navigate to event detail page
  Future<void> navigate(Map<String, dynamic> event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const EventDetailWidget(),
      ),
    );
  }

  // Method to toggle event view
  void toggleEventView() {
    setState(() {
      showOnlySignedUp = !showOnlySignedUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filtered list based on the toggle
    final filteredEvents = showOnlySignedUp
        ? events.where((event) => signedUpEvents.contains(event['name'])).toList()
        : events;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
        actions: [
          Row(
            children: [
              const Text('Show all events'),
              const SizedBox(width: 20),
              Switch(
                value: showOnlySignedUp,
                onChanged: (value) {
                  toggleEventView();
                },
                activeColor: Colors.white,
                inactiveThumbColor: Colors.grey,
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredEvents.length,
        itemBuilder: (context, index) {
          final event = filteredEvents[index];
          final isSignedUp = signedUpEvents.contains(event['name']);

          return ListTile(
            title: Text(
              event['name'],
              style: TextStyle(
                fontWeight: isSignedUp ? FontWeight.bold : FontWeight.normal,
                color: isSignedUp ? Colors.green : Colors.black,
              ),
            ),
            subtitle: Text(
              '${event['date']} at ${event['time']}\nLocation: ${event['location']}',
            ),
            trailing: Text('${event['volunteers']} Volunteers Needed'),
            tileColor: isSignedUp ? Colors.green[50] : null,
            onTap: () => navigate(event),
          );
        },
      ),
    );
  }
}
