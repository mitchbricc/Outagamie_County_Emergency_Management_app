// ignore_for_file: no_logic_in_create_state

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';

import '../../classes/user.dart';
import '../../models/approve_accounts.dart';

class ApproveAccountsWidget extends StatefulWidget {
  final ApproveAccountsModel model;
  final User user;
  const ApproveAccountsWidget({super.key, required this.model, required this.user,});

  @override
  State<ApproveAccountsWidget> createState() => _ApproveAccountsWidgetState(model: model, user: user);
}

class _ApproveAccountsWidgetState extends State<ApproveAccountsWidget> {
  final ApproveAccountsModel model;
  User user;
  _ApproveAccountsWidgetState({required this.model, required this.user});

  @override
  void initState() {
    model.getPeople().then((onValue){
      setState(() {
        
      });
    });
    super.initState();
  }

  String searchQuery = '';
  bool showOnlyUnapproved = false;
  Map<String, dynamic>? selectedAccount;

  List<Map<String, dynamic>> get filteredAccounts {
    return model.volunteers.where((account) {
      final fullName = '${account['firstName']} ${account['lastName']}'.toLowerCase();
      final matchesSearch = fullName.contains(searchQuery.toLowerCase());
      final matchesApprovalFilter = showOnlyUnapproved ? !account['isApproved'] : true;
      return matchesSearch && matchesApprovalFilter;
    }).toList();
  }

  void confirmAction(String action, Map<String, dynamic> account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm $action'),
          content: Text('Are you sure you want to $action the account for ${account['firstName']} ${account['lastName']}?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  if (action == 'approve') {
                    account['isApproved'] = true;
                    User u = User.fromMap(account);
                    u.isApproved = true;
                    model.updateAttendence(u);
                  } else if (action == 'reset password') {
                    User u = User.fromMap(account);
                    u.password = BCrypt.hashpw('password', user.salt);
                    model.updateUser(user);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password is set to password'),
                      ),
                    );
                  } else if (action == 'make admin') {
                    account['isAdmin'] = true;
                    User u = User.fromMap(account);
                    u.type = 'admin';
                    model.updateAttendence(u);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text('Approve Accounts'),
      ),
      body: Column(
        children: [
          // Search bar to filter accounts
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Search by First or Last Name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          // Toggle to show only unapproved accounts
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Show Unapproved Only'),
              Switch(
                value: showOnlyUnapproved,
                onChanged: (value) {
                  setState(() {
                    showOnlyUnapproved = value;
                  });
                },
              ),
            ],
          ),
          // Scrollable list of accounts
          Expanded(
            child: ListView.builder(
              itemCount: filteredAccounts.length,
              itemBuilder: (context, index) {
                final account = filteredAccounts[index];
                return ListTile(
                  title: Text('${account['firstName']} ${account['lastName']}'),
                  subtitle: Text(account['email']),
                  trailing: Icon(
                    account['isApproved'] ? Icons.check_circle : Icons.error,
                    color: account['isApproved'] ? Colors.green : Colors.red,
                  ),
                  onTap: () {
                    setState(() {
                      selectedAccount = account;
                    });
                  },
                  selected: selectedAccount == account,
                );
              },
            ),
          ),
          // Buttons for approving, resetting password, and making admin
          if (selectedAccount != null) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                   ElevatedButton(
                    onPressed: (){
                      model.deleteAccount(User.fromMap(selectedAccount!));
                      model.volunteers.remove(selectedAccount);
                    },
                    child: const Text('Delete Account'),
                  ),
                  ElevatedButton(
                    onPressed: selectedAccount!['isApproved']
                        ? null
                        : () => confirmAction('approve', selectedAccount!),
                    child: const Text('Approve Account'),
                  ),
                  ElevatedButton(
                    onPressed: () => confirmAction('reset password', selectedAccount!),
                    child: const Text('Reset Password'),
                  ),
                  ElevatedButton(
                    onPressed: selectedAccount!['isAdmin']
                        ? null
                        : () => confirmAction('make admin', selectedAccount!),
                    child: const Text('Make Admin'),
                  ),
                ],
              ),
            ),
          ]
        ,const SizedBox(height: 25,)],
      ),
    );
  }
}
