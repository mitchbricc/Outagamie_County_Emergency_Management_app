import 'package:flutter/material.dart';
import 'package:outagamie_emergency_management_app/models/contact_info.dart';

import '../../classes/user.dart';

class ContactInfoWidget extends StatefulWidget {
  final ContactInfoModel model;
  final User user;
  const ContactInfoWidget({super.key, required this.model, required this.user});

@override
  State<ContactInfoWidget> createState() => _ContactInfoWidgetState();
}

class _ContactInfoWidgetState extends State<ContactInfoWidget> {

  String _sortBy = 'firstName';
  late ContactInfoModel model;
  late User user;
  @override
  void initState() {
    model = widget.model;
    user = widget.user;
    model.getVolunteers();
    super.initState();
  }

  void _sortList(String criterion) {
    setState(() {
      _sortBy = criterion;
      if (criterion == 'firstName') {
        model.people.sort((a, b) => a.firstName.compareTo(b.firstName));
      } else if (criterion == 'lastName') {
        model.people.sort((a, b) => a.lastName.compareTo(b.lastName));
      } else if (criterion == 'hoursVolunteered') {
        model.people.sort((a, b) => b.totalHours.compareTo(a.totalHours));
      } else if (criterion == 'points') {
        model.people.sort((a, b) => b.points.compareTo(a.points));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return model.isLoaded ? scaffold() : const Text('Loading!!!!!!!!!!');
  }

  Scaffold scaffold() {
    return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: const Text('Contact Info'),
    ),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Sort by'),
              DropdownButton<String>(
                value: _sortBy,
                items: const [
                  DropdownMenuItem(value: 'firstName', child: Text('First Name')),
                  DropdownMenuItem(value: 'lastName', child: Text('Last Name')),
                  DropdownMenuItem(value: 'hoursVolunteered', child: Text('Hours Volunteered')),
                  DropdownMenuItem(value: 'points', child: Text('Points')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    _sortList(value);
                  }
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: model.people.length,
            itemBuilder: (context, index) {
              final person = model.people[index];
              return ListTile(
                title: Text('${person.firstName} ${person.lastName}'),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${person.email}'),
                    const SizedBox(width: 20,),
                    Text('Phone: ${person.phone}'),
                    const SizedBox(width: 20,),
                    Text('Hours Volunteered: ${person.totalHours}'),
                    const SizedBox(width: 20,),
                    Text('Points: ${person.points}'),
                  ],
                ),
                isThreeLine: true,
              );
            },
          ),
        ),
      ],
    ),
  );
  }
}
