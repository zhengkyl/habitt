import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:intl/intl.dart';

import 'create_task_page.dart';
import 'task.dart';

class TaskListPage extends StatefulWidget {
  //static const routeName = '/';
  TaskListPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Task> tasks = List<Task>();

  // List<Task> tasks;
  @override
  void initState() {
    super.initState();
    _updateTasks();
  }

  void _updateTasks() {
    for (Task task in tasks) {
      if (task.resetDate.isBefore(DateTime.now())) {
        task.resetTask();
      }
    }
  }

  void _createNewTask() async {
    final task = await Navigator.pushNamed(context, CreateTaskPage.routeName);
    if (task != null) {
      setState(() {
        tasks.add(task);
      });
    }
  }

  void _editTask(Task task) async {
    final deleteTask = await Navigator.pushNamed(
        context, CreateTaskPage.routeName,
        arguments: task);
    if (deleteTask != null) {
      setState(() {
        tasks.remove(deleteTask);
      });
    }
  }

  Widget _buildTaskItem(BuildContext context, Task task) {
    return Card(
      color: task.isComplete
          ? task.colorPair.secondaryColor
          : task.colorPair.primaryColor,
      clipBehavior: Clip.antiAlias,
      // constraints: BoxConstraints.loose(Size(1000, 1000)),
      // decoration: BoxDecoration(
      //     color: Colors.yellow[200], borderRadius: BorderRadius.circular(8.0)),
      margin: EdgeInsets.symmetric(vertical: 4.0),
      child: Stack(children: <Widget>[
        IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.add,
                          ),
                          onPressed: () {
                            setState(() {
                              task.doTask();
                            });
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          color: Colors.black38,
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              task.undoTask();
                            });
                          },
                        ),
                      ),
                    ]),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    color: task.colorPair.secondaryColor,
                    child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: <Widget>[
                          Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  task.completedQuantity.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 32.0),
                                ),
                                task.goalQuantity > 0
                                    ? Text('of ' + task.goalQuantity.toString())
                                    : Container(),
                              ]),
                          Positioned(
                              bottom: 8,
                              child: Row(
                                children: <Widget>[
                                  Text('${task.streak}'),
                                  Icon(
                                    Icons.offline_bolt,
                                    size: 16,
                                    color: Colors.orange,
                                  ),
                                ],
                              )),
                        ]),
                  )),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          task.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                          ),
                        ),
                        Text(
                          'by ${DateFormat('MMM d, y').format(task.resetDate)}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        //lol
                        Text(
                          '${task.resetDate.hour > 12 ? task.resetDate.hour - 12 : task.resetDate.hour == 0 ? '12' : task.resetDate.hour}:${task.resetDate.minute.toString().padLeft(2, '0')}${task.resetDate.hour < 12 ? 'am' : 'pm'}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ]),
                ),
                flex: 3,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _editTask(task);
            },
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0, bottom: 80.0),
        itemBuilder: (BuildContext context, int index) =>
            _buildTaskItem(context, tasks[index]),
        itemCount: tasks.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNewTask,
        tooltip: 'Add a new Task',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
