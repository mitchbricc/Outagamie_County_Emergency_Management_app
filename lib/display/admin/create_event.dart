import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outagamie_emergency_management_app/classes/event.dart';

import '../../classes/user.dart';
import '../../models/events.dart';

class CreateEventWidget extends StatefulWidget {
  final EventsModel model;
  final User user;
  const CreateEventWidget({super.key, required this.model, required this.user});

  @override
  State<CreateEventWidget> createState() => _CreateEventWidgetState();
}

class _CreateEventWidgetState extends State<CreateEventWidget> {
  late EventsModel model;
  @override
  void initState() {
    super.initState();
    model = widget.model;
  }
  // Form controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  // Existing categories
  //List<String> categories = ['Community', 'Health', 'Education'];
  String? _selectedCategory;

  // Event roles
  List<String> roles = [];
  final TextEditingController _roleController = TextEditingController();

  // Roles and volunteers per hour data
  Map<String, Map<DateTimeRange, int>> roleVolunteerSchedule = {};

  // Method to pick a date
  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  // Method to pick start or end time
  Future<void> _pickTime({required bool isStartTime}) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        if (isStartTime) {
          _startTime = time;
        } else {
          _endTime = time;
        }
      });
    }
  }

  Future<void> _showCategoryPopup() async {
    _selectedCategory = null;
    String? newCategory;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Manage Categories'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(hintText: 'Enter new category'),
                onChanged: (value) {
                  newCategory = value;
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Delete Category:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              DropdownButton<String>(
                hint: const Text('Select category to delete'),
                items: model.categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  Navigator.pop(context); 
                  setState(() {
                    model.categories.remove(value);
                    model.deleteCat(value!);
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('Add Category'),
              onPressed: () {
                if (newCategory != null && newCategory!.isNotEmpty) {
                  setState(() {
                    model.categories.add(newCategory!);
                    model.addCategory(newCategory!);
                  });
                }
                Navigator.pop(context); 
              },
            ),
          ],
        );
      },
    );
  }

  // Method to add roles
  void _addRole() {
    if (_roleController.text.isNotEmpty) {
      setState(() {
        roles.add(_roleController.text);
        _roleController.clear();
      });
    }
  }

  // void _assignVolunteersPerHour() async {
  //   await Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 fullscreenDialog: true,
  //                 builder: (context) => const AssignRolePerHourWidget(eventStartTime: TimeOfDay(hour: 8, minute: 0),eventEndTime: TimeOfDay(hour: 15, minute: 0)),
  //               ),
  //             );
  // }

  int? _volunteersNeeded;
  final TextEditingController _volunteersNeededController = TextEditingController();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Event'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Event Name'),
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickDate,
                  child: const Text('Pick Date'),
                ),
                const SizedBox(width: 10),
                Text(_selectedDate == null
                    ? 'No Date Chosen'
                    : DateFormat('MM/dd/yyyy').format(_selectedDate!)),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _pickTime(isStartTime: true),
                  child: const Text('Pick Start Time'),
                ),
                const SizedBox(width: 10),
                Text(_startTime == null ? 'No Start Time' : _startTime!.format(context)),
              ],
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _pickTime(isStartTime: false),
                  child: const Text('Pick End Time'),
                ),
                const SizedBox(width: 10),
                Text(_endTime == null ? 'No End Time' : _endTime!.format(context)),
              ],
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategory,
                    hint: const Text('Select Category'),
                    items: model.categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _showCategoryPopup,
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
            controller: _volunteersNeededController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Enter the number of volunteers Needed',
            ),
          ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _roleController,
                    decoration: const InputDecoration(labelText: 'Add Role'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addRole,
                ),
              ],
            ),
          const SizedBox(height: 10),
            // TextButton(
            //             onPressed: () => _showNumberInputDialog(),//_assignVolunteersPerHour(),
            //             child: const Text('Volunteers Needed'),
            //           ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: roles.map((role) {
                  return Text(role);
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: (){
                    if (_volunteersNeededController.text.isNotEmpty) {
                      int? enteredNumber = int.tryParse(_volunteersNeededController.text);
                      if (enteredNumber != null) {
                          _volunteersNeeded = enteredNumber;
                      } else {
                        // Show an error if the input isn't a valid integer
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a valid integer')),
                        );
                      }
                    }
                    if(_selectedDate != null && _startTime != null && _endTime != null){
                      Event event = Event(id: 'id', name: _nameController.text, date: _selectedDate!, startTime: _startTime!, endTime: _endTime!, location: _locationController.text, description: _descriptionController.text, totalVolunteerHours: _volunteersNeeded!, category: _selectedCategory!, attendees: [], roles: roles);
                      model.addEvent(event);
                      Navigator.pop(context);
                    }
                  }, child: const Text('Create Event')),
                ],
              )
          ],
        ),
      ),
    );
  }
}
