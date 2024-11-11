import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/contact_info.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/events.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/feed.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/oncall_view.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/settings_volunteer.dart';



/**
Name: Mitchell Bricco
Date:
Description: Creates a navigation bar 
Bugs: no known bugs
*/
///
class VolunteerHome extends StatefulWidget {

  const VolunteerHome({super.key});
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
      const EventsWidget(),
      const ContactInfoWidget(),
      const FeedWidget(),
      const OnCallWidget(),
      const SettingWidget(),
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
