// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outagamie_emergency_management_app/models/report_creation.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class ReportWidget extends StatefulWidget {
  final ReportCreationModel model;
  const ReportWidget({super.key, required this.model});

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
  late ReportCreationModel model;
  @override
  void initState() {
    model = widget.model;
    super.initState();
  }
  DateTime? _startDate;
  DateTime? _endDate;
  bool _autoSaveToDownloads = true;

  // Helper method to select date
  Future<void> _selectDate(BuildContext context, bool isStart) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  bool isDateBetween(DateTime targetDate, DateTime startDate, DateTime endDate) {
  return targetDate.isAfter(startDate) && targetDate.isBefore(endDate);
}

  // Helper method to create the report content
  Future<String> _generateReportContent() async {
    _startDate = _startDate ?? DateTime(2000);
    _endDate = _endDate ?? DateTime(2100);
    String start = _startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : 'N/A';
    String end = _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : 'N/A';

    String events= '';
    for(int i = 0;i<model.events.length;i++){
      var e = model.events[i];
      await model.getTotalHours(e.id).then((t){
        if( isDateBetween(e.date, _startDate!, _endDate!)){
        events += 'event name: ${e.name}\n';
        events += 'date: ${DateFormat('yyyy-MM-dd').format(e.date)}\n';
        events += 'number of volunteers: ${e.totalVolunteerHours}\n';
        events += 'total hours: ${t.toString()}';
        events += '\n\n';
      }
      });
    }

    return 'Report from $start to $end\n\n$events';
  }

  Future<void> _saveFileForWeb() async {
  String reportContent = await _generateReportContent();
  String fileName = 'report_${DateTime.now().millisecondsSinceEpoch}.txt';

  // Create a Blob object with the report content
  final bytes = html.Blob([reportContent]);

  // Create an anchor element
  final url = html.Url.createObjectUrlFromBlob(bytes);
  final anchor = html.AnchorElement(href: url)
    ..target = 'blank'
    ..download = fileName;

  // Trigger the download
  anchor.click();

  // Cleanup the URL object
  html.Url.revokeObjectUrl(url);

  // Optionally show a success message
  _showMessage('File saved: $fileName');
}
  
  Future<void> _saveFile() async {
    String reportContent = await _generateReportContent();
    String fileName = 'report_${DateTime.now().millisecondsSinceEpoch}.txt';

    if (_autoSaveToDownloads) {
      Directory? downloadsDirectory = await getDownloadsDirectory();
      if (downloadsDirectory != null) {
        String filePath = '${downloadsDirectory.path}/$fileName';
        File file = File(filePath);
        await file.writeAsString(reportContent);
        _showMessage('File saved to Downloads: $filePath');
      } else {
        _showMessage('Could not find the Downloads directory.');
      }
    } else {
      String? filePath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Report',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['txt'],
      );

      if (filePath != null) {
        File file = File(filePath);
        await file.writeAsString(reportContent);
        _showMessage('File saved: $filePath');
      } else {
        _showMessage('Save operation cancelled.');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return model.isLoaded ? scaffold(context) : const Text('Loading!!!!!!');
  }

  Scaffold scaffold(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      automaticallyImplyLeading: false,
      title: const Text('Generate Report'),
    ),
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Start Date Picker
          ListTile(
            title: Text('Start Date: ${_startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : 'Select a date'}'),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context, true),
            ),
          ),
          // End Date Picker
          ListTile(
            title: Text('End Date: ${_endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : 'Select a date'}'),
            trailing: IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () => _selectDate(context, false),
            ),
          ),
          const SizedBox(height: 20),
          // Toggle for auto-saving to Downloads
          Row(
            children: [
              const Text('Save to Downloads automatically'),
              Switch(
                value: _autoSaveToDownloads,
                onChanged: (value) {
                  setState(() {
                    _autoSaveToDownloads = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          DropdownButton<String>(
            isExpanded: true,
            value: _selectedCategory,
            hint: const Text('Select Category'),
            items: categories.map((category) {
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
          // Generate Report Button
          ElevatedButton(
            onPressed: () {
              // if (_startDate == null || _endDate == null) {
              //   _showMessage('Please select both start and end dates.');
              // } else {
                //_saveFile();
                _saveFileForWeb();
              // }
            },
            child: const Text('Generate Report'),
          ),
        ],
      ),
    ),
  );
  }
  List<String> categories = ['Community', 'Health', 'Education'];
  String? _selectedCategory;
}
