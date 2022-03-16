import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tweak/classes/categories.dart';
import 'package:tweak/classes/category.dart';
import 'package:tweak/overlays/add_edit_tasks.dart';
import 'package:tweak/overlays/alert_dialog_box.dart';
import 'package:tweak/overlays/showDesc.dart';
import 'package:tweak/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tweak/classes/tasks_data.dart';

class TaskTile extends StatelessWidget {
  late int _id;
  late DateTime _startDateTime;
  late DateTime _endDateTime;
  late String _taskName;
  late String _taskDesc;
  late String _taskCategory;
  Color? _baseColor;
  Duration? _duration;

  // ------------------------------ Initialisation -----------------------------
  TaskTile({
    required int id,
    required DateTime startDateTime,
    required DateTime endDateTime,
    required String taskName,
    required String taskDesc,
    required String taskCategory,
    Color? baseColor,
    Duration? duration,
  }) {
    _id = id;
    _startDateTime = startDateTime;
    _endDateTime = endDateTime;
    _taskName = taskName;
    _taskDesc = taskDesc;
    _taskCategory = taskCategory;
    _baseColor = baseColor ?? kBaseColor;
    _duration = duration ?? const Duration(seconds: 0);
  }

  // Constants
  final DateFormat timeExtractor = DateFormat('h:mm a');
  final DateFormat dateExtractor = DateFormat('MMM d, yy');

  // ----------------------------- Public Methods -------------------------------

  // -------------- Return Data --------------
  int get getId {
    return _id;
  }

  DateTime get getStartDateTime {
    return _startDateTime;
  }

  DateTime get getEndDateTime {
    return _endDateTime;
  }

  String get getTaskName {
    return _taskName;
  }

  String get getTaskDesc {
    return _taskDesc;
  }

  String get getTaskCategory {
    return _taskCategory;
  }

  Color get getTaskColor {
    return _baseColor ?? kBaseColor;
  }

  Duration get getDuration {
    return _duration!;
  }

  Map<String, String> get getDataToSave {
    Map<String, String> data = {
      'id': _id.toString(),
      'startDateTime': _startDateTime.toString(),
      'endDateTime': _endDateTime.toString(),
      'taskName': _taskName,
      'taskDesc': _taskDesc,
      'durationSecs': _duration!.inSeconds.toString(),
      'taskCategory': _taskCategory,
      'red': _baseColor!.red.toString(),
      'green': _baseColor!.green.toString(),
      'blue': _baseColor!.blue.toString(),
      'opacity': _baseColor!.opacity.toString()
    };

    return data;
  }

  // -------------- Change Class Variables' value --------------
  TaskTile get getCurrentTask {
    return TaskTile(
        id: _id,
        startDateTime: _startDateTime,
        endDateTime: _endDateTime,
        taskName: _taskName,
        taskDesc: _taskDesc,
        taskCategory: _taskCategory,
        duration: _duration,
        baseColor: _baseColor);
  }

  TaskTile setId(int id) {
    _id = id;
    return getCurrentTask;
  }

  TaskTile setStartDateTime(DateTime dt) {
    _startDateTime = dt;
    return getCurrentTask;
  }

  TaskTile setEndDateTime(DateTime dt) {
    _endDateTime = dt;
    return getCurrentTask;
  }

  TaskTile setTaskName(String taskName) {
    _taskName = taskName;
    return getCurrentTask;
  }

  TaskTile setTaskDesc(String taskDesc) {
    _taskDesc = taskDesc;
    return getCurrentTask;
  }

  TaskTile setTaskCategory(String taskCat) {
    _taskCategory = taskCat;
    return getCurrentTask;
  }

  TaskTile setIndex(int i) {
    _id = i;
    return getCurrentTask;
  }

  TaskTile _setDuration() {
    _duration = _duration ?? _endDateTime.difference(_startDateTime);
    return getCurrentTask;
  }

  // ----------------------------- Static Methods -----------------------------
  static TaskTile parse({
    required Map<String, dynamic> data,
  }) {
    return TaskTile(
      id: int.parse(data['id']!),
      startDateTime: DateTime.parse(data['startDateTime']!),
      endDateTime: DateTime.parse(data['endDateTime']!),
      taskName: data['taskName']!,
      taskDesc: data['taskDesc']!,
      duration: Duration(
        seconds: int.parse(data['durationSecs']!),
      ),
      taskCategory: data['taskCategory']!,
      baseColor: Color.fromRGBO(
          int.parse(data['red']),
          int.parse(data['green']),
          int.parse(data['blue']),
          double.parse(data['opacity'])),
    );
  }

  @override
  Widget build(BuildContext context) {
    _setDuration();
    _baseColor ??= Provider.of<Categories>(context, listen: false)
        .getCategories[_taskCategory]!
        .getCategoryColor;
    return GestureDetector(
      onDoubleTap: () {
        showModalBottomSheet(
          // Bring up the editable screen to change prev data
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => AddEditTask(
            edit: true,
            index: _id,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 15),
        child: Column(
          children: [
            IntrinsicWidth(
              child: Row(
                children: [
                  IntrinsicWidth(
                    child: Column(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dateExtractor.format(_startDateTime),
                                        style: kInfoTextStyle.copyWith(
                                            fontSize: 8, color: _baseColor),
                                      ),
                                      Text(timeExtractor.format(_startDateTime),
                                          style: kInfoTextStyle.copyWith(
                                              color: _baseColor)),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, right: 4, top: 10.0),
                                    child: Text('-',
                                        style: kInfoTextStyle.copyWith(
                                          color: _baseColor,
                                        )),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        dateExtractor.format(_endDateTime),
                                        style: kInfoTextStyle.copyWith(
                                            fontSize: 8, color: _baseColor),
                                      ),
                                      Text(timeExtractor.format(_endDateTime),
                                          style: kInfoTextStyle.copyWith(
                                              color: _baseColor)),
                                    ],
                                  ),
                                ],
                              ),
                              Text(
                                Category().getTimeFormatted(diff: _duration!),
                                style:
                                    kInfoTextStyle.copyWith(color: _baseColor),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              _taskName,
                              style: kInfoTextStyle.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  color: _baseColor),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            bool deleteTask = false;
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialogBox(
                                      textTitle: 'Warning',
                                      textContent:
                                          'You are about to delete the current task',
                                      actions: [
                                        TextButton(
                                          onPressed: () {
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
                                            deleteTask = true;
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Confirm',
                                            style: kInfoTextStyle.copyWith(
                                                color: kRed),
                                          ),
                                        )
                                      ]);
                                }).then((val) {
                              if (deleteTask) {
                                if (_duration!.inSeconds > 0) {
                                  Map<String, Category> categories =
                                      Provider.of<Categories>(context,
                                              listen: false)
                                          .getCategories;

                                  categories[_taskCategory]!.subtractTime(
                                      dt: _duration!); // Subtract time from the category of task which was deleted
                                  if (Provider.of<Tasks>(context, listen: false)
                                          .nTasks >
                                      1) {
                                    categories[Provider.of<Categories>(context,
                                                listen: false)
                                            .getCurrentUserState]!
                                        .addTime(
                                            dt: _duration!); // Add that time to what the user is currently doing
                                  } else {
                                    print('yo');
                                    Duration durationForCurrentTask =
                                        DateTime.now().difference(
                                            Provider.of<Categories>(context,
                                                    listen: false)
                                                .getBeginDateTime);
                                    Duration durationSleepNightTrimmed =
                                        _duration! - durationForCurrentTask;

                                    categories[Provider.of<Categories>(context,
                                                listen: false)
                                            .getCurrentUserState]!
                                        .addTime(
                                            dt: durationForCurrentTask); // Add that time to what the user is currently doing
                                    categories['sleep prev night']!.addTime(
                                        dt: durationSleepNightTrimmed); // Add that time to the prev night sleep since it overlapped
                                  }
                                }
                                Provider.of<Tasks>(context, listen: false)
                                    .deleteTask(_id);
                              }
                            });
                          },
                          child: SvgPicture.asset(
                            '$kIconsPath/delete.svg',
                            height: 23,
                            color: _baseColor,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) => ShowDesc(
                                taskName: _taskName,
                                taskDesc: _taskDesc,
                                taskCategory: _taskCategory,
                                catCol: _baseColor ?? kBaseColor,
                              ),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                height: 23,
                                width: 23,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: _baseColor ?? kBaseColor,
                                      width: 2.5),
                                ),
                              ),
                              Text(
                                'i',
                                style: kInfoTextStyle.copyWith(
                                    fontSize: 13, color: _baseColor),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width / 2.8,
              decoration: const BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            )
          ],
        ),
      ),
    );
  }
}
