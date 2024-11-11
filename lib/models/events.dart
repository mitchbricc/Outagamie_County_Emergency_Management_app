import 'dart:collection';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/attendee.dart';
import '../classes/event.dart';
import '../classes/role.dart';
import '../classes/user.dart';
import 'dart:convert';

class EventsModel extends ChangeNotifier {
  late User user; 
  final _db = FirebaseDatabase.instance.ref('events');
  List<Event> events = [];
  bool loaded = false;

  EventsModel() {
    getEvents();
  }
  Future<List<Event>> getEvents() async {
  final DatabaseReference ref = FirebaseDatabase.instance.ref('events');
  final snapshot = await ref.get();

  if (snapshot.exists) {
    
    final Map<String, dynamic> eventData = Map<String, dynamic>.from(snapshot.value as Map);
    
    eventData.forEach((key, value) {
      events.add(Event.fromMap(Map<String, dynamic>.from(value)));
    });
    loaded = true;
    notifyListeners();
    return events;
  } else {
    print('No data available.');
    loaded = true;
    notifyListeners();
    return [];
  }
}

  // void _getEvents() async {
  //   print('getEvents');
  //   final snap = await _db.get();
  //   print('after get');
  //   for(dynamic c in snap.children){
  //     print(c.value);
  //     print(c.runtimeType);
  //     final s = c.value as String;//<Map<String, dynamic>>?;
  //     print(s);
  //     final map = parseEventString(s);
  //   print('after map');
  //   List<Event> l = [];
  //     for(dynamic key in l){
  //       print('before add');
  //       print(key);
  //       events.add(Event(id: "testid", name: "test event", date: DateTime.now(), startTime: TimeOfDay(hour: 1, minute: 11), endTime: TimeOfDay(hour: 1, minute: 11), location: "123 street st. appleton, WI", description: "this is a description", totalVolunteerHours: 0, category: "category 1", 
  //   attendees: [Attendee(startTime: TimeOfDay.now(), endTime: TimeOfDay.now(), firstName: 'firstName', lastName: 'lastName')], roles: [Role(role: 'role 1', firstName: 'firstName', lastName: 'lastName')]));
  //       print('affter add');
  //     }
  //   }
    
  //     loaded = true;
  //   print('loaded');
  //   notifyListeners();
  //   print('listening');
  //   _listenToEventChanges();
  // }

  void _listenToEventChanges() {
    _db.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        events = data.entries.map((entry) {
          return Event.fromMap(Map<String, dynamic>.from(entry.value));
        }).toList();
        notifyListeners();
      }
    });
  }

  Future<void> addEvent(Event event) async {
    final newEventRef = _db.push();
    event.id = newEventRef.key!;
    await newEventRef.set(event.toMap());
  }

}
