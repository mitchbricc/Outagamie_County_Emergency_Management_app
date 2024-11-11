import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleOnCallWidget extends StatefulWidget {
  const ScheduleOnCallWidget({super.key});

  @override
  State<ScheduleOnCallWidget> createState() => _ScheduleOnCallWidgetState();
}

class _ScheduleOnCallWidgetState extends State<ScheduleOnCallWidget> {
  DateTime currentMonth = DateTime.now(); // Start on the current month

  // Mock on-call people and their associated colors
  final Map<String, Color> onCallPeople = {
    'Person 1': Colors.blue,
    'Person 2': Colors.red,
    'Person 3': Colors.green,
    'Person 4': Colors.purple,
  };

  // Color for the logged-in user
  final Color userColor = Colors.orange;

  // Calendar data to track the on-call person by date
  final Map<DateTime, Color> onCallSchedule = {};

  // Function to generate the list of days in the current month
  List<Widget> _buildCalendarDays() {
    List<Widget> days = [];
    DateTime firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    DateTime lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);

    // Adding empty containers for the days before the first day of the month to align the calendar
    for (int i = 0; i < firstDayOfMonth.weekday - 1; i++) {
      days.add(Container()); // Empty containers for padding
    }

    // Adding actual days of the month
    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      DateTime currentDate = DateTime(currentMonth.year, currentMonth.month, day);
      Color dayColor = onCallSchedule[currentDate] ?? Colors.grey[300]!; // Default color if no one is on call
      days.add(
        GestureDetector(
          onTap: () {
            setState(() {
              onCallSchedule[currentDate] = userColor; // Set the color to the user's color when tapped
            });
          },
          child: Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: dayColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day.toString(),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return days;
  }

  // Method to move to the previous month
  void _goToPreviousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
    });
  }

  // Method to move to the next month
  void _goToNextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedMonth = DateFormat('MMMM yyyy').format(currentMonth);

    final List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('On-Call Schedule'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goToPreviousMonth,
              ),
              Text(
                formattedMonth,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _goToNextMonth,
              ),
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: daysOfWeek
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 5),

          Expanded(
            child: GridView.count(
              crossAxisCount: 7,
              children: _buildCalendarDays(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Legend:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ...onCallPeople.entries.map((entry) {
                  return Row(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        color: entry.value,
                      ),
                      const SizedBox(width: 8),
                      Text(entry.key),
                    ],
                  );
                }),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: 16,
                      height: 16,
                      color: userColor,
                    ),
                    const SizedBox(width: 8),
                    const Text('Your schedule'),
                  ],
                ),
              ],
            ),
          ),

          // Save changes button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Updating Schedule'),
              ),
            );
              },
              child: const Text('Save changes'),
            ),
          ),
        ],
      ),
    );
  }
}

