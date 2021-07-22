import 'package:flutter/material.dart';
import 'package:study_planner/models/task.dart';
import 'package:intl/intl.dart';

import '../widgets/edit_task.dart';
import '../widgets/task_detail.dart';
import './edit_task.dart';

class TaskList extends StatelessWidget {
  final List<Task> _allTasks;
  final Function _deleteTask;
  final Function _editTask;

  TaskList(this._allTasks, this._deleteTask, this._editTask);

  void showTaskDetail(context, index) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        context: context,
        builder: (_) {
          Task task = _allTasks[index];
          return TaskDetail(index, task, _showEditSheet, _deleteTask);
        });
  }

  void _showEditSheet(context, index) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return EditTask(_allTasks, _editTask, index);
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))));
  }

  final List<PopupMenuEntry> options = [
    const PopupMenuItem(
      child: Text('Edit'),
      value: 'edit',
    ),
    const PopupMenuItem(
      child: Text('Delete'),
      value: 'delete',
    )
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(parent: BouncingScrollPhysics()),
      itemCount: _allTasks.length,
      itemBuilder: (context, index) {
        return Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Card(
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Stack(children: [
              ListTile(
                onTap: () {
                  showTaskDetail(context, index);
                },
                leading: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_allTasks[index].percDone.toInt()}%',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                title: Text(
                  '${_allTasks[index].title}',
                  style: Theme.of(context).textTheme.headline6,
                ),
                subtitle: Text(
                  'Due: ${DateFormat.yMMMMd().format(_allTasks[index].endDate)}',
                  style: TextStyle(fontSize: 12),
                ),
                trailing: PopupMenuButton(
                  itemBuilder: (context) {
                    return options;
                  },
                  icon: Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'edit')
                      _showEditSheet(context, index);
                    else
                      _deleteTask(index);
                  },
                ),
              ),
              Container(
                //padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                width: 12,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(24),
                    ),
                    color: _allTasks[index].statusColor),
              ),
            ]),
          ),
        );
      },
    );
  }
}
