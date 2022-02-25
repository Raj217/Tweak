import 'package:intl/intl.dart';
import 'package:tweak/overlays/alert_dialog_box.dart';
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

  void then() {}
}

class _AddEditTaskState extends State<AddEditTask> {
  DateTime? startDateTime;
  DateTime? endDateTime;
  String? taskName;
  String? taskDesc;
  String taskCategory = 'work';
  Duration? duration;
  bool trimCurrentTaskStartTime = true;
  bool overlappingTasks = false;
  bool addTaskOverlap = true; // For handling cancel
  final DateFormat timeExtractor = DateFormat('jm');

  @override
  void initState() {
    super.initState();
    getStartAndEndTime();
    if (widget.edit == true) {
      getTaskData();
    }
  }

  void changeTaskName() {
    if (taskCategory == categories.work.toString().substring(11)) {
      taskName = 'Unknown Task';
    } else if (taskCategory == categories.sleep.toString().substring(11)) {
      taskName = 'Sleep';
    } else if (taskCategory == categories.rest.toString().substring(11)) {
      taskName = 'Rest';
    } else if (taskCategory ==
        categories.unregistered.toString().substring(11)) {
      taskName = 'Unregistered Task';
    } else if (taskCategory == categories.timeWaste.toString().substring(11)) {
      taskName = 'Time Waste';
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

  void manageTime() {
    duration = duration ?? endDateTime!.difference(startDateTime!);
    if (taskCategory == categories.sleep.toString().substring(11)) {
      Provider.of<Time>(context, listen: false)
          .addSleepTime(duration: duration!);
    } else if (taskCategory == categories.rest.toString().substring(11)) {
      Provider.of<Time>(context, listen: false)
          .addRestTime(duration: duration!);
    } else if (taskCategory == categories.timeWaste.toString().substring(11)) {
      Provider.of<Time>(context, listen: false)
          .addWasteTime(duration: duration!);
    }
  }

  void addEditTask() {
    if (addTaskOverlap) {
      if (widget.edit == false) {
        Provider.of<Tasks>(context, listen: false).addTask(
          trimCurrentTaskStartTime: trimCurrentTaskStartTime,
          task: TaskTile(
            index: Provider.of<Tasks>(context, listen: false).nTasks,
            startDateTime: startDateTime!,
            endDateTime: endDateTime!,
            taskName: taskName,
            taskDesc: taskDesc,
            taskCategory: taskCategory,
            duration: duration,
          ),
        );
      } else {
        duration = endDateTime!.difference(startDateTime!);
        Provider.of<Tasks>(context, listen: false).editTask(
          index: widget.index,
          trimCurrentTaskStartTime: trimCurrentTaskStartTime,
          taskOverlapping: overlappingTasks,
          task: TaskTile(
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
    }

    trimCurrentTaskStartTime = true;
    overlappingTasks = false;
    addTaskOverlap = true;
  }

  @override
  Widget build(BuildContext context) {
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
                                  if (Provider.of<Tasks>(context, listen: false)
                                          .nTasks >
                                      0) {
                                    TaskTile lastTask = Provider.of<Tasks>(
                                            context,
                                            listen: false)
                                        .getLastTask;
                                    Duration diff = startDateTime!
                                        .difference(lastTask.endDateTime);
                                    if (diff.inSeconds < 0) {
                                      overlappingTasks = true;
                                    }
                                  } else {
                                    DateTime beginDateTime = Provider.of<Time>(
                                            context,
                                            listen: false)
                                        .getBeginDateTime!;
                                    Provider.of<Time>(context, listen: false)
                                        .subtractSleepTime(
                                            duration: beginDateTime
                                                .difference(startDateTime!),
                                            subtractPrevDay: true);
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
                    child: CustomDropDown(
                        val: taskCategory,
                        onChanged: (val) {
                          setState(() {
                            taskCategory = val as String;
                            changeTaskName();
                          });
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
                      if (overlappingTasks) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialogBox(
                                  textTitle: 'Warning',
                                  textContent:
                                      'Your current task starting time is before ending of your previous task. Which one do you want to trim?',
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        addTaskOverlap = false;
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: kInfoTextStyle.copyWith(
                                            color: kLightBlue),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        trimCurrentTaskStartTime = true;
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Current Task',
                                        style: kInfoTextStyle.copyWith(
                                            color: kLightBlue),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        trimCurrentTaskStartTime = false;
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Prev Task',
                                        style: kInfoTextStyle.copyWith(
                                            color: kLightBlue),
                                      ),
                                    )
                                  ]);
                            }).then((_) {
                          manageTime();
                          addEditTask();
                          Navigator.pop(context);
                        });
                      } else {
                        manageTime();
                        addEditTask();
                        Navigator.pop(context);
                      }
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
