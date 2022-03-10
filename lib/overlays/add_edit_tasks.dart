import 'package:intl/intl.dart';
import 'package:tweak/overlays/alert_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';
import 'package:tweak/classes/tasks_data.dart';
import 'package:tweak/widgets/custom_drop_down.dart';
import 'package:tweak/widgets/custom_text_field.dart';
import 'package:tweak/widgets/editable_time.dart';
import 'package:tweak/widgets/rounded_button.dart';
import 'package:tweak/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:tweak/classes/categories.dart';
import 'package:tweak/classes/category.dart';

class AddEditTask extends StatefulWidget {
  AddEditTask({Key? key, this.edit = false, this.index = 0}) : super(key: key);

  bool edit;
  int index;

  @override
  _AddEditTaskState createState() => _AddEditTaskState();

  void then() {}
}

class _AddEditTaskState extends State<AddEditTask> {
  DateTime? startDateTime;
  DateTime? beginDateTime;
  DateTime? endDateTime;
  String taskCategory = 'work';
  String? prevTaskCategory;
  String? taskName;
  String? taskDesc;
  Duration? duration;
  bool trimCurrentTaskStartTime = true; // Trim the new task or the previous one
  bool overlappingTasks = false; // Are the tasks overlapping?
  bool addTaskOverlap =
      true; // Should I handle the overlap or should it be cancelled
  final DateFormat timeExtractor = DateFormat('jm');
  final DateFormat dateExtractor = DateFormat('MMM d, yy');
  late Map<String, Category> categories;
  @override
  void initState() {
    super.initState();
    getStartAndEndTime();
    if (widget.edit == true) {
      getTaskData();
    }
  }

  void getTaskData() {
    TaskTile task =
        Provider.of<Tasks>(context, listen: false).getTasks[widget.index];
    taskName = task.getTaskName;
    taskDesc = task.getTaskDesc;
    startDateTime = task.getStartDateTime;
    endDateTime = task.getEndDateTime;
    prevTaskCategory = task.getTaskCategory;
    taskCategory = task.getTaskCategory;
    duration = task.getDuration;
  }

  void getStartAndEndTime() {
    List<TaskTile> tasks = Provider.of<Tasks>(context, listen: false).getTasks;
    DateTime now = DateTime.now();
    if (tasks.isNotEmpty) {
      TaskTile lastTask = tasks[tasks.length - 1];
      startDateTime = lastTask.getEndDateTime;
      Duration diff = now.difference(lastTask.getEndDateTime);
      DateTime dt = diff.inSeconds < 0 ? lastTask.getEndDateTime : now;
      endDateTime = dt;
    } else {
      Map<String, Category> categories =
          Provider.of<Categories>(context, listen: false).getCategories;

      DateTime dt = DateTime.now();
      categories.forEach((key, value) {
        if (key != 'sleep prev night') {
          dt.subtract(value.getTimePassed);
        }
      });
      beginDateTime =
          Provider.of<Categories>(context, listen: false).getBeginDateTime;
      startDateTime =
          Provider.of<Categories>(context, listen: false).getBeginDateTime;
      endDateTime = now;
    }
  }

  void manageTime(Map<String, Category> categories) {
    duration = duration ?? endDateTime!.difference(startDateTime!);
    if (duration!.inSeconds > 0) {
      categories[taskCategory]!.addTime(dt: duration!);
      categories[Provider.of<Categories>(context, listen: false)
              .getCurrentUserState]!
          .subtractTime(dt: duration!);
    }
  }

  void addEditTask() {
    if (addTaskOverlap) {
      if (widget.edit == false) {
        Provider.of<Tasks>(context, listen: false).addTask(
          trimCurrentTaskStartTime: trimCurrentTaskStartTime,
          task: TaskTile(
            id: Provider.of<Tasks>(context, listen: false).nTasks,
            startDateTime: startDateTime!,
            endDateTime: endDateTime!,
            taskName: taskName ?? categories[taskCategory]!.getHintText,
            taskDesc: taskDesc ?? categories[taskCategory]!.getHintDesc,
            taskCategory: taskCategory,
            duration: duration,
            baseColor: categories[taskCategory]!.getCategoryColor,
          ),
        );
      } else {
        duration = endDateTime!.difference(startDateTime!);
        Provider.of<Categories>(context, listen: false)
            .getCategories[prevTaskCategory]!
            .subtractTime(dt: duration!);
        Provider.of<Categories>(context, listen: false)
            .getCategories[taskCategory]!
            .addTime(dt: duration!);
        Provider.of<Tasks>(context, listen: false).editTask(
          index: widget.index,
          trimCurrentTaskStartTime: trimCurrentTaskStartTime,
          taskOverlapping: overlappingTasks,
          task: TaskTile(
            id: widget.index,
            startDateTime: startDateTime!,
            endDateTime: endDateTime!,
            taskName: taskName ?? categories[taskCategory]!.getHintText,
            taskDesc: taskDesc ?? categories[taskCategory]!.getHintDesc,
            taskCategory: taskCategory,
            duration: duration,
            baseColor: categories[taskCategory]!.getCategoryColor,
          ),
        );
      }
    }

    trimCurrentTaskStartTime = true;
    overlappingTasks = false;
    addTaskOverlap = true;
  }

  List<DropdownMenuItem<String>> getItems() {
    List<DropdownMenuItem<String>> items = [];
    Iterable<String> categories =
        Provider.of<Categories>(context).getCategories.keys;
    for (int i = 0; i < categories.length; i++) {
      if (i == 1) continue;
      items.add(
        DropdownMenuItem(
          alignment: Alignment.center,
          child: Text(
            categories.elementAt(i),
            style: kInfoTextStyle.copyWith(color: kWhite),
          ),
          value: categories.elementAt(i),
          onTap: () {
            taskCategory = categories.elementAt(i);
          },
        ),
      );
    }
    return items;
  }

  String durationExtractor(Duration diff) {
    if (diff.inHours > 0) {
      return '${diff.inHours}h';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}min';
    } else {
      return '${diff.inSeconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    categories = Provider.of<Categories>(context).getCategories;

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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateExtractor.format(startDateTime!),
                                style: kInfoTextStyle.copyWith(
                                    color: kWhite, fontSize: 8),
                              ),
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
                                              .inSeconds < // end Time is before start time
                                          0) {
                                        endDateTime = endDateTime!.add(
                                            const Duration(
                                                days:
                                                    1)); // Next day (After midnight)
                                      }
                                      if (Provider.of<Tasks>(context,
                                                  listen: false)
                                              .nTasks >
                                          0) {
                                        TaskTile lastTask = Provider.of<Tasks>(
                                                context,
                                                listen: false)
                                            .getLastTask;
                                        Duration diff = startDateTime!
                                            .difference(
                                                lastTask.getEndDateTime);
                                        if (diff.inSeconds < 0) {
                                          overlappingTasks = true;
                                        }
                                      } else {
                                        beginDateTime;
                                        categories['sleep prev night']!
                                            .subtractTime(
                                                dt: beginDateTime!.difference(
                                                    startDateTime!));
                                      }
                                    });
                                  }),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              ' - ',
                              style: kInfoTextStyle.copyWith(
                                  color: kWhite, fontWeight: FontWeight.w700),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dateExtractor.format(endDateTime!),
                                style: kInfoTextStyle.copyWith(
                                    color: kWhite, fontSize: 8),
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
                                        endDateTime = endDateTime!.add(
                                            const Duration(
                                                days:
                                                    1)); // Next Day (After Midnight)
                                      }
                                    });
                                  }),
                            ],
                          )
                        ],
                      ),
                      Text(
                          durationExtractor(
                              endDateTime!.difference(startDateTime!)),
                          style: kInfoTextStyle.copyWith(
                              color: kWhite, fontWeight: FontWeight.w700))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomDropDown(
                        items: getItems(),
                        val: taskCategory,
                        onChanged: (val) {
                          setState(() {
                            taskCategory = val as String;
                          });
                        }),
                  ),
                  CustomTextField(
                    hintText: 'Task name...',
                    initTextVal: taskName,
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
                    initTextVal: taskDesc,
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
                                            color: kBaseColor),
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
                                            color: kBaseColor),
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
                                            color: kBaseColor),
                                      ),
                                    )
                                  ]);
                            }).then((_) {
                          if (widget.edit == false) {
                            manageTime(categories);
                          }
                          addEditTask();
                          Navigator.pop(context);
                        });
                      } else {
                        if (widget.edit == false) {
                          manageTime(categories);
                        }
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
