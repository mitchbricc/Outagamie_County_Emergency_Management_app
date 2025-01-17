import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:outagamie_emergency_management_app/models/settings.dart';

import '../../classes/user.dart';

class SettingWidget extends StatefulWidget {
  final SettingsModel model;
  final User user;
  const SettingWidget({super.key, required this.model, required this.user});

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  late SettingsModel model;
  late User user;
  @override
  void initState() {
    model = widget.model;
    user = widget.user;
    super.initState();
  }


  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _firstNameKey = GlobalKey<FormState>();
  final _lastNameKey = GlobalKey<FormState>();
  final _phoneKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();

  bool _notificationsEnabled = true;

  void _updateSetting(String field) {
    model.updateUser(user);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$field updated successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Form(
              key: _firstNameKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_firstNameKey.currentState!.validate()) {
                        user.firstName = _firstNameController.text;
                        _updateSetting('First Name');
                      }
                    },
                    child: const Text('Update First Name'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Form(
              key: _lastNameKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_lastNameKey.currentState!.validate()) {
                        user.lastName = _lastNameController.text;
                        _updateSetting('Last Name');
                      }
                    },
                    child: const Text('Update Last Name'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Form(
              key: _phoneKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                        return 'Please enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_phoneKey.currentState!.validate()) {
                        user.phone = _phoneController.text;
                        _updateSetting('Phone Number');
                      }
                    },
                    child: const Text('Update Phone Number'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Form(
              key: _passwordKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_passwordKey.currentState!.validate()) {
                        user.password = BCrypt.hashpw(_passwordController.text, user.salt);
                        _updateSetting('Password');
                      }
                    },
                    child: const Text('Update Password'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                String status = value ? 'enabled' : 'disabled';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Notifications $status')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}