import 'package:flutter/material.dart';

import 'task.dart';
import 'create_task_page.dart';
import 'task_list_page.dart';


//TODO
//edit start date and time
//edit streak
//color option
//visualization

void main() => runApp(MaterialApp(
      title: 'Habitt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TaskListPage(title: 'Hello title'),
      },
      onGenerateRoute: (settings) {
        if (settings.name == CreateTaskPage.routeName) {
          final Task editedTask = settings.arguments;
          return MaterialPageRoute(
            builder: (BuildContext context) {
              return CreateTaskPage(
                editedTask: editedTask,
              );
            });
        }
      },
    ));

// void main() => runApp(HabittApp());



// class HabittApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Habitt',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       initialRoute: '/',
//       routes: {
//         '/':(context)=>TaskListPage(title: 'Hello title'),
//         '/createTask':(context)=>CreateTaskPage(),
//       },
//       //home: TaskListPage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
