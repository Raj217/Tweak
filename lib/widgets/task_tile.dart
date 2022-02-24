import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tweak/overlays/add_edit_tasks.dart';
import 'package:tweak/overlays/alert_dialog_box.dart';
import 'package:tweak/overlays/showDesc.dart';
import 'package:tweak/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tweak/utils/tasks_data.dart';
import 'package:tweak/utils/time.dart';

class TaskTile extends StatelessWidget {
  TaskTile({
    required this.index,
    required this.startDateTime,
    required this.endDateTime,
    required this.taskName,
    required this.taskDesc,
    required this.taskCategory,
    this.duration,
  });

  int index;
  DateTime startDateTime;
  DateTime endDateTime;
  String? taskName;
  String? taskDesc;
  Duration? duration;
  String taskCategory;

  Color _baseColor = kLightBlue;
  final DateFormat timeExtractor = DateFormat('h:mm a');

  void setIndex(int i) {
    index = i;
  }

  void _setBaseColor() {
    if (taskCategory == categories.work.toString().substring(11)) {
      _baseColor = kLightBlue;
    } else if (taskCategory == categories.sleep.toString().substring(11)) {
      _baseColor = kYellow;
    } else if (taskCategory == categories.rest.toString().substring(11)) {
      _baseColor = kGreen;
    } else if (taskCategory ==
        categories.unregistered.toString().substring(11)) {
      _baseColor = kRed;
    }
  }

  void _setDuration() {
    duration = duration ?? endDateTime.difference(startDateTime);
  }

  @override
  Widget build(BuildContext context) {
    _setDuration();
    _setBaseColor();
    return GestureDetector(
      onDoubleTap: () {
        showModalBottomSheet(
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) => AddEditTask(
            edit: true,
            index: index,
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
                              Text(
                                  '${timeExtractor.format(startDateTime)} - ${timeExtractor.format(endDateTime)}',
                                  style: kInfoTextStyle.copyWith(
                                      color: _baseColor)),
                              Text(
                                Time.durationExtractor(duration!),
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
                              taskName ?? 'Unknown Task',
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
                                                color: kLightBlue),
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
                                if (taskCategory == 'sleep') {
                                  Provider.of<Time>(context, listen: false)
                                      .subtractSleepTime(duration: duration!);
                                } else if (taskCategory == 'rest') {
                                  Provider.of<Time>(context, listen: false)
                                      .subtractRestTime(duration: duration!);
                                }
                                Provider.of<Tasks>(context, listen: false)
                                    .deleteTask(index);
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
                                taskName: taskName ??
                                    't', // TODO: Correct this and the next line as well
                                taskDesc: taskDesc ?? 'no',
                                taskCategory: taskCategory,
                                catCol: _baseColor,
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
                                  border:
                                      Border.all(color: _baseColor, width: 2.5),
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
