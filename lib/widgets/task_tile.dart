import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 15),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('09:00 am - 10:00 am', style: kInfoTextStyle),
                      SizedBox(width: 70),
                      Text(
                        '01:00 hr',
                        style: kInfoTextStyle,
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Task 1',
                    style: kInfoTextStyle.copyWith(
                        fontWeight: FontWeight.w700, fontSize: 22),
                  )
                ],
              ),
              const SizedBox(width: 5),
              Column(
                children: [
                  SvgPicture.asset(
                    '$kIconsPath/delete.svg',
                    height: 20,
                    color: kLightBlue,
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: kLightBlue, width: 2),
                        ),
                      ),
                      Text(
                        'i',
                        style: kInfoTextStyle.copyWith(fontSize: 10),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            width: 150,
            decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          )
        ],
      ),
    );
  }
}
