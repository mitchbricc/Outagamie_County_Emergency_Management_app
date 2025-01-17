import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/chat.dart';
import '../classes/event.dart';
import '../classes/user.dart';


class ReportCreationModel extends ChangeNotifier {
  late Chat chat;
  final _chatsdb = FirebaseDatabase.instance.ref('chats');
  bool isLoaded = false;
  List<Event> events = [];

  ReportCreationModel(){
    getEvents();
  }
  bool isReady = false;
  final _usersdb = FirebaseDatabase.instance.ref('users');
  List<Map<String, dynamic>> volunteers = [];

  double _calculateTotalHours(TimeOfDay startTime, TimeOfDay endTime) {
    final startInMinutes = startTime.hour * 60 + startTime.minute;
    final endInMinutes = endTime.hour * 60 + endTime.minute;
    return (endInMinutes - startInMinutes) / 60.0;
  }

  Future<double> getTotalHours(String eventId) async {
    double totalHours = 0;
  try {
       Map<String, dynamic> map = {};
       await _usersdb.get().then((snapshot) {
        map = Map<String, dynamic>.from(snapshot.value as Map);
      });
      map.forEach((key, value) async {
        
        User user = User.fromMap(jsonDecode(jsonEncode(map[key])));//await fetchUser(key);
        for (var event in user.eventRecords) {
          if(event.id == eventId){
            for (var e in user.eventRecords) {
              if(e.id == eventId){
                var t = _calculateTotalHours(e.startTime,e.endTime);
                totalHours += t;
              }
            }
             
            volunteers.add(map);
          }
        }
      });
      //isLoaded = true;
      notifyListeners();
    } catch (e) {
      print(e);
    }
    return totalHours;
  }

  Future<List<Event>> getEvents() async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref('events');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      
      final Map<String, dynamic> eventData = Map<String, dynamic>.from(snapshot.value as Map);
      
      eventData.forEach((key, value) {
        events.add(Event.fromMap(Map<String, dynamic>.from(value)));
      });
      isLoaded = true;
      notifyListeners();
      return events;
    } else {
      isLoaded = true;
      notifyListeners();
      return [];
    }
  }

  Future<void> getChat(String eventId, String eventName) async {
    try {
      
       Map<String, dynamic> map = {};
       await _chatsdb.child(eventId).get().then((snapshot) async {
        if(!snapshot.exists){
          await updateChat(Chat(eventName: eventName, eventId: eventId, messages: []));
          await getChat(eventId, eventName);
          return;
        }
        map = Map<String, dynamic>.from(snapshot.value as Map);
      });
      chat = Chat.fromMap(map);
      notifyListeners();
    } catch (e) {
      print(e);
    }
    isLoaded = true;
  }

  Future<void> updateChat(Chat chat) async {

    try {
      _chatsdb.update({chat.eventId :  chat.toMap()});
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

}
