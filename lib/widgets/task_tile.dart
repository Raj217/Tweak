import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TaskTile extends StatelessWidget {
  TaskTile(
      {required this.startTime,
      required this.endTime,
      required this.taskName,
      required this.duration});

  final String startTime;
  final String endTime;
  final String taskName;
  final String duration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 25),
      child: GestureDetector(
        onDoubleTap: () {},
        onLongPress: () {},
        child: Column(
          children: [
            IntrinsicWidth(
              child: IntrinsicHeight(
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
                                Text('$startTime - $endTime',
                                    style: kInfoTextStyle),
                                Text(
                                  duration,
                                  style: kInfoTextStyle,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            taskName,
                            style: kInfoTextStyle.copyWith(
                                fontWeight: FontWeight.w700, fontSize: 22),
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
                            onTap: () {},
                            child: SvgPicture.asset(
                              '$kIconsPath/delete.svg',
                              height: 23,
                              color: kLightBlue,
                            ),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () {},
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: 23,
                                  width: 23,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: kLightBlue, width: 2.5),
                                  ),
                                ),
                                Text(
                                  'i',
                                  style: kInfoTextStyle.copyWith(fontSize: 13),
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
            ),
            const SizedBox(height: 10),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width / 2.8,
              decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            )
          ],
        ),
      ),
    );
  }
}
