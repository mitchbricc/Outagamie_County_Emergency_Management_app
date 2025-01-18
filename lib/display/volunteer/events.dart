import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/event_detail.dart';
import 'package:provider/provider.dart';

import '../../classes/event.dart';
import '../../classes/user.dart';
import '../../models/events.dart';
class EventsWidget extends StatefulWidget {
  final EventsModel model;
  final User user;
  const EventsWidget({super.key, required this.model, required this.user});

  @override
  State<EventsWidget> createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget> {
  late EventsModel model;
  @override
  void initState() {
    model = widget.model;
    super.initState();
  }

  final List<String> signedUpEvents = [];

  bool showOnlySignedUp = false;

  final f = DateFormat('yyyy-MM-dd');

  Future<void> navigate(Event event) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ChangeNotifierProvider<EventsModel>(
        create: (_) => EventsModel(), 
        child: Consumer<EventsModel>(
          builder: (context, model, child) =>
              EventDetailWidget(event: event, model: model, user: widget.user), 
        )),
      ),
    );
  }

  void toggleEventView() {
    setState(() {
      showOnlySignedUp = !showOnlySignedUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    //final filteredEvents = model.events;
    for(int i = 0; i < widget.user.eventRecords.length;i++){
      signedUpEvents.add(widget.user.eventRecords[i].id);
    }
    final filteredEvents = showOnlySignedUp
        ? model.events.where((event) => signedUpEvents.contains(event.id)).toList()
        : model.events.toList();

    return model.loaded ? Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Events'),
        
        actions: [
          Row(
            children: [
              const Text('Show all events'),
              const SizedBox(width: 20),
              Switch(
                value: showOnlySignedUp,
                onChanged: (value) {
                  toggleEventView();
                },
                activeColor: Colors.white,
                inactiveThumbColor: Colors.grey,
              ),
            ],
          ),
        ],
      ),
      body: body(filteredEvents),
    ) : const Text('Loading!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
  }

  Widget body(List<Event> filteredEvents) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              final event = filteredEvents[index];
              final isSignedUp = signedUpEvents.contains(event.id);
          
              return ListTile(
                title: Text(
                  event.name,
                  style: TextStyle(
                    fontWeight: isSignedUp ? FontWeight.bold : FontWeight.normal,
                    color: isSignedUp ? Colors.green : Colors.black,
                  ),
                ),
                subtitle: Text(
                  '${f.format(event.date)} at ${event.startTime.format(context)}\nLocation: ${event.location}',
                ),
                trailing: SizedBox(
                  width: 200.0,
                  child: Row(
                    children: [
                      Text('${event.totalVolunteerHours - event.attendees.length} needed Volunteers'),
                      
                    ],
                  ),
                ),
                tileColor: isSignedUp ? Colors.green[50] : null,
                onTap: () => navigate(event),
              );
            },
          ),
        ),
      ],
    );
  }
}
