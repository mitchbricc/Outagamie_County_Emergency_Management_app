import 'package:flutter/material.dart';
import 'package:outagamie_emergency_management_app/models/contact_info.dart';
import 'package:outagamie_emergency_management_app/models/events.dart';
import 'package:outagamie_emergency_management_app/models/oncall.dart';
import 'package:outagamie_emergency_management_app/models/report_creation.dart';
import 'package:outagamie_emergency_management_app/models/settings.dart';
import 'package:provider/provider.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/contact_info.dart';
import 'package:outagamie_emergency_management_app/display/admin/events.dart';
import 'package:outagamie_emergency_management_app/display/admin/feed.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/oncall_view.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/settings_volunteer.dart';
import 'package:outagamie_emergency_management_app/display/admin/approve_accounts.dart';
import 'package:outagamie_emergency_management_app/display/admin/schedule_oncall.dart';
import 'package:outagamie_emergency_management_app/display/admin/report_creation.dart';
import 'package:outagamie_emergency_management_app/models/schedule_oncall.dart';
import '../../classes/user.dart';
import '../../models/approve_accounts.dart';
import '../../models/feed.dart';

class AdminHome extends StatefulWidget {
  final User user;
  const AdminHome({super.key, required this.user});
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  _AdminHomeState();

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
      ChangeNotifierProvider<ApproveAccountsModel>(
                    create: (_) => ApproveAccountsModel(), 
                    child: Consumer<ApproveAccountsModel>(
                      builder: (context, model, child) =>
                          ApproveAccountsWidget(model: model, user: widget.user),
                    )),
      ChangeNotifierProvider<ScheduleOnCallModel>(
        create: (_) => ScheduleOnCallModel(), 
        child: Consumer<ScheduleOnCallModel>(
          builder: (context, model, child) =>
              ScheduleOnCallWidget(model: model, user: widget.user), 
        )),
        ChangeNotifierProvider<ReportCreationModel>(
        create: (_) => ReportCreationModel(), 
        child: Consumer<ReportCreationModel>(
          builder: (context, model, child) =>
              ReportWidget(model: model), 
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
            BottomNavigationBarItem(label: 'Accounts', icon: Icon(Icons.account_box_rounded,color: Colors.grey)),
            BottomNavigationBarItem(label: 'Schedule On-Call', icon: Icon(Icons.calendar_month,color: Colors.grey)),
            BottomNavigationBarItem(label: 'Report', icon: Icon(Icons.picture_as_pdf,color: Colors.grey)),
          ],
          fixedColor: Colors.grey,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          ),
    );
  }
}
