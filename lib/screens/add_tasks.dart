import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';
import 'package:tweak/utils/tasks_data.dart';
import 'package:tweak/widgets/custom_text_field.dart';
import 'package:tweak/widgets/editable_time.dart';
import 'package:tweak/widgets/rounded_button.dart';
import 'package:tweak/widgets/task_tile.dart';
import 'package:provider/provider.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TimeOfDay startTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 9, minute: 0);
  String taskName = '';
  String taskDesc = '';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 450,
        width: 300,
        decoration: const BoxDecoration(
          color: kGrayBG,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      EditableTime(
                          text: startTime.format(context).toLowerCase(),
                          timeVal: TimeOfDay(hour: 1, minute: 1),
                          onChange: (time) {
                            setState(() {
                              startTime = time;
                            });
                          }),
                      Text(
                        ' - ',
                        style: kInfoTextStyle.copyWith(
                            color: kWhite, fontWeight: FontWeight.w700),
                      ),
                      EditableTime(
                          text: endTime
                              .format(context)
                              .toLowerCase(), // TODO: Make time vals variable
                          timeVal: TimeOfDay(hour: 1, minute: 1),
                          onChange: (time) {
                            setState(() {
                              endTime = time;
                            });
                          }),
                    ],
                  ),
                  Text('1 hr', // TODO: Add duration variable
                      style: kInfoTextStyle.copyWith(
                          color: kWhite, fontWeight: FontWeight.w700))
                ],
              ),
              const SizedBox(height: 50),
              CustomTextField(
                onChanged: (text) {
                  setState(() {
                    taskName = text;
                  });
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: CustomTextField(
                  onChanged: (text) {
                    setState(() {
                      taskDesc = text;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              RoundedButton(
                text: 'Add Task',
                onPressed: () {
                  Provider.of<Tasks>(context, listen: false).addTask(TaskTile(
                      startTime: startTime.format(context).toLowerCase(),
                      endTime: endTime.format(context).toLowerCase(),
                      taskName: taskName,
                      duration: DateTime.parse(endTime.format(context))
                          .difference(DateTime.parse(startTime.format(context)))
                          .toString()));
                  Navigator.pop(context);
                },
                textStyle: kButtonTextStyle.copyWith(fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
