import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class NewTask extends StatefulWidget {
  final Function addTask;
  NewTask(this.addTask);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  DateTime _enteredDate = DateTime.now();
  final _titleController = TextEditingController();
  final _infoController = TextEditingController();
  double _percComplete = 0.0;
  bool? _isDone = false;

  static const String green = '#00e575';
  static const String red = '#ff5722';
  static const String yellow = '#fbc02d';

  Color statusColor = HexColor(yellow);

  void _submissionHandler() {
    String title = _titleController.text;
    String info = _infoController.text;

    if (title.isNotEmpty && info.isNotEmpty) {
      if (_isDone != true) {
        if (_enteredDate.isBefore(DateTime.now())) statusColor = HexColor(red);
      } else
        statusColor = HexColor(green);
      widget.addTask(
          title, info, _enteredDate, _isDone, _percComplete, statusColor);
      Navigator.of(context).pop();
    } else {
      return;
    }
  }

  Future<void> _pickDate(context) async {
    final pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime.now().add(Duration(days: 365)));
    if (pickedDate != null) {
      _enteredDate = pickedDate;
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor))),
              cursorColor: Theme.of(context).accentColor,
              controller: _titleController,
              onSubmitted: (_) {
                _submissionHandler();
              },
            ),
            TextField(
                decoration: InputDecoration(
                    labelText: 'Info',
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor))),
                cursorColor: Theme.of(context).accentColor,
                controller: _infoController,
                onSubmitted: (_) {
                  _submissionHandler();
                }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Due Date: ${DateFormat.yMMMd().format(_enteredDate)}',
                  style: TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () {
                    _pickDate(context);
                  },
                  child: Text('Choose Date'),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                ),
              ],
            ),
            Slider(
              value: _percComplete,
              label: '${_percComplete.toInt()} %',
              min: 0.0,
              max: 100.00,
              divisions: 5,
              onChanged: (value) {
                setState(() {
                  _percComplete = value;
                  if (value == 100.00)
                    _isDone = true;
                  else
                    _isDone = false;
                });
              },
              activeColor: Theme.of(context).accentColor,
              inactiveColor: Colors.grey[300],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Finished:',
                  style: TextStyle(fontSize: 16),
                ),
                Checkbox(
                    value: _isDone,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _isDone = newValue;
                        if (_isDone = true) _percComplete = 100.00;
                      });
                    })
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                _submissionHandler();
              },
              icon: Icon(Icons.check),
              label: Text('Add Task'),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
            )
          ],
        ),
      ),
    );
  }
}
