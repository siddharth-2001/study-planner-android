import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class EditTask extends StatefulWidget {
  final List<Task> _allTasks;
  final Function _editTask;
  final int index;

  EditTask(this._allTasks, this._editTask, this.index);
  @override
  _EditTaskState createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  Task get _oldTask {
    return widget._allTasks[widget.index];
  }

  late String newTitle = _oldTask.title;
  late String newInfo = _oldTask.info;
  late DateTime newDate = _oldTask.endDate;
  late double newPerc = _oldTask.percDone;
  late bool? newIsDone = _oldTask.isDone;
  late Color newStatusColor = _oldTask.statusColor;

  static const String green = '#00e575';
  static const String red = '#ff5722';
  static const String yellow = '#fbc02d';

  _showDatePicker(context) {
    showDatePicker(
            context: context,
            initialDate: _oldTask.endDate,
            firstDate: DateTime.now().subtract(Duration(days: 365)),
            lastDate: DateTime.now().add(Duration(days: 365)))
        .then((value) {
      if (value != null) newDate = value;
    });
  }

  void _submissionHandler() {
    if (newPerc == 100.00) newStatusColor = HexColor(green);
    if (newPerc != 100.00 && newDate.isBefore(DateTime.now()))
      newStatusColor = HexColor(red);
    if (newPerc != 100.00 && newDate.isAfter(DateTime.now()))
      newStatusColor = HexColor(yellow);
    widget._editTask(widget.index, newTitle, newInfo, newDate, newIsDone,
        newPerc, newStatusColor);
    Navigator.of(context).pop();
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
            TextFormField(
              initialValue: _oldTask.title,
              decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor))),
              cursorColor: Theme.of(context).accentColor,
              onChanged: (value) {
                newTitle = value;
              },
            ),
            TextFormField(
              initialValue: _oldTask.info,
              decoration: InputDecoration(
                  labelText: 'Info',
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor),
                  focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor))),
              cursorColor: Theme.of(context).accentColor,
              onChanged: (value) {
                newInfo = value;
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Due Date: ${DateFormat.yMMMMd().format(newDate)}',
                ),
                ElevatedButton(
                  onPressed: () {
                    _showDatePicker(context);
                  },
                  child: Text('Choose Date'),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                ),
              ],
            ),
            Slider(
              value: newPerc,
              min: 0.0,
              max: 100.00,
              divisions: 5,
              onChanged: (value) {
                setState(() {
                  if (value == 100.00) newIsDone = true;
                  newPerc = value;
                });
              },
              activeColor: Theme.of(context).accentColor,
              inactiveColor: Colors.grey[300],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Completed:'),
                Checkbox(
                  value: newIsDone,
                  onChanged: (value) {
                    setState(() {
                      if (value == true)
                        newPerc = 100.00;
                      else
                        newPerc = 0.00;
                      newIsDone = value;
                    });
                  },
                )
              ],
            ),
            ElevatedButton.icon(
                onPressed: () {
                  _submissionHandler();
                },
                icon: Icon(Icons.check),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
                label: Text('Edit'))
          ],
        ),
      ),
    );
  }
}
