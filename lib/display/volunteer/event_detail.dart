// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outagamie_emergency_management_app/classes/attendee.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/chat.dart';
import 'package:outagamie_emergency_management_app/models/events.dart';
import 'package:provider/provider.dart';

import '../../classes/event.dart';
import '../../classes/user.dart';
import '../../models/chat.dart';

class EventDetailWidget extends StatefulWidget {
  final Event event;
  final EventsModel model;
  final User user;
  const EventDetailWidget({super.key, required this.event, required this.model, required this.user});

  @override
  State<EventDetailWidget> createState() => _EventDetailWidgetState(event: event, model: model, user: user);
}
class _EventDetailWidgetState extends State<EventDetailWidget> {
  Event event;
  final EventsModel model;
  final User user;
  final f = DateFormat('yyyy-MM-dd');
  _EventDetailWidgetState({required this.event, required this.model, required this.user}){
    setEvent();
  }
  Future<void> setEvent() async {
    await model.getEvents().then((onValue){
      model.events.map((e) {
        if(e.id == event.id){
          setState(() {
            event = e;
            event.name = 'zzz';
          });
        }
      });
    });
  }

  String todToString(TimeOfDay time, {bool is24HourFormat = false}) {
  final hour = is24HourFormat ? time.hour : (time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod);
  final minute = time.minute.toString().padLeft(2, '0');
  return is24HourFormat
      ? '${time.hour.toString().padLeft(2, '0')}:$minute'
      : '$hour:$minute ${time.period == DayPeriod.am ? 'AM' : 'PM'}';
  }
  // Example event data
  List<Map<String, dynamic>> teamLeads = [
    {'name': 'John Doe', 'start': '10:00 AM', 'end': '12:00 PM'},
    {'name': 'Jane Smith', 'start': '12:00 PM', 'end': '02:00 PM'},
    {'name': 'Mike Johnson', 'start': '11:00 AM', 'end': '01:00 PM'},
  ];

  // List of roles for the dropdown
  List<String> roles = ['Volunteer', 'Team Leader', 'Coordinator'];

  String? selectedRole;
  TimeOfDay? startTimeInput;
  TimeOfDay? endTimeInput;

  // Function to handle Sign Up button
  void _showSignUpDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign Up"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      setState(() {
                        startTimeInput = time;
                      });
                    },
                    child: Text(startTimeInput == null
                        ? "Select Start Time"
                        : "Start: ${startTimeInput!.format(context)}"),
                  ),
                  TextButton(
                    onPressed: () async {
                      TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      setState(() {
                        endTimeInput = time;
                      });
                    },
                    child: Text(endTimeInput == null
                        ? "Select End Time"
                        : "End: ${endTimeInput!.format(context)}"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Dropdown for selecting a role
              DropdownButton<String>(
                hint: const Text("Select a Role"),
                value: selectedRole,
                items: event.roles.map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole = newValue;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                bool signUp = true;
                for (var att in event.attendees) {
                  if(att.firstName == user.firstName && att.lastName == user.lastName){
                    signUp = false;
                  }
                }
                if(signUp){
                  user.eventRecords.add(EventRecord(id: event.id, startTime: startTimeInput ?? TimeOfDay.now(), endTime: endTimeInput ?? TimeOfDay.now(), verified: false, date: event.date));
                  model.updateAttendence(user);
                  model.signUp(Attendee(role: selectedRole!, firstName: user.firstName, lastName: user.lastName), event.attendees.length, event).then((onValue){
                  setState(() async {
                  Event s = event;
                  await model.getEvents().then((onValue){
                    for (var e in model.events) {
                      if(e.id == event.id){
                          s = e;
                      }
                    }
                  });
                  event = s;
                });
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text("Submit"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _chat() async {
     await Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => ChangeNotifierProvider<ChatModel>(
                    create: (_) => ChatModel(), 
                    child: Consumer<ChatModel>(
                      builder: (context, model, child) =>
                          ChatWidget(model: model, user: widget.user, eventId: event.id, eventName: event.name,),
                    )),
                ),
              );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                event.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("Date: ${f.format(event.date)}"),
              Text("Time: ${todToString(event.startTime)} - ${todToString(event.endTime)}"),
              Text("Location: ${event.location}"),
              const SizedBox(height: 16),
              const Text(
                "Description:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(event.description),
              const SizedBox(height: 16),
              ...event.roles.map((s){
                return Column(
                  children: [
                    Text(s,style: const TextStyle(fontWeight: FontWeight.bold)),
                    ...event.attendees.map((att) {
                      if(att.role == s){
                        return ListTile(title: Text('${att.firstName} ${att.lastName}'));
                      }
                      return Container();
                    }),
                  ],
                );
                }),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showSignUpDialog();
                    },
                    child: const Text("Sign Up"),
                  ),
                  ElevatedButton(
                    onPressed: _chat,
                    child: const Text("Chat"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}