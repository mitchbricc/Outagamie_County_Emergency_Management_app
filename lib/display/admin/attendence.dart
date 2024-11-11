import 'package:flutter/material.dart';

class AttendanceWidget extends StatefulWidget {
  const AttendanceWidget({super.key});

  @override
  State<AttendanceWidget> createState() => _AttendanceWidgetState();
}

class _AttendanceWidgetState extends State<AttendanceWidget> {
  List<Map<String, dynamic>> volunteers = [
    {
      'firstName': 'John',
      'lastName': 'Doe',
      'startTime': const TimeOfDay(hour: 9, minute: 0),
      'endTime': const TimeOfDay(hour: 12, minute: 0),
      'totalHours': 3,
      'submitted': false,
    },
    {
      'firstName': 'Jane',
      'lastName': 'Smith',
      'startTime': const TimeOfDay(hour: 8, minute: 30),
      'endTime': const TimeOfDay(hour: 11, minute: 45),
      'totalHours': 3.25,
      'submitted': false,
    },
    {
      'firstName': 'Michael',
      'lastName': 'Johnson',
      'startTime': const TimeOfDay(hour: 10, minute: 15),
      'endTime': const TimeOfDay(hour: 13, minute: 0),
      'totalHours': 2.75,
      'submitted': false,
    },
  ];

  bool showUnsubmittedOnly = false;
  String sortBy = 'firstName'; // Can be 'firstName' or 'lastName'

  // Sorting logic for volunteers
  void _sortVolunteers() {
    setState(() {
      if (sortBy == 'firstName') {
        volunteers.sort((a, b) => a['firstName'].compareTo(b['firstName']));
      } else {
        volunteers.sort((a, b) => a['lastName'].compareTo(b['lastName']));
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
          volunteers[index]['startTime'] = picked;
        } else {
          volunteers[index]['endTime'] = picked;
        }
        // Recalculate total hours
        volunteers[index]['totalHours'] = _calculateTotalHours(
          volunteers[index]['startTime'],
          volunteers[index]['endTime'],
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
      volunteers[index]['submitted'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredVolunteers = volunteers;
    if (showUnsubmittedOnly) {
      filteredVolunteers = filteredVolunteers
          .where((volunteer) => !volunteer['submitted'])
          .toList();
    }

    return Scaffold(
      body: Expanded(
        child: Column(
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
                  return Expanded(
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Expanded(
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
                                  if (volunteer['submitted'])
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
                                onPressed: volunteer['submitted']
                                    ? null
                                    : () {
                                        _submitHours(index);
                                      },
                                child: const Text('Submit Hours'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
