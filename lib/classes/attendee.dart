
class Attendee {
  String role;
  String firstName;
  String lastName;

  Attendee({
    required this.role,
    required this.firstName,
    required this.lastName,
  });

  factory Attendee.fromMap(Map<String, dynamic> map) {
    return Attendee(
      role: map['role'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
//   TimeOfDay startTime;
//   TimeOfDay endTime;
//   String firstName;
//   String lastName;

//   Attendee({
//     required this.startTime,
//     required this.endTime,
//     required this.firstName,
//     required this.lastName,
//   });

//   String _timeOfDayToString(TimeOfDay time) {
//     final hour = time.hour.toString().padLeft(2, '0');
//     final minute = time.minute.toString().padLeft(2, '0');
//     return '$hour:$minute';
//   }

//   TimeOfDay _stringToTimeOfDay(String timeString) {
//     final parts = timeString.split(':');
//     final hour = int.parse(parts[0]);
//     final minute = int.parse(parts[1]);
//     return TimeOfDay(hour: hour, minute: minute);
//   }

//   factory Attendee.fromMap(Map<String, dynamic> map) {
//     return Attendee(
//       startTime: map['startTime'] != null
//           ? TimeOfDay(
//               hour: int.parse(map['startTime'].split(':')[0]),
//               minute: int.parse(map['startTime'].split(':')[1]),
//             )
//           : TimeOfDay(hour: 0, minute: 0),
//       endTime: map['endTime'] != null
//           ? TimeOfDay(
//               hour: int.parse(map['endTime'].split(':')[0]),
//               minute: int.parse(map['endTime'].split(':')[1]),
//             )
//           : TimeOfDay(hour: 0, minute: 0),
//       firstName: map['firstName'] ?? '',
//       lastName: map['lastName'] ?? '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'startTime': _timeOfDayToString(startTime),
//       'endTime': _timeOfDayToString(endTime),
//       'firstName': firstName,
//       'lastName': lastName,
//     };
//   }
// }
