import 'package:flutter/material.dart';

class ColorPair {
  final Color primaryColor;
  final Color secondaryColor;
  final String title;

  const ColorPair._internal(this.primaryColor, this.secondaryColor, this.title);

  static const RED = ColorPair._internal(
      const Color(0xffff6666), const Color(0xffff3333), 'Red');
  static const ORANGE = ColorPair._internal(
      const Color(0xffffa64d), const Color(0xffff8000), 'Orange');
  static const YELLOW = ColorPair._internal(
      const Color(0xffffd24d), const Color(0xffffbf00), 'Yellow');
  static const GREEN = ColorPair._internal(
      const Color(0xff86f986), const Color(0xff55f655), 'Green');
  static const BLUE = ColorPair._internal(
      const Color(0xff99ccff), const Color(0xff4da6ff), 'Blue');
  static const PURPLE = ColorPair._internal(
      const Color(0xfffa9efa), const Color(0xfff655f6), 'Purple');
  static const WHITE = ColorPair._internal(
      const Color(0xffececec), const Color(0xffd9d9d9), 'White');

  static const COLOR_PAIRS = [
    RED,
    ORANGE,
    YELLOW,
    GREEN,
    BLUE,
    PURPLE,
    WHITE,
  ];
}

class Task {
  String title;
  bool isComplete = false;
  bool isPositive;
  int completedQuantity = 0;
  int goalQuantity;

  int timeCoefficient;
  TimeHelper timeUnit;
  DateTime startDate;

  int fullResetDay;
  DateTime resetDate;

  ColorPair colorPair;
  int streak = 0;

  ///Saves streak value if streak broken to allow undo mistaken + or -
  int oldStreakValue;

  Task({
    @required this.title,
    @required this.goalQuantity,
    @required this.timeCoefficient,
    @required this.timeUnit,
    @required this.startDate,
    @required this.colorPair,
    @required this.isPositive,
  }) {
    resetDate = startDate;
    fullResetDay = startDate.day;
    incrementResetDate();
  }

  void incrementResetDate() {
    //This is a shitty way of determining no reset, but guess what thats what i'm doing
    if (timeCoefficient == 0) {
      return;
    }
    if (isComplete && !isPositive || !isComplete && isPositive) {
      streak=0;
    }

    if (timeUnit.value == NonStandardTimeUnit) {
      switch (timeUnit) {
        case TimeHelper.MONTH:
          int resetMonth = resetDate.month + timeCoefficient;
          int resetYear = resetDate.year;

          ///fullResetDay saves the original date #, so it's not lost when date capped at 30,28 etc
          int flooredResetDay = fullResetDay;
          if (resetMonth > 12) {
            resetMonth -= 12;
            resetYear++;
          }

          ///Datetime.month is 1 based index, so add 1 to get proper list item
          int resetMonthLength = TimeHelper.MONTH_LENGTHS[resetMonth + 1];
          if (resetDate.day > resetMonthLength) {
            if (resetDate.day == 29 && resetYear % 4 == 0) {
              flooredResetDay = 29;
            } else {
              flooredResetDay = resetMonthLength;
            }
          }
          resetDate = DateTime(resetYear, resetMonth, flooredResetDay,
              resetDate.hour, resetDate.minute);
          break;

        case TimeHelper.YEAR:
          int flooredResetDay;
          //Makes sure doesn't reset on noexistant Feb 29.
          //I'm assuming this won't be used by 2100, so ignore no leap year on 2100 etc
          if (resetDate.day == 29 &&
              resetDate.month == 2 &&
              (resetDate.year + timeCoefficient) % 4 == 0) {
            flooredResetDay = 28;
          } else {
            flooredResetDay = resetDate.day;
          }
          resetDate = DateTime(
              resetDate.year + timeCoefficient,
              resetDate.month,
              flooredResetDay,
              resetDate.hour,
              resetDate.minute);
          break;
      }
    } else {
      Duration interval;
      switch (timeUnit) {
        case TimeHelper.HOUR:
          interval = Duration(hours: timeCoefficient);
          break;
        case TimeHelper.DAY:
          interval = Duration(days: timeCoefficient);
          break;
        case TimeHelper.WEEK:
          interval = Duration(days: 7 * timeCoefficient);
          break;
      }
      resetDate = resetDate.add(interval);
    }
  }

  void doTask() {
    completedQuantity++;
    if (completedQuantity == goalQuantity) {
      isComplete = true;
      if (isPositive) {
        streak++;
      }else{
        oldStreakValue = streak;
        streak =0;
      }
    }
  }

  void undoTask() {
    if (completedQuantity == goalQuantity) {
      isComplete = false;
      if (isPositive) {
        streak--;
      }else{
        streak = oldStreakValue;
      }
    }
    completedQuantity--;
  }

  void resetTask() {
    completedQuantity = 0;
    isComplete = false;
    incrementResetDate();
  }
}

enum NonStandardTimeUnit { MONTH, YEAR }

class TimeHelper {
  final String name;
  final value;

  const TimeHelper._internal(
    this.name,
    this.value,
  );

  static const HOUR = const TimeHelper._internal('hour', 1);
  static const DAY = const TimeHelper._internal('day', 24);
  static const WEEK = const TimeHelper._internal('week', 24 * 7);

  static const MONTH =
      const TimeHelper._internal('month', NonStandardTimeUnit.MONTH);
  static const YEAR =
      const TimeHelper._internal('year', NonStandardTimeUnit.YEAR);

  static const TIME_UNITS = [
    HOUR,
    DAY,
    WEEK,
    MONTH,
    YEAR,
  ];

  static const MONTH_LENGTHS = [
    31, //January
    28, //February
    31, //March
    30, //April
    31, //May
    30, //June
    31, //July
    31, //August
    30, //September
    31, //October
    30, //November
    31, //December
  ];
}
