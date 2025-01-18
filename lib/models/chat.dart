import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../classes/chat.dart';


class ChatModel extends ChangeNotifier {
  late Chat chat;
  final _chatsdb = FirebaseDatabase.instance.ref('chats');
  bool isLoaded = false;

  ChatModel(){
    _listenToEventChanges();
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

  void _listenToEventChanges() {
    _chatsdb.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        getChat(chat.eventId, chat.eventName);
        // List<Chat> events = [];
        // events = data.entries.map((entry) {
        //   return Chat.fromMap(Map<String, dynamic>.from(entry.value));
        // }).toList();
        // events.forEach((c) {
        //   if(c.eventId == chat.eventId){
        //     chat = c;
        //   }
        // });
        
        notifyListeners();
      }
    });
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
