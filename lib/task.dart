import 'package:flutter/material.dart';

// class TaskItem extends StatefulWidget {
//   @override
//   _TaskItemState createState() => _TaskItemState();
// }

// class _TaskItemState extends State<TaskItem> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
// class TaskMessage{
//   final Task task;
//   final TaskStatus taskStatus;
//   TaskMessage({this.task, this.taskStatus});
// }

// enum TaskStatus{CREATE, DELETE}

class Task {
  String title;
  bool isComplete = false;

  int completedQuantity = 0;
  int goalQuantity;

  int time;
  TimeUnit unit;
  DateTime startDate;

  DateTime resetDate;

  Color color;
  int streak = 0;

  Task({
    @required this.title,
    @required this.goalQuantity,
    @required this.time,
    @required this.unit,
    @required this.startDate,
    @required this.color,
  }) {
    resetDate = startDate;
  }

  void setNextResetDate() {
    if (unit.value == NonStandardTimeUnit) {
      switch (unit) {
        case TimeUnit.MONTH:
          break;

        case TimeUnit.YEAR:
          //Makes sure doesn't reset on noexistant Feb 29.
          //I'm assuming this won't be used by 2100, so ignore no leap year on 2100 etc
          int resetDay;
          if (resetDate.day == 29 &&
              resetDate.month == 2 &&
              (resetDate.year + 1) % 4 == 0) {
            resetDay = 28;
          } else {
            resetDay = 29;
          }
          resetDate = DateTime(resetDate.year + 1, resetDate.month, resetDay,
              resetDate.hour, resetDate.minute);
          break;
      }
    } else {
      Duration interval;
      switch (unit) {
        case TimeUnit.HOUR:
          interval = Duration(hours: time);
          break;
        case TimeUnit.DAY:
          interval = Duration(days: time);
          break;
        case TimeUnit.WEEK:
          interval = Duration(days: 7 * time);
          break;
      }
      resetDate = resetDate.add(interval);
    }
  }

  void doTask() {
    completedQuantity++;
    if (completedQuantity == goalQuantity) {
      isComplete = true;
      streak++;
    }
  }

  void undoTask() {
    if (completedQuantity == goalQuantity) {
      isComplete = false;
      streak--;
    }
    completedQuantity--;
  }

  void resetTask() {
    completedQuantity = 0;
    isComplete = false;
  }
}

enum NonStandardTimeUnit { MONTH, YEAR }

class TimeUnit {
  final String name;
  final value;

  const TimeUnit._internal(
    this.name,
    this.value,
  );

  static const HOUR = const TimeUnit._internal('hour', 1);
  static const DAY = const TimeUnit._internal('day', 24);
  static const WEEK = const TimeUnit._internal('week', 24 * 7);

  static const MONTH =
      const TimeUnit._internal('month', NonStandardTimeUnit.MONTH);
  static const YEAR =
      const TimeUnit._internal('year', NonStandardTimeUnit.YEAR);

  static const timeUnits = [
    HOUR,
    DAY,
    WEEK,
    MONTH,
    YEAR,
  ];
  // static const SUNDAY = const TimeUnit._internal('Sunday', DateTime.sunday);
  // static const MONDAY = const TimeUnit._internal('Monday',DateTime.monday);
  // static const TUESDAY = const TimeUnit._internal('Tuesday',DateTime.tuesday);
  // static const WEDNESDAY = const TimeUnit._internal('Wednesday',DateTime.wednesday);
  // static const THURSDAY = const TimeUnit._internal('Thursday',DateTime.thursday);
  // static const FRIEDAY = const TimeUnit._internal('Friday',DateTime.friday);
  // static const SATURDAY = const TimeUnit._internal('Saturday',DateTime.saturday);
}
