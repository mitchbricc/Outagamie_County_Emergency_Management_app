
// ignore_for_file: unused_element

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/attendee.dart';
import '../classes/event.dart';
import '../classes/user.dart';

class EventsModel extends ChangeNotifier {
  late User user; 
  final _db = FirebaseDatabase.instance.ref('events');
  List<Event> events = [];
  bool loaded = false;

  EventsModel() {
    getList();
    getEvents();
    _listenToEventChanges();
  }
  List<String> categories = [];
  Future<void> addCategory(String category) async {
    final catdb = FirebaseDatabase.instance.ref('categories');
    await getList();
    categories.add(category);
    try {
      await catdb.set(categories);
    } catch (e) {
      print("Failed to save list: $e");
    }
  }

  Future<void> deleteEvent(Event event) async {
    try {
      await _db.child(event.id).remove();
      events.remove(event);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteCat(String category) async {
    final catdb = FirebaseDatabase.instance.ref('categories');
    await getList();
    categories.remove(category);
    try {
      await catdb.set(categories);
    } catch (e) {
      print("Failed to save list: $e");
    }
  }

  Future<void> getList() async {
    try {
      final catdb = FirebaseDatabase.instance.ref('categories');
      final snapshot = await catdb.get();
      if (snapshot.exists) {
        List<dynamic> retrievedList = snapshot.value as List<dynamic>;
        categories = retrievedList.cast<String>();
      } else {
        print("No data available");
      }
    } catch (e) {
      print("Failed to retrieve list: $e");
    }
  }

  Future<List<Event>> getEvents() async {
  final DatabaseReference ref = FirebaseDatabase.instance.ref('events');
  final snapshot = await ref.get();

  if (snapshot.exists) {
    
    final Map<String, dynamic> eventData = Map<String, dynamic>.from(snapshot.value as Map);
    events = [];
    eventData.forEach((key, value) {
      events.add(Event.fromMap(Map<String, dynamic>.from(value)));
    });
    loaded = true;
    notifyListeners();
    return events;
  } else {
    loaded = true;
    notifyListeners();
    return [];
  }
}

  void _listenToEventChanges() {
    _db.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        events = [];
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
    await newEventRef.update(event.toMap());
  }

  Future<void> signUp(Attendee att, int index, Event event) async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref('events/${event.id}/attendees');
    await ref.update({index.toString() : att.toMap()});
  }

  String makeFirebaseKeySafe(String input) {
  final forbiddenCharacters = RegExp(r'[.$\[\]#/]');
  return input.replaceAll(forbiddenCharacters, '');
  }
  
  final _usersdb = FirebaseDatabase.instance.ref('users');
  Future<void> updateAttendence(User user) async {
    String key = makeFirebaseKeySafe(user.email);
    try {
      _usersdb.update({key:  user.toMap()});
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
