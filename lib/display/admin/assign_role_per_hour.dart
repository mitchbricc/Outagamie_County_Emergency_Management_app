import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AssignRolePerHourWidget extends StatefulWidget {
  final TimeOfDay eventStartTime;
  final TimeOfDay eventEndTime;

  const AssignRolePerHourWidget({super.key, 
    required this.eventStartTime,
    required this.eventEndTime,
  });

  @override
  State<AssignRolePerHourWidget> createState() => _AssignRolePerHourWidgetState();
}

class _AssignRolePerHourWidgetState extends State<AssignRolePerHourWidget> {
  List<DateTime> timeSlots = [];
  Map<DateTime, List<Map<String, int>>> roleAssignments = {};
  DateTime? firstSelected;
  DateTime? secondSelected;

  @override
  void initState() {
    super.initState();
    _generateTimeSlots();
  }

  void _generateTimeSlots() {
    // Generate the 15-minute increment times between event start and end times
    DateTime now = DateTime.now();
    DateTime startDateTime = DateTime(now.year, now.month, now.day,
        widget.eventStartTime.hour, widget.eventStartTime.minute);
    DateTime endDateTime = DateTime(now.year, now.month, now.day,
        widget.eventEndTime.hour, widget.eventEndTime.minute);

    DateTime current = startDateTime;
    while (current.isBefore(endDateTime)) {
      timeSlots.add(current);
      current = current.add(const Duration(minutes: 15));
    }
  }

  // Method to handle box clicks
  void _onBoxClick(DateTime timeSlot) {
    setState(() {
      if (firstSelected == null) {
        firstSelected = timeSlot;
      } else if (secondSelected == null) {
        secondSelected = timeSlot;
        _showRolePopup();
      } else {
        firstSelected = timeSlot;
        secondSelected = null;
      }
    });
  }

  // Check if a time slot is selected
  bool _isSelected(DateTime timeSlot) {
    if (firstSelected == null) return false;
    if (secondSelected == null) return timeSlot == firstSelected;
    return timeSlot.isAfter(firstSelected!) &&
        timeSlot.isBefore(secondSelected!) ||
        timeSlot == firstSelected ||
        timeSlot == secondSelected;
  }

  // Popup to add roles to the selected time range
  Future<void> _showRolePopup() async {
    String? selectedRole;
    int volunteerCount = 0;
    List<Map<String, int>> selectedRoles = [];

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Assign Roles'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                hint: const Text('Select Role'),
                items: ['General Volunteer', 'Driver', 'Greeter'].map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedRole = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Volunteers needed'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  volunteerCount = int.tryParse(value) ?? 0;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (selectedRole != null && volunteerCount > 0) {
                    selectedRoles.add({selectedRole!: volunteerCount});
                    setState(() {
                      for (DateTime time in _getSelectedRange()) {
                        if (!roleAssignments.containsKey(time)) {
                          roleAssignments[time] = [];
                        }
                        roleAssignments[time]!.addAll(selectedRoles);
                      }
                    });
                    Navigator.pop(context); 
                  }
                },
                child: const Text('Assign'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  List<DateTime> _getSelectedRange() {
    if (firstSelected == null || secondSelected == null) return [];
    DateTime start = firstSelected!.isBefore(secondSelected!)
        ? firstSelected!
        : secondSelected!;
    DateTime end = firstSelected!.isAfter(secondSelected!)
        ? firstSelected!
        : secondSelected!;
    return timeSlots
        .where((slot) => slot.isAfter(start) && slot.isBefore(end) || slot == start || slot == end)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Roles Per Hour'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                final timeSlot = timeSlots[index];
                bool isSelected = _isSelected(timeSlot);
                return GestureDetector(
                  onTap: () {
                    _onBoxClick(timeSlot);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(8),
                    color: isSelected ? Colors.blueAccent : Colors.grey[200],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DateFormat.jm().format(timeSlot)),
                        if (roleAssignments.containsKey(timeSlot))
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: roleAssignments[timeSlot]!.map((roleData) {
                              String role = roleData.keys.first;
                              int count = roleData.values.first;
                              return Text('$role: $count');
                            }).toList(),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    firstSelected = null;
                    secondSelected = null;
                  });
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Save changes logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Changes saved')));
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
