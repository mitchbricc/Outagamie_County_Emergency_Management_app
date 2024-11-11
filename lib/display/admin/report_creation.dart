import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class ReportWidget extends StatefulWidget {
  const ReportWidget({super.key});

  @override
  State<ReportWidget> createState() => _ReportWidgetState();
}

class _ReportWidgetState extends State<ReportWidget> {
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

  // Helper method to create the report content
  String _generateReportContent() {
    String start = _startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : 'N/A';
    String end = _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : 'N/A';

    return 'Report from $start to $end\n\nT';
  }

  
  Future<void> _saveFile() async {
    String reportContent = _generateReportContent();
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
    return Scaffold(
      appBar: AppBar(
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
            // Generate Report Button
            ElevatedButton(
              onPressed: () {
                if (_startDate == null || _endDate == null) {
                  _showMessage('Please select both start and end dates.');
                } else {
                  _saveFile();
                }
              },
              child: const Text('Generate Report'),
            ),
          ],
        ),
      ),
    );
  }
}
