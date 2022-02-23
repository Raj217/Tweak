import 'package:intl/intl.dart';
import 'package:tweak/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';
import 'package:tweak/utils/tasks_data.dart';
import 'package:tweak/widgets/custom_drop_down.dart';
import 'package:tweak/widgets/custom_text_field.dart';
import 'package:tweak/widgets/editable_time.dart';
import 'package:tweak/widgets/rounded_button.dart';
import 'package:tweak/widgets/task_tile.dart';
import 'package:provider/provider.dart';

class AddEditTask extends StatefulWidget {
  AddEditTask({Key? key, bool this.edit = false, int this.index = 0})
      : super(key: key);

  bool edit;
  int index;

  @override
  _AddEditTaskState createState() => _AddEditTaskState();
}

class _AddEditTaskState extends State<AddEditTask> {
  DateTime? startDateTime;
  DateTime? endDateTime;
  String? taskName;
  String? taskDesc;
  String taskCategory = 'work';
  Duration? duration;
  final DateFormat timeExtractor = DateFormat('jm');

  @override
  void initState() {
    super.initState();
    getStartAndEndTime();
  }

  void changeTaskName() {
    switch (taskCategory) {
      case 'work':
        taskName = 'Unknown Task';
        break;
      case 'sleep':
        taskName = 'Sleep';
        break;
      case 'rest':
        taskName = 'Rest';
        break;
    }
  }

  void getTaskData() {
    TaskTile task =
        Provider.of<Tasks>(context, listen: false).getTasks[widget.index];
    startDateTime = task.startDateTime;
    endDateTime = task.endDateTime;
    taskName = task.taskName;
    taskDesc = task.taskDesc;
    taskCategory = task.taskCategory;
    duration = task.duration;
  }

  void getStartAndEndTime() {
    List<TaskTile> tasks = Provider.of<Tasks>(context, listen: false).getTasks;
    DateTime now = DateTime.now();
    if (tasks.isNotEmpty) {
      TaskTile lastTask = tasks[tasks.length - 1];
      startDateTime = lastTask.endDateTime;
      Duration diff = now.difference(lastTask.endDateTime);
      DateTime dt = diff.inSeconds < 0 ? lastTask.endDateTime : now;
      endDateTime = dt;
    } else {
      DateTime? dt = Provider.of<Time>(context, listen: false).getBeginDateTime;
      startDateTime = dt ?? now;
      endDateTime = now;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.edit == true) {
      getTaskData();
    }
    return Center(
      child: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Container(
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
                              text: timeExtractor
                                  .format(startDateTime!)
                                  .toLowerCase(),
                              timeVal: startDateTime!,
                              onChange: (_) {},
                              onChangeDateTime: (time) {
                                setState(() {
                                  startDateTime = time;
                                  if (endDateTime!
                                          .difference(startDateTime!)
                                          .inSeconds <
                                      0) {
                                    endDateTime = startDateTime;
                                  }
                                });
                              }),
                          Text(
                            ' - ',
                            style: kInfoTextStyle.copyWith(
                                color: kWhite, fontWeight: FontWeight.w700),
                          ),
                          EditableTime(
                              text: timeExtractor
                                  .format(endDateTime!)
                                  .toLowerCase(),
                              timeVal: endDateTime!,
                              onChange: (_) {},
                              onChangeDateTime: (time) {
                                setState(() {
                                  endDateTime = time;
                                  if (endDateTime!
                                          .difference(startDateTime!)
                                          .inSeconds <
                                      0) {
                                    endDateTime = startDateTime;
                                  }
                                });
                              }),
                        ],
                      ),
                      Text(
                          Time.durationExtractor(
                              endDateTime!.difference(startDateTime!)),
                          style: kInfoTextStyle.copyWith(
                              color: kWhite, fontWeight: FontWeight.w700))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomDropDown(onChanged: (val) {
                      taskCategory = val as String;
                      changeTaskName();
                    }),
                  ),
                  CustomTextField(
                    hintText: 'Task name...',
                    initVal: taskName,
                    verticalPadding: 3,
                    onChanged: (text) {
                      setState(() {
                        taskName = text;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    hintText: 'Task Description...',
                    initVal: taskDesc,
                    maxLines: 6,
                    onChanged: (text) {
                      setState(() {
                        taskDesc = text;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  RoundedButton(
                    text: widget.edit == true ? 'Edit Task' : 'Add Task',
                    onPressed: () {
                      duration =
                          duration ?? endDateTime!.difference(startDateTime!);
                      if (taskCategory == 'sleep') {
                        Provider.of<Time>(context, listen: false)
                            .addSleepTime(duration: duration!);
                      } else if (taskCategory == 'rest') {
                        Provider.of<Time>(context, listen: false)
                            .addRestTime(duration: duration!);
                      }
                      if (widget.edit == false) {
                        Provider.of<Tasks>(context, listen: false).addTask(
                          TaskTile(
                            index: Provider.of<Tasks>(context, listen: false)
                                .nTasks,
                            startDateTime: startDateTime!,
                            endDateTime: endDateTime!,
                            taskName: taskName,
                            taskDesc: taskDesc,
                            taskCategory: taskCategory,
                            duration: duration,
                          ),
                        );
                      } else {
                        Provider.of<Tasks>(context, listen: false).editTask(
                          widget.index,
                          TaskTile(
                            index: widget.index,
                            startDateTime: startDateTime!,
                            endDateTime: endDateTime!,
                            taskName: taskName,
                            taskDesc: taskDesc,
                            taskCategory: taskCategory,
                            duration: duration,
                          ),
                        );
                      }
                      Navigator.pop(context);
                    },
                    textStyle: kButtonTextStyle.copyWith(fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
