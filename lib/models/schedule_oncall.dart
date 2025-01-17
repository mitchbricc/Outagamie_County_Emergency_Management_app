
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outagamie_emergency_management_app/classes/oncallschedule.dart';
import '../classes/user.dart';

class ScheduleOnCallModel extends ChangeNotifier {
  late User user; 
  List<String> onCallPeople = [];
  OnCallSchedule monthOnCallSchedule = OnCallSchedule(month: DateTime.now(), schedule: {});
  bool loaded = false;
  late Map<String, Color> peopleColor = <String, Color>{};
  List<Color> colors = [Colors.blue,Colors.red,Colors.green,Colors.purple,Colors.orange];
  Map<DateTime, Color> onCallSchedule = {};

  ScheduleOnCallModel() {  
    getSchedule();
  }


  Future<void> getSchedule() async {
    final DatabaseReference ref = FirebaseDatabase.instance.ref('oncall/people');
    final snapshot = await ref.get();

    if (snapshot.exists && snapshot.value is List) {
      onCallPeople = (snapshot.value as List).cast<String>();
    } else {
      print('No data available.');
    }
    for (var i = 0; i < colors.length && i < onCallPeople.length; i++) {
      peopleColor[onCallPeople[i]] = colors[i];
    }
    await getCurrentMonth(DateTime.now());

    loaded = true;
    notifyListeners();
  }

  // void _listenToEventChanges() {
  //   final _db = FirebaseDatabase.instance.ref('oncall/schedule');
  //   _db.onValue.listen((DatabaseEvent event) {
  //     final data = event.snapshot.value as Map?;
  //     if (data != null) {
  //       monthlySchedules = data.entries.map((entry) {
  //         return OnCallSchedule.fromMap(Map<String, dynamic>.from(entry.value));
  //       }).toList();
  //       notifyListeners();
  //     }
  //   });
  // }

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
          onCallSchedule[f2.parse(key)] = peopleColor[value] ?? Colors.pink[300]!;
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
