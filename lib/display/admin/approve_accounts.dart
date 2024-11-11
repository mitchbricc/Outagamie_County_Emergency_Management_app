import 'package:flutter/material.dart';

class ApproveAccountsWidget extends StatefulWidget {
  const ApproveAccountsWidget({super.key});

  @override
  State<ApproveAccountsWidget> createState() => _ApproveAccountsWidgetState();
}

class _ApproveAccountsWidgetState extends State<ApproveAccountsWidget> {
  // Sample list of accounts with first name, last name, email, and approval/admin status
  final List<Map<String, dynamic>> accounts = [
    {'firstName': 'John', 'lastName': 'Doe', 'email': 'john@example.com', 'isApproved': false, 'isAdmin': false},
    {'firstName': 'Jane', 'lastName': 'Smith', 'email': 'jane@example.com', 'isApproved': true, 'isAdmin': true},
    {'firstName': 'Alice', 'lastName': 'Johnson', 'email': 'alice@example.com', 'isApproved': false, 'isAdmin': false},
    {'firstName': 'Bob', 'lastName': 'Brown', 'email': 'bob@example.com', 'isApproved': true, 'isAdmin': false},
    {'firstName': 'Charlie', 'lastName': 'Davis', 'email': 'charlie@example.com', 'isApproved': false, 'isAdmin': false},
  ];

  String searchQuery = '';
  bool showOnlyUnapproved = false;
  Map<String, dynamic>? selectedAccount;

  // Method to filter accounts based on search query and approval status
  List<Map<String, dynamic>> get filteredAccounts {
    return accounts.where((account) {
      final fullName = '${account['firstName']} ${account['lastName']}'.toLowerCase();
      final matchesSearch = fullName.contains(searchQuery.toLowerCase());
      final matchesApprovalFilter = showOnlyUnapproved ? !account['isApproved'] : true;
      return matchesSearch && matchesApprovalFilter;
    }).toList();
  }

  // Method to confirm actions like approve, reset password, or make admin
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
                  } else if (action == 'reset password') {
                    // handle password reset logic here
                  } else if (action == 'make admin') {
                    account['isAdmin'] = true;
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
