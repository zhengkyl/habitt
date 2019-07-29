import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'task.dart';

class CreateTaskPage extends StatefulWidget {
  static const routeName = '/createTask';
  final Task editedTask;
  //Not using a key, because I don't know how to use them and it fucks this up somehow
  //TODO maybe need to add a key to implement reorderable task list
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
  @override
  void initState() {
    super.initState();
    if (widget.editedTask != null) {
      titleController.text = widget.editedTask.title;

      dropdownValue = widget.editedTask.timeUnit;

      hasGoalQuantity = widget.editedTask.goalQuantity > 0;
      hasTaskRepeat = widget.editedTask.timeCoefficient > 0;

      quantityController.text =
          hasGoalQuantity ? widget.editedTask.goalQuantity.toString() : '1';
      intervalController.text =
          hasTaskRepeat ? widget.editedTask.timeCoefficient.toString() : '1';
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
            borderRadius: BorderRadius.circular(12.0)),
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
          'Goal Quantity',
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
                  borderRadius: BorderRadius.circular(12.0)),
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
                    borderRadius: BorderRadius.circular(12.0)),
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
                  borderRadius: BorderRadius.circular(12.0),
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
                items:
                    TimeHelper.timeUnits.map<DropdownMenuItem<TimeHelper>>((unit) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          FlatButton(
            child: Text(
              'SAVE',
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
            shape: CircleBorder(),
            onPressed: () {
              String title = titleController.text.trim().isNotEmpty ? titleController.text.trim() : 'Untitled Task';
              int goalQuantity =
                  hasGoalQuantity ? int.parse(quantityController.text) : 0;
              int time = hasTaskRepeat ? int.parse(intervalController.text) : 0;
              TimeHelper unit = dropdownValue;
              DateTime startDate = DateTime.now();
              //TODO add color picker / random list
              Color color = Color(0xffffff99);
              if (widget.editedTask != null) {
                widget.editedTask.title = title;
                widget.editedTask.goalQuantity = goalQuantity;
                widget.editedTask.timeCoefficient = time;
                widget.editedTask.timeUnit = unit;
                widget.editedTask.startDate = startDate;
                widget.editedTask.color = color;
                Navigator.pop(context);
              } else {
                Navigator.pop(
                  context,
                  Task(
                    title: title,
                    goalQuantity: goalQuantity,
                    timeCoefficient: time,
                    timeUnit: unit,
                    startDate: startDate,
                    color: color,
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
          Container(
            margin: EdgeInsets.all(16.0),
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
                Navigator.pop(
                  context,
                  widget.editedTask,
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
//TODO LIST
//countdown + reset on interval
//form + validate title

