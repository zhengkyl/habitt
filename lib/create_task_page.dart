import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'task.dart';

class CreateTaskPage extends StatefulWidget {
  static const routeName = '/createTask';
  final Task editedTask;
  CreateTaskPage({this.editedTask});
  @override
  _CreateTaskPageState createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final titleController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final intervalController = TextEditingController(text: '1');
  var dropdownValue = TimeHelper.DAY;
  bool hasTaskRepeat = true;
  bool hasGoalQuantity = true;
  bool isTaskPositive = true;
  ColorPair colorPair = ColorPair.YELLOW;
  DateTime resetDate;
  DateTime startDate;
  @override
  void initState() {
    super.initState();
    if (widget.editedTask != null) {
      colorPair = widget.editedTask.colorPair;
      titleController.text = widget.editedTask.title;

      dropdownValue = widget.editedTask.timeUnit;

      hasGoalQuantity = widget.editedTask.goalQuantity > 0;
      hasTaskRepeat = widget.editedTask.timeCoefficient > 0;

      quantityController.text =
          hasGoalQuantity ? widget.editedTask.goalQuantity.toString() : '1';
      intervalController.text =
          hasTaskRepeat ? widget.editedTask.timeCoefficient.toString() : '1';

      resetDate = widget.editedTask.resetDate;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    quantityController.dispose();
    intervalController.dispose();
    super.dispose();
  }

  Widget _buildTaskTitleTextField() {
    return TextFormField(
      //validator: (t) => 'You done fucked up',
      controller: titleController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Task Title',
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8.0)),
        fillColor: Colors.blue[50],
        filled: true,
      ),
      style: TextStyle(
        fontSize: 24.0,
      ),
    );
  }

  Widget _buildGoalQuantitySwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          isTaskPositive ? 'Goal Quantity' : 'Limit Quanity',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        Switch(
          value: hasGoalQuantity,
          onChanged: (bool value) {
            setState(() {
              hasGoalQuantity = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildQuantitySelectorRow() {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: FlatButton(
            onPressed: int.parse(quantityController.text) > 1
                ? () {
                    int value = int.parse(quantityController.text);
                    setState(() {
                      quantityController.text = (value - 1).toString();
                    });
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(Icons.remove),
            ),
            shape: CircleBorder(),
            color: Colors.purple[50],
            disabledColor: Colors.grey[100],
          ),
        ),
        Expanded(
          child: TextFormField(
            textAlign: TextAlign.center,
            controller: quantityController,
            validator: (t) => 'You done fucked up',
            keyboardType:
                TextInputType.numberWithOptions(decimal: false, signed: false),
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Quantity',
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8.0)),
              fillColor: Colors.blue[50],
              filled: true,
            ),
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: FlatButton(
            onPressed: () {
              int value = int.parse(quantityController.text);
              setState(() {
                quantityController.text = (value + 1).toString();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(Icons.add),
            ),
            shape: CircleBorder(),
            color: Colors.purple[50],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskRepeatSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Repeat',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        Switch(
          value: hasTaskRepeat,
          onChanged: (bool value) {
            setState(() {
              hasTaskRepeat = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildRepeatIntervalSelector() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Container(
            margin: EdgeInsets.only(right: 8.0),
            child: TextFormField(
              textAlign: TextAlign.center,
              controller: intervalController,
              //validator: (t) => 'You done fucked up',
              keyboardType: TextInputType.numberWithOptions(
                  decimal: false, signed: false),
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Interval',
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8.0)),
                fillColor: Colors.blue[50],
                filled: true,
              ),
              style: TextStyle(
                fontSize: 24.0,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            decoration: ShapeDecoration(
                color: Colors.blue[50],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                )),
            //color: Colors.blue[50],
            margin: EdgeInsets.only(left: 8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<TimeHelper>(
                isExpanded: true,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 28.0),
                value: dropdownValue,
                items: TimeHelper.TIME_UNITS
                    .map<DropdownMenuItem<TimeHelper>>((unit) {
                  return DropdownMenuItem(
                    value: unit,
                    child: Text(
                      unit.name,
                      //textAlign: TextAlign.center,
                    ),
                  );
                }).toList(),
                onChanged: (TimeHelper value) {
                  setState(() {
                    dropdownValue = value;
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSelector() {
    return Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Text(
          widget.editedTask == null ? 'Starting' : 'Next reset',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
      Container(
          decoration: BoxDecoration(
              color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
          child: widget.editedTask == null
              ? FlatButton(
                  child: Text(
                    startDate == null
                        ? 'Right now'
                        : '${DateFormat('MMM d, y').format(startDate)} ${startDate.hour > 12 ? startDate.hour - 12 : startDate.hour == 0 ? '12' : startDate.hour}:${startDate.minute.toString().padLeft(2, '0')}${startDate.hour < 12 ? 'am' : 'pm'}',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () => showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: startDate == null ? DateTime.now() : startDate,
                    lastDate: DateTime(6969),
                  ).then((newDate) {
                    if (newDate != null) {
                      showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),)
                          .then((newTime) {
                        if (newTime != null) {
                          setState(() {
                            startDate = DateTime(newDate.year, newDate.month,
                                newDate.day, newTime.hour, newTime.minute);
                          });
                        }
                      });
                    }
                  }),
                )
              : FlatButton(
                  child: Text(
                    '${DateFormat('MMM d, y').format(resetDate)} ${resetDate.hour > 12 ? resetDate.hour - 12 : resetDate.hour == 0 ? '12' : resetDate.hour}:${resetDate.minute.toString().padLeft(2, '0')}${resetDate.hour < 12 ? 'am' : 'pm'}',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () => showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    initialDate: resetDate,
                    lastDate: DateTime(6969),
                  ).then((newDate) {
                    if (newDate != null) {
                      showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(resetDate))
                          .then((newTime) {
                        if (newTime != null) {
                          setState(() {
                            resetDate = DateTime(newDate.year, newDate.month,
                                newDate.day, newTime.hour, newTime.minute);
                          });
                        }
                      });
                    }
                  }),
                )),
    ]);
  }

  Widget _buildTaskAlignmentSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Negative Habit',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        Switch(
          value: isTaskPositive,
          onChanged: (bool value) {
            setState(() {
              isTaskPositive = value;
            });
          },
        ),
        Text(
          'Positive Habit',
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            child: Text(
              'SAVE',
              style: TextStyle(fontSize: 18.0),
            ),
            shape: CircleBorder(),
            onPressed: () {
              String title = titleController.text.trim().isNotEmpty
                  ? titleController.text.trim()
                  : 'Untitled Task';
              int goalQuantity =
                  hasGoalQuantity ? int.parse(quantityController.text) : 0;
              int time = hasTaskRepeat ? int.parse(intervalController.text) : 0;
              TimeHelper unit = dropdownValue;
              if (widget.editedTask != null) {
                widget.editedTask.title = title;
                widget.editedTask.goalQuantity = goalQuantity;
                widget.editedTask.timeCoefficient = time;
                widget.editedTask.timeUnit = unit;
                widget.editedTask.startDate = startDate;
                widget.editedTask.colorPair = colorPair;
                widget.editedTask.resetDate = resetDate;
                widget.editedTask.isPositive = isTaskPositive;
                Navigator.pop(context);
              } else {
                Navigator.pop(
                  context,
                  Task(
                    title: title,
                    goalQuantity: goalQuantity,
                    timeCoefficient: time,
                    timeUnit: unit,
                    startDate: startDate == null ? DateTime.now() : startDate,
                    colorPair: colorPair,
                    isPositive: isTaskPositive,
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: ListView(children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: _buildTaskTitleTextField(),
          ),
          _buildTaskAlignmentSwitch(),
          _buildGoalQuantitySwitch(),
          hasGoalQuantity
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildQuantitySelectorRow(),
                )
              : Container(),
          _buildTaskRepeatSwitch(),
          hasTaskRepeat
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: _buildRepeatIntervalSelector(),
                )
              : Container(),
          hasTaskRepeat ? _buildDateTimeSelector() : Container(),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8.0),
            child: Text(
              'Task Color',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ColorPair.COLOR_PAIRS
                .map((pair) => Column(
                      children: <Widget>[
                        Container(
                          width: 16,
                          height: 16,
                          color: pair.primaryColor,
                        ),
                        Radio(
                          //title: Text(pair.title),
                          value: pair,
                          groupValue: colorPair,
                          onChanged: (ColorPair value) {
                            setState(() {
                              colorPair = value;
                            });
                          },
                        ),
                      ],
                    ))
                .toList(),
          ),
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16, top: 32),
            child: RaisedButton(
              child: Text(
                'DELETE',
                style: TextStyle(
                  color: Colors.white,
                  //fontSize: 16.0,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0)),
              color: Colors.red[400],
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Delete this task?'),
                        content:
                            Text('Do you really want to delete this task?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Yeet it'),
                            onPressed: () {
                              //Here is some quality code
                              Navigator.pop(
                                context,
                              );
                              Navigator.pop(
                                context,
                                widget.editedTask,
                              );
                            },
                          ),
                          FlatButton(
                            child: Text('wait no'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
            ),
          ),
        ]),
      ),
    );
  }
}

