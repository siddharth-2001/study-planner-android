import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:hexcolor/hexcolor.dart';

import '../models/task.dart';

class TaskChart extends StatelessWidget {
  final List<Task> _recentTasks;
  final Function _getChartData;

  TaskChart(this._recentTasks, this._getChartData);

  List<Map<String, Object>> get chartData {
    return List.generate(3, (index) {
      int total = 0; //number of tasks
      String status = 'status'; //placeholder value
      Color color = Colors.black; //placeholder color

      if (index == 0) {
        //for tasks that are not done but the due date has passed (Due)
        status = 'Due';
        color = HexColor('#ff5722');
        for (var task in _recentTasks) {
          if (task.isDone == false && task.endDate.isBefore(DateTime.now())) {
            total += 1;
          }
        }
      }

      if (index == 1) {
        //for tasks that are to be done but due date has not passed (Pending)
        status = 'Pending';
        color = HexColor('#fbc02d');
        for (var task in _recentTasks) {
          if (task.isDone == false && task.endDate.isAfter(DateTime.now())) {
            total += 1;
          }
        }
      }

      if (index == 2) {
        //for tasks that are completed  (Completed)
        status = 'Completed';
        color = HexColor('#00e575');
        for (var task in _recentTasks) {
          if (task.isDone == true) {
            total += 1;
          }
        }
      }

      return {'status': status, 'total': total, 'color': color};
    });
  }

  @override
  Widget build(BuildContext context) {
    _getChartData(chartData);
    return Container(
      child: SfCircularChart(
        series: <CircularSeries>[
          RadialBarSeries(
              dataSource: chartData,
              xValueMapper: (data, _) => data['status'],
              yValueMapper: (data, _) => data['total'],
              pointColorMapper: (data, _) => data['color'],
              cornerStyle: CornerStyle.bothCurve,
              dataLabelSettings: DataLabelSettings(
                isVisible: true,
              ),
              radius: '95%')
        ],
      ),
    );
  }
}
