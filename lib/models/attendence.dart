import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/user.dart';


class AttendenceModel extends ChangeNotifier {
  final _usersdb = FirebaseDatabase.instance.ref('users');
  bool isLoaded = false;
  List<Map<String, dynamic>> volunteers = [];

  Future<void> updateAttendence(User user) async {
    String key = makeFirebaseKeySafe(user.email);
    try {
      _usersdb.update({key:  user.toMap()});
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  String makeFirebaseKeySafe(String input) {
  final forbiddenCharacters = RegExp(r'[.$\[\]#/]');
  return input.replaceAll(forbiddenCharacters, '');
}
String todToString(TimeOfDay time, {bool is24HourFormat = false}) {
  final hour = is24HourFormat ? time.hour : (time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod);
  final minute = time.minute.toString().padLeft(2, '0');
  return is24HourFormat
      ? '${time.hour.toString().padLeft(2, '0')}:$minute'
      : '$hour:$minute ${time.period == DayPeriod.am ? 'AM' : 'PM'}';
  }
Future<void> getVolunteers(String eventId) async {
  try {
       Map<String, dynamic> map = {};
       await _usersdb.get().then((snapshot) {
        map = Map<String, dynamic>.from(snapshot.value as Map);
      });
      map.forEach((key, value) async {
        User user = User.fromMap(jsonDecode(jsonEncode(map[key])));//await fetchUser(key);
        for (var event in user.eventRecords) {
          if(event.id == eventId){
            var map1 = user.toMap();
            // {
            //   'firstName': user.firstName,
            //   'lastName': user.lastName,
            // };
            var map2 = event.toMap();

            var map = {...map1,...map2};
            for (var e in user.eventRecords) {
              if(e.id == eventId){
                map['startTime'] = e.startTime;
                map['endTime'] = e.endTime;
              }
            }
             
            volunteers.add(map);
          }
        }
      });
      isLoaded = true;
      notifyListeners();
    } catch (e) {
      print(e);
    }
}

Future<User> fetchUser(String key) async {
  User user = User(eventRecords: [], email: 'email', password: 'not found', firstName: 'not found', lastName: 'not found', type: 'not found', phone: 'not found', salt: 'not found');
    try {
       Map<String, dynamic> map = {};
       await _usersdb.child(key).get().then((snapshot) {
        map = Map<String, dynamic>.from(snapshot.value as Map);
      });
      user = User.fromMap(map);
      notifyListeners();
    } catch (e) {
      print(e);
    }
    return user;
}

}
