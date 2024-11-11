import 'package:flutter/material.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/chat.dart';
/**
Name:Mitchell Bricco
Date:
Description: 
Reflection: 
*/
///
class EventDetailWidget extends StatefulWidget {
  const EventDetailWidget({super.key});

  @override
  State<EventDetailWidget> createState() => _EventDetailWidgetState();
}
class _EventDetailWidgetState extends State<EventDetailWidget> {
  // Example event data
  final String eventTitle = "Community Clean-up";
  final String eventDate = "2024-10-01";
  final String startTime = "10:00 AM";
  final String endTime = "02:00 PM";
  final String location = "Central Park";
  final String description =
      "Join us for a community clean-up event at Central Park. Help keep our city clean by picking up litter and improving the environment.";
  final List<Map<String, dynamic>> teamLeads = [
    {'name': 'John Doe', 'start': '10:00 AM', 'end': '12:00 PM'},
    {'name': 'Jane Smith', 'start': '12:00 PM', 'end': '02:00 PM'},
    {'name': 'Mike Johnson', 'start': '11:00 AM', 'end': '01:00 PM'},
  ];

  // List of roles for the dropdown
  final List<String> roles = ['Volunteer', 'Team Leader', 'Coordinator'];

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
              // Time range picker for user's availability
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
                items: roles.map((String role) {
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
                // Handle the form submission
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
                  builder: (context) => const ChatWidget(),
                ),
              );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(eventTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eventTitle,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text("Date: $eventDate"),
              Text("Time: $startTime - $endTime"),
              Text("Location: $location"),
              const SizedBox(height: 16),
              const Text(
                "Description:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(description),
              const SizedBox(height: 16),
              const Text(
                "Team Leads:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...teamLeads.map((lead) {
                return ListTile(
                  title: Text(lead['name']),
                  subtitle: Text(
                      "Time: ${lead['start']} - ${lead['end']}"),
                );
              }),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _showSignUpDialog,
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