import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter/services.dart';

import './models/task.dart';
import './widgets/radial_chart.dart';
import './widgets/task_list.dart';
import './widgets/new_task.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FlutterDisplayMode.setHighRefreshRate();
  runApp(StudyManager());
}

class StudyManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      theme: ThemeData(
          primaryColor: HexColor('#4a148c'),
          primaryColorLight: HexColor('#7c43bd'),
          primaryColorDark: HexColor('#12005e'),
          accentColor: HexColor('#d81b60'),
          hintColor: HexColor('#12005e'),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor)),
          buttonTheme:
              ButtonThemeData(buttonColor: Theme.of(context).primaryColor),
          textTheme: GoogleFonts.robotoTextTheme().copyWith(
              headline6: GoogleFonts.roboto().copyWith(
                //fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
              headline4: GoogleFonts.roboto())),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int nextId = 9;
  var completedNum;
  var pendingNum;
  var dueNum;
  static const String green = '#00e575';
  static const String red = '#ff5722';
  static const String yellow = '#fbc02d';

  void _getChartData(List chartData) {
    completedNum = chartData[2]['total'];
    pendingNum = chartData[1]['total'];
    dueNum = chartData[0]['total'];
    return;
  }

  void _editTask(int index, String title, String info, DateTime enteredDate,
      bool isDone, double percDone, Color statusColor) {
    setState(() {
      _allTasks[index].title = title;
      _allTasks[index].info = info;
      _allTasks[index].endDate = enteredDate;
      _allTasks[index].isDone = isDone;
      _allTasks[index].percDone = percDone;
      _allTasks[index].statusColor = statusColor;
    });

    print(_allTasks[index].isDone);
  }

  void addTask(String title, String info, DateTime enteredDate, bool isDone,
      double percDone, Color statusColor) {
    Task newTask = Task(
        title: title,
        endDate: enteredDate,
        info: info,
        id: nextId,
        isDone: isDone,
        percDone: percDone,
        statusColor: statusColor);
    setState(() {
      nextId += 1;
      _allTasks.add(newTask);
    });
  }

  void _showAddNewTask(context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return NewTask(addTask);
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24))));
  }

  void _deleteTask(int index) {
    setState(() {
      _allTasks.removeAt(index);
    });
  }

  List<Task> _allTasks = [];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final appBar = AppBar(
      title: Text('DoobeDoobeDooba'),
      brightness: Brightness.dark,
    );

    return Scaffold(
      appBar: appBar,
      backgroundColor: Theme.of(context).primaryColorLight,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.rectangle),
              height: (mediaQuery.size.height -
                      mediaQuery.padding.top -
                      appBar.preferredSize.height) *
                  0.35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: mediaQuery.size.width * 0.475,
                    height: mediaQuery.size.width * 0.475,
                    child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24)),
                        child: TaskChart(_allTasks, _getChartData)),
                  ),
                  Container(
                    width: mediaQuery.size.width * 0.475,
                    height: mediaQuery.size.width * 0.475,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Summary',
                                  style: Theme.of(context).textTheme.headline5),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: [
                                        Container(
                                          height: 16,
                                          width: 16,
                                          margin: EdgeInsets.only(right: 4),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: HexColor(green),
                                          ),
                                        ),
                                        Text(
                                          'Completed: $completedNum',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            height: 16,
                                            width: 16,
                                            margin: EdgeInsets.only(right: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: HexColor(yellow),
                                            )),
                                        Text(
                                          'Pending: $pendingNum',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                            height: 16,
                                            width: 16,
                                            margin: EdgeInsets.only(right: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: HexColor(red),
                                            )),
                                        Text(
                                          'Due: $dueNum',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    color: HexColor('#e7b9ff')),
                height: (mediaQuery.size.height -
                        mediaQuery.padding.top -
                        appBar.preferredSize.height) *
                    0.65,
                width: double.infinity,
                child: _allTasks.length == 0
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Nothing to show'),
                          Container(
                              height: (mediaQuery.size.height -
                                      mediaQuery.padding.top -
                                      appBar.preferredSize.height) *
                                  0.3,
                              padding: EdgeInsets.all(24),
                              child: Image.asset(
                                'assets/images/waiting.png',
                                fit: BoxFit.cover,
                              )),
                          Text('*cricket noises*')
                        ],
                      )
                    : TaskList(_allTasks, _deleteTask, _editTask)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddNewTask(context);
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
