/// Show the task name, task Description of a task along with the task's color
/// as the boundary
///
/// Ratio of task Name: Task Desc = 2:7

import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';

class ShowDesc extends StatelessWidget {
  const ShowDesc(
      {required this.taskName,
      required this.taskCategory,
      required this.taskDesc,
      required this.catCol});

  final String taskName;
  final String taskCategory;
  final String taskDesc;
  final Color catCol;

  // Constants
  final double side = 250;
  final double borderWidth = 3;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: side,
        width: side,
        decoration: BoxDecoration(
            color: kDarkBlue,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: catCol, width: borderWidth)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: kBGGrayTranslucent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SingleChildScrollView(
                      // To scroll the name in horizontal direction
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        taskName,
                        textAlign: TextAlign.center,
                        style: kInfoTextStyle.copyWith(color: kWhite),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 7,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: kBGGrayTranslucent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
                      // To scroll the description in vertical direction
                      child: Text(
                        taskDesc,
                        textAlign: TextAlign.center,
                        style: kInfoTextStyle.copyWith(color: kWhite),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
