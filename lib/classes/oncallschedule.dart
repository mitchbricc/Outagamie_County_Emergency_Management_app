import 'package:intl/intl.dart';

class OnCallSchedule {
  DateTime month;
  Map<String, String> schedule; // Key: Date in 'yyyy-MM-dd', Value: Person's name

  OnCallSchedule({
    required this.month,
    required this.schedule,
  });

  factory OnCallSchedule.fromMap(Map<String, dynamic> map) {
    return OnCallSchedule(
      month: DateTime.parse(map['month'] as String),
      schedule: Map<String, String>.from(map['onCallForDays'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'month': month.toIso8601String(),
      'onCallForDays': schedule,
    };
  }

  String getMonth(){
    final f = DateFormat('yyyy-MM');
    return f.format(month);
  }
}
