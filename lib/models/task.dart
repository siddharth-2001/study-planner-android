import 'package:flutter/cupertino.dart';

class Task {
  int id;
  String title;
  String info;
  bool isDone;
  DateTime endDate;
  double percDone;
  Color statusColor;

  Task(
      {required this.title,
      required this.endDate,
      required this.info,
      required this.id,
      required this.isDone,
      required this.percDone,
      required this.statusColor});
}
