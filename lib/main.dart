import 'package:flutter/material.dart';

import 'task.dart';
import 'create_task_page.dart';
import 'task_list_page.dart';

void main() => runApp(MaterialApp(
      title: 'Habitt',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => TaskListPage(title: 'Habitt'),
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
