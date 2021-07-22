import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class TaskDetail extends StatelessWidget {
  final int index;
  final Task task;
  final Function showEditSheet;
  final Function deleteTask;
  TaskDetail(this.index, this.task, this.showEditSheet, this.deleteTask);

  static const String green = '#00e575';
  static const String red = '#ff5722';
  static const String yellow = '#fbc02d';

  @override
  Widget build(BuildContext context) {
    Color barColor = HexColor('#d81b60');
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                color: task.statusColor,
              ),
              height: 20,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(
                          '${task.title}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      SleekCircularSlider(
                        min: 0.00,
                        max: 100.00,
                        initialValue: task.percDone,
                        appearance: CircularSliderAppearance(
                          startAngle: 270,
                          angleRange: 360.00,
                          size: 130,
                          customWidths: CustomSliderWidths(progressBarWidth: 4),
                          customColors: CustomSliderColors(
                              progressBarColor: barColor,
                              trackColor: Colors.grey[400]),
                          animDurationMultiplier: 0.8,
                        ),
                      )
                    ],
                  ),
                  Text(
                    'Details',
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text('${task.info}'),
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    'Due Date',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text('${DateFormat.yMMMMd().format(task.endDate)}'),
                  SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          showEditSheet(context, index);
                        },
                        icon: Icon(Icons.edit),
                        label: Text('Edit'),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          deleteTask(index);
                        },
                        icon: Icon(Icons.delete_forever_outlined),
                        label: Text('Delete'),
                        style: ElevatedButton.styleFrom(primary: Colors.red),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
