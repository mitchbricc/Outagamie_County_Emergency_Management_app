
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outagamie_emergency_management_app/classes/oncallschedule.dart';
import '../classes/user.dart';

class ScheduleOnCallModel extends ChangeNotifier {
  late User user; 
  List<User> people = [];
  List<String> onCallPeople = [];
  OnCallSchedule monthOnCallSchedule = OnCallSchedule(month: DateTime.now(), schedule: {});
  bool loaded = false;
  late Map<String, Color> peopleColor = <String, Color>{};
  List<Color> colors = [];
  Map<DateTime, Color> onCallSchedule = {};

  ScheduleOnCallModel() {  
    getSchedule();
    _listenToEventChanges();

  }

  Future<void> getPeople() async {
  try {
    final usersdb = FirebaseDatabase.instance.ref('users');
       Map<String, dynamic> map = {};
       await usersdb.get().then((snapshot) {
        map = Map<String, dynamic>.from(snapshot.value as Map);
        people = [];
        map.forEach((key, value) async {
        User user = User.fromMap(jsonDecode(jsonEncode(map[key])));
        if(user.type == 'admin'){
          people.add(user);
        }

        });
        notifyListeners();
      });
    } catch (e) {
      print(e);
    }

}

  Future<void> getSchedule() async {
    await getPeople();
    onCallPeople = [];
    for(int i = 0;i < people.length;i++){
      onCallPeople.add('${people[i].firstName} ${people[i].lastName}');
    }
    _generateColors(onCallPeople.length+1);
    int i;
    for (i = 0; i < colors.length && i < onCallPeople.length; i++) {
      peopleColor[onCallPeople[i]] = colors[i];
    }
    peopleColor['other'] = colors[i];
    await getCurrentMonth(DateTime.now());
    
    loaded = true;
    notifyListeners();
  }

  void _generateColors(int count) {
    final int startingIndex = colors.length;
    for (int i = 0; i < count; i++) {
      double hue = (startingIndex + i) * 137.50776405 % 360; // Golden angle approximation
      colors.add(HSVColor.fromAHSV(1.0, hue, 0.8, 0.8).toColor());
    }
  }

  void _listenToEventChanges() {
    final db = FirebaseDatabase.instance.ref('oncall/schedule');
    db.onValue.listen((DatabaseEvent event) {
      loaded = false;
      getSchedule();
      notifyListeners();
    });
  }

  Future<void> addMonthlySchedule(DateTime date) async {
    Map<String,String> map = {};
    onCallSchedule.forEach((key, value){
      var name = peopleColor.keys.firstWhere(
        (k) => peopleColor[k] == value, orElse: () => 'null');
        final f = DateFormat('yyyy-MM-dd');
        map[f.format(key)] = name;
    });
    OnCallSchedule schedule = OnCallSchedule(month: date, schedule: map);
    final db = FirebaseDatabase.instance.ref('oncall/schedule');
    await db.update({schedule.getMonth():schedule.toMap()});
  }

  Future<void> getCurrentMonth(DateTime date) async {
    onCallSchedule = {};
    final DatabaseReference ref = FirebaseDatabase.instance.ref('oncall/schedule');
    final f = DateFormat('yyyy-MM');
    final snapshot = await ref.child(f.format(date)).get();

    if (snapshot.exists) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(snapshot.value as Map);
      monthOnCallSchedule = OnCallSchedule.fromMap((Map<String, dynamic>.from(data)));
      final f2 = DateFormat('yyyy-MM-dd');
      monthOnCallSchedule.schedule.forEach((key, value){
          onCallSchedule[f2.parse(key)] = peopleColor[value] ?? colors[people.length];
        });
    } else {
      onCallSchedule = {};
    }

    loaded = true;
    notifyListeners();
  }

  Future<void> setUpDB() async {
    final db = FirebaseDatabase.instance.ref('oncall');
    final newRef = db.child('schedule');
    final f = DateFormat('yyyy-MM-dd');
    print(f.format(DateTime.now()));
    final schedule = OnCallSchedule(month: DateTime.now(),schedule: {f.format(DateTime.now()): 'create account'});
    final schedule2 = OnCallSchedule(month: f.parse('2025-01-01'),schedule: {f.format(f.parse('2025-01-01')): 'create account'});
    final f2 = DateFormat('yyyy-MM');
    Map<String,dynamic> map2 = {
      f2.format(schedule.month) : schedule.toMap(),
      f2.format(schedule2.month) : schedule2.toMap(),
    };
    newRef.update(map2);
  }

}
