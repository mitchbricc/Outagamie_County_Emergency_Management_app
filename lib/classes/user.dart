// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class User {
   String email;
   String password;
   String firstName;
   String lastName;
   String type;
   String phone;
   String salt;
  late int points;
  late double totalHours;
  late List<EventRecord> eventRecords;
  bool isApproved = false;


  User({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.type,
    required this.phone,
    required this.salt,
    required this.eventRecords,
    int? points,
    double? totalHours,
    bool? isApproved
  }){
    // this.eventRecords = eventRecords ?? [];
    this.totalHours = totalHours ?? 0.0;
    this.points = points ?? 0;
    if(eventRecords.isNotEmpty){
      countHours();
    }
    this.isApproved = isApproved ?? false;
  }

  factory User.fromMap(Map<String,dynamic> map){
    List<EventRecord> list = [];
    var ermap = map['eventRecords'] ?? [];
    var l = ermap as List<dynamic>;
    l.forEach((record) {
            list.add(EventRecord.fromMap(Map<String, dynamic>.from(record)));
    },);
    User r = User(
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      type: map['type'] ?? '',
      phone: map['phone'] ?? '',
      salt: map['salt'] ?? '',
      eventRecords: [],
      points: map['points'] ?? 0,
      totalHours: map['totalHours'] ?? 0.0,
      isApproved: map['isApproved'] ?? false,
    );
    r.eventRecords = list;
    r.countHours();
    return r;
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
      'type': type,
      'phone': phone,
      'salt': salt,
      'eventRecords': eventRecords.map((record) => record.toMap()).toList(),
      'points' : points,
      'totalHours' : totalHours,
      'isApproved' : isApproved
    };
  }

  void countHours(){
    totalHours = 0;
    points = 0;
    if(eventRecords.isNotEmpty){
      eventRecords.forEach((r) {
        if(r.verified){
          if(totalHours > .25){
          totalHours += r.totalHours;
          }
        }
      });
    }
    points = (totalHours/3).floor();
  }
}
class EventRecord {
  String id;
  TimeOfDay startTime;
  TimeOfDay endTime;
  double totalHours = 0;
  bool verified;
  DateTime date;
  EventRecord({required this.id,required this.startTime, required this.endTime, double? totalHours, required this.verified, required this.date}){
    int startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = endTime.hour * 60 + endTime.minute;
    int differenceInMinutes = endMinutes - startMinutes;
    totalHours = differenceInMinutes / 60.0;

  }

  factory EventRecord.fromMap(Map<String, dynamic> map) {
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
    EventRecord result = EventRecord(
      id: map['id'].toString(),
      date: DateTime.parse(map['date']),
      startTime: st,
      endTime: et,
      totalHours: (map['totalHours'] ?? 0.0).toDouble(),
      verified: map['verified'] ?? false,

    );
    return result;
  }

  final f = DateFormat('yyyy-MM-dd');
  String todToString(TimeOfDay time, {bool is24HourFormat = false}) {
  final hour = is24HourFormat ? time.hour : (time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod);
  final minute = time.minute.toString().padLeft(2, '0');
  return is24HourFormat
      ? '${time.hour.toString().padLeft(2, '0')}:$minute'
      : '$hour:$minute ${time.period == DayPeriod.am ? 'AM' : 'PM'}';
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'date': f.format(date),
      'startTime': todToString(startTime),
      'endTime': todToString(endTime),
      'totalHours': totalHours,
      'verified': verified,
    };
  }
}
