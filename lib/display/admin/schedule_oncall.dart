import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outagamie_emergency_management_app/classes/user.dart';
import 'package:outagamie_emergency_management_app/models/schedule_oncall.dart';

class ScheduleOnCallWidget extends StatefulWidget {
  final ScheduleOnCallModel model;
  final User user;
  const ScheduleOnCallWidget({super.key, required this.model, required this.user});

  @override
  State<ScheduleOnCallWidget> createState() => _ScheduleOnCallWidgetState();
}

class _ScheduleOnCallWidgetState extends State<ScheduleOnCallWidget> {
  DateTime currentMonth = DateTime.now(); 
  late ScheduleOnCallModel model;
  late User user;


  @override
  void initState() {
    model = widget.model;
    user = widget.user;
    super.initState();
  }
  final Color userColor = Colors.orange;

  List<Widget> _buildCalendarDays() {
    List<Widget> days = [];
    DateTime firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    DateTime lastDayOfMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0);

    for (int i = 0; i < firstDayOfMonth.weekday - 1; i++) {
      days.add(Container()); 
    }

    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      DateTime selectedDate = DateTime(currentMonth.year, currentMonth.month, day);
      Color dayColor = model.onCallSchedule[selectedDate] ?? Colors.grey[300]!; 
      days.add(
        GestureDetector(
          onTap: () {
            setState(() {
              model.onCallSchedule[selectedDate] = model.peopleColor['${user.firstName} ${user.lastName}'] as Color; 
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

  void _goToPreviousMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month - 1);
      model.getCurrentMonth(currentMonth);
    });
  }

  void _goToNextMonth() {
    setState(() {
      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1);
      model.getCurrentMonth(currentMonth);
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedMonth = DateFormat('MMMM yyyy').format(currentMonth);

    final List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return model.loaded ? Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
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
                ...model.peopleColor.entries.map((entry) {
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
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                model.addMonthlySchedule(currentMonth);
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
    )  : const Text('Loading');
  }
}

