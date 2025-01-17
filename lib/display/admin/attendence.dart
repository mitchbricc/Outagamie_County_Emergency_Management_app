// ignore_for_file: no_logic_in_create_state, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:outagamie_emergency_management_app/models/attendence.dart';

import '../../classes/user.dart';

class AttendanceWidget extends StatefulWidget {
  final AttendenceModel model;
  final User user;
  final String eventId;
  final String eventName;
  const AttendanceWidget({super.key, required this.model, required this.user, required this.eventId, required this.eventName});

  @override
  State<AttendanceWidget> createState() => _AttendanceWidgetState(model: model, user: user, eventId: eventId);
}

class _AttendanceWidgetState extends State<AttendanceWidget> {
  @override
  void initState() {
    model.getVolunteers(eventId).then((onValue){
      setState(() {
        
      });
    });
    
    //model.updateAttendence(user);
    super.initState();
  }
  final AttendenceModel model;
  User user;
  final String eventId;
  _AttendanceWidgetState({required this.model, required this.user, required this.eventId});

  bool showUnsubmittedOnly = false;
  String sortBy = 'firstName'; // Can be 'firstName' or 'lastName'

  // Sorting logic for volunteers
  void _sortVolunteers() {
    setState(() {
      if (sortBy == 'firstName') {
        model.volunteers.sort((a, b) => a['firstName'].compareTo(b['firstName']));
      } else {
        model.volunteers.sort((a, b) => a['lastName'].compareTo(b['lastName']));
      }
    });
  }

  // Method to format time display
  String _formatTime(TimeOfDay time) {
    return time.format(context);
  }

  // Method to calculate total hours
  double _calculateTotalHours(TimeOfDay startTime, TimeOfDay endTime) {
    final startInMinutes = startTime.hour * 60 + startTime.minute;
    final endInMinutes = endTime.hour * 60 + endTime.minute;
    return (endInMinutes - startInMinutes) / 60.0;
  }

  // Show time picker to modify start or end time
  Future<void> _selectTime(
      BuildContext context, TimeOfDay initialTime, int index, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null && picked != initialTime) {
      setState(() {
        if (isStartTime) {
          model.volunteers[index]['startTime'] = picked;
        } else {
          model.volunteers[index]['endTime'] = picked;
        }
        // Recalculate total hours
        model.volunteers[index]['totalHours'] = _calculateTotalHours(
          model.volunteers[index]['startTime'],
          model.volunteers[index]['endTime'],
        );
      });
    }
  }

  // Toggle to show all volunteers or only those with unsubmitted hours
  void _toggleShowUnsubmitted() {
    setState(() {
      showUnsubmittedOnly = !showUnsubmittedOnly;
    });
  }

  // Submit hours for a volunteer
  void _submitHours(int index) {
    setState(() {
      model.volunteers[index]['verified'] = true;
    });
    User u = User.fromMap(model.volunteers[index]);
    u.eventRecords.forEach((r) {
      if(r.id == eventId){
        r.verified = true;
      }
    });
    u.countHours();
    model.updateAttendence(u);
  }

  @override
  Widget build(BuildContext context) {
    return model.isLoaded ? scaffold() : const Text('Loading!!!!!!!!!!!!!');
  }

  Scaffold scaffold() {
    List<Map<String, dynamic>> filteredVolunteers = model.volunteers;
    if (showUnsubmittedOnly) {
      filteredVolunteers = filteredVolunteers
          .where((volunteer) => !volunteer['verified'])
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventName),
      ),
    body: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            DropdownButton<String>(
              value: sortBy,
              items: const [
                DropdownMenuItem(value: 'firstName', child: Text('Sort by First Name')),
                DropdownMenuItem(value: 'lastName', child: Text('Sort by Last Name')),
              ],
              onChanged: (value) {
                setState(() {
                  sortBy = value!;
                  _sortVolunteers();
                });
              },
            ),
            Expanded(
              child: SwitchListTile(
                title: const Text('Show Unsubmitted Only'),
                value: showUnsubmittedOnly,
                onChanged: (value) {
                  _toggleShowUnsubmitted();
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredVolunteers.length,
            itemBuilder: (context, index) {
              final volunteer = filteredVolunteers[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Displaying volunteer details
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${volunteer['firstName']} ${volunteer['lastName']}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          if (volunteer['verified'])
                            const Text(
                              'Submitted',
                              style: TextStyle(color: Colors.green),
                            )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Start Time: ${_formatTime(volunteer['startTime'])}'),
                                Text('End Time: ${_formatTime(volunteer['endTime'])}'),
                                Text('Total Hours: ${volunteer['totalHours'].toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _selectTime(
                                      context, volunteer['startTime'], index, true),
                                  tooltip: 'Edit Start Time',
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _selectTime(
                                      context, volunteer['endTime'], index, false),
                                  tooltip: 'Edit End Time',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: volunteer['verified']
                            ? null
                            : () {
                                _submitHours(index);
                              },
                        child: const Text('Submit Hours'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
  }
}
