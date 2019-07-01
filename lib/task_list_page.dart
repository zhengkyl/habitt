import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:habitt/create_task_page.dart';
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

    for(Task task in tasks){
      if(task.resetDate.isBefore(DateTime.now())){
        task.resetTask();
        //TODO timers?
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
      color: task.color,
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
                          color: Colors.lightBlueAccent,
                          child: Icon(Icons.add),
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
                          color: Colors.redAccent,
                          child: Icon(Icons.remove),
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
                    color: Colors.yellow[200],
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            task.completedQuantity.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 32.0),
                          ),
                          task.goalQuantity > 0 ? Text('of '+task.goalQuantity.toString()): Container(),
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
                          '700000hrs remaining',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ]),
                ),

                //child: Text(task.title),
                flex: 3,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0.1,
          right: 0.1,
          child: IconButton(
            icon: Icon(Icons.edit),
            //TODO
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
