import 'package:flutter/material.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/contact_info.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/oncall_view.dart';
import 'package:provider/provider.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/events.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/feed.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/settings_volunteer.dart';

import '../../classes/user.dart';
import '../../models/contact_info.dart';
import '../../models/events.dart';
import '../../models/feed.dart';
import '../../models/oncall.dart';
import '../../models/settings.dart';

class VolunteerHome extends StatefulWidget {
  final User user;
  const VolunteerHome({super.key, required this.user});
  @override
  State<VolunteerHome> createState() => _VolunteerHomeState();
}

class _VolunteerHomeState extends State<VolunteerHome> {
  _VolunteerHomeState();

  List<Widget> screens = [];
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    screens = [
      ChangeNotifierProvider<EventsModel>(
        create: (_) => EventsModel(), 
        child: Consumer<EventsModel>(
          builder: (context, model, child) =>
              EventsWidget(model: model, user: widget.user), 
        )),
        ChangeNotifierProvider<ContactInfoModel>(
        create: (_) => ContactInfoModel(), 
        child: Consumer<ContactInfoModel>(
          builder: (context, model, child) =>
             ContactInfoWidget(model: model, user: widget.user), 
        )),
        ChangeNotifierProvider<FeedModel>(
                    create: (_) => FeedModel(), 
                    child: Consumer<FeedModel>(
                      builder: (context, model, child) =>
                          FeedWidget(model: model, user: widget.user),
                    )),
      ChangeNotifierProvider<OnCallModel>(
        create: (_) => OnCallModel(), 
        child: Consumer<OnCallModel>(
          builder: (context, model, child) =>
              OnCallWidget(model: model, user: widget.user), 
        )),
      ChangeNotifierProvider<SettingsModel>(
        create: (_) => SettingsModel(), 
        child: Consumer<SettingsModel>(
          builder: (context, model, child) =>
              SettingWidget(model: model, user: widget.user), 
        )),
    ];
  }

  void _handleTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
          builder: (context, workersModel, child) =>
              screens[selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
          onTap: _handleTap,
          currentIndex: selectedIndex,
          items: const [
            BottomNavigationBarItem(label: 'Events', icon: Icon(Icons.task_alt,color: Colors.grey)),
            BottomNavigationBarItem(label: 'Info', icon: Icon(Icons.info,color: Colors.grey)),
            BottomNavigationBarItem(label: 'Feed', icon: Icon(Icons.email,color: Colors.grey)),
            BottomNavigationBarItem(label: 'Contact', icon: Icon(Icons.person,color: Colors.grey)),
            BottomNavigationBarItem(label: 'Settings', icon: Icon(Icons.settings,color: Colors.grey)),
          ],
          fixedColor: Colors.grey,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          ),
    );
  }
}
