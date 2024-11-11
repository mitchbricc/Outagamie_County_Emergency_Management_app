import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outagamie_emergency_management_app/classes/attendee.dart';
import 'package:outagamie_emergency_management_app/classes/event.dart';
import 'package:outagamie_emergency_management_app/classes/role.dart';
import 'package:outagamie_emergency_management_app/display/admin/event_detail.dart';
import 'package:outagamie_emergency_management_app/display/admin/create_event.dart';
import 'package:outagamie_emergency_management_app/models/events.dart';

import '../../classes/user.dart';
/**
Name:Mitchell Bricco
Date:
Description: 
Reflection: 
*/
///

class EventsWidget extends StatefulWidget {
  final EventsModel model;
  final User user;
  const EventsWidget({super.key, required this.model, required this.user});

  @override
  State<EventsWidget> createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget> {
  late EventsModel model;
  @override
  void initState() {
    model = widget.model;
    //model.addEvent(Event(id: "testid", name: "test event", date: DateTime.now(), startTime: TimeOfDay(hour: 1, minute: 11), endTime: TimeOfDay(hour: 1, minute: 11), location: "123 street st. appleton, WI", description: "this is a description", totalVolunteerHours: 0, category: "category 1", 
    //attendees: [Attendee(startTime: TimeOfDay.now(), endTime: TimeOfDay.now(), firstName: 'firstName', lastName: 'lastName')], roles: [Role(role: 'role 1', firstName: 'firstName', lastName: 'lastName')]));
    super.initState();
  }

  final List<String> signedUpEvents = ['Food Drive', 'Charity Run'];

  bool showOnlySignedUp = false;

  final f = DateFormat('yyyy-MM-dd');

  Future<void> navigate(Event event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EventDetailWidget(event: event),
      ),
    );
  }

  void toggleEventView() {
    setState(() {
      showOnlySignedUp = !showOnlySignedUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredEvents = model.events;
    // showOnlySignedUp
    //     ? model.events.where((event) => signedUpEvents.contains(event.name)).toList()
    //     : model.events.toList();

    return model.loaded ? Scaffold(
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
      body: body(filteredEvents),
    ) : const Text('Loading!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
  }

  Widget body(List<Event> filteredEvents) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              final event = filteredEvents[index];
              final isSignedUp = signedUpEvents.contains(event.name);
          
              return ListTile(
                title: Text(
                  event.name,
                  style: TextStyle(
                    fontWeight: isSignedUp ? FontWeight.bold : FontWeight.normal,
                    color: isSignedUp ? Colors.green : Colors.black,
                  ),
                ),
                subtitle: Text(
                  '${f.format(event.date)} at ${event.startTime}\nLocation: ${event.location}',
                ),
                trailing: Text('${event.totalVolunteerHours} Volunteers hours'),
                tileColor: isSignedUp ? Colors.green[50] : null,
                onTap: () => navigate(event),
              );
            },
          ),
        ),
        ElevatedButton(onPressed: () async {
          await Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const CreateEventWidget(),
                ),
              );
        }, child: const Text('Create Event')),
        const SizedBox(height: 25,)
      ],
    );
  }
}
