
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outagamie_emergency_management_app/classes/attendee.dart';

class Event {
  String id;
   String name;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String location;
  final String description;
  final int totalVolunteerHours;
  final String category;
  List<Attendee> attendees;
  List<String> roles;

  Event({
    required this.id,
    required this.name,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.description,
    required this.totalVolunteerHours,
    required this.category,
    required this.attendees,
    required this.roles,
  }){
    if(roles.isEmpty){
      roles.add('general');
    }
  }

  factory Event.fromMap(Map<String, dynamic> map) {
    final parts = map['startTime'].split(RegExp(r'[: ]'));
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final period = parts[2].toUpperCase() == 'AM' ? DayPeriod.am : DayPeriod.pm;
    TimeOfDay st = TimeOfDay(hour: period == DayPeriod.am ? hour % 12 : hour % 12 + 12, minute: minute);
    
    final parts2 = map['startTime'].split(RegExp(r'[: ]'));
    final hour2 = int.parse(parts2[0]);
    final minute2 = int.parse(parts2[1]);
    final period2 = parts2[2].toUpperCase() == 'AM' ? DayPeriod.am : DayPeriod.pm;
    TimeOfDay et = TimeOfDay(hour: period2 == DayPeriod.am ? hour2 % 12 : hour2 % 12 + 12, minute: minute2);
    List<Attendee> att = [];
    if(map['attendees'] != null){
      final List<dynamic> attendeesData = map['attendees'] as List<dynamic>;
      att = attendeesData.map((attendeeData) {
      return Attendee.fromMap(Map<String, dynamic>.from(attendeeData));
    }).toList();
    }
    Event result = Event(
      id: map['id'].toString(),
      name: map['name'],
      date: DateTime.parse(map['date']),
      startTime: st,
      endTime: et,
      location: map['location'],
      description: map['description'],
      totalVolunteerHours: map['totalVolunteerHours'],
      category: map['category'],
      attendees: att,//List<Map<String, dynamic>>.from(map['attendees'] ?? []),
      roles: List<String>.from(map['roles']),//List<Map<String, String>>.from(map['roles'] ?? []),
    );
    if(result.roles.isEmpty){
      result.roles.add('general');
    }
    return result;
  }

  String todToString(TimeOfDay time, {bool is24HourFormat = false}) {
  final hour = is24HourFormat ? time.hour : (time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod);
  final minute = time.minute.toString().padLeft(2, '0');
  return is24HourFormat
      ? '${time.hour.toString().padLeft(2, '0')}:$minute'
      : '$hour:$minute ${time.period == DayPeriod.am ? 'AM' : 'PM'}';
  }

final f = DateFormat('yyyy-MM-dd');
  Map<String, dynamic> toMap() {
    List<Map<String,dynamic>> att = [];
    for(Attendee a in attendees){
      att.add(a.toMap());
    }
    return {
      'id' : id,
      'name': name,
      'date': f.format(date),
      'startTime': todToString(startTime),
      'endTime': todToString(endTime),
      'location': location,
      'description': description,
      'totalVolunteerHours': totalVolunteerHours,
      'category': category,
      'attendees': att,
      'roles': roles,
    };
  }
}
