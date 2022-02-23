import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';

class ShowDesc extends StatelessWidget {
  const ShowDesc({required this.taskName, required this.taskDesc});

  final String? taskName;
  final String? taskDesc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 250,
        width: 250,
        decoration: const BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: kGrayTranslucent,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          taskName ?? 'Unknown Task',
                          textAlign: TextAlign.center,
                          style: kInfoTextStyle.copyWith(color: kDarkBlue),
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
                      color: kGrayTranslucent,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: SingleChildScrollView(
                        child: Text(
                          taskDesc ?? 'No Description',
                          textAlign: TextAlign.center,
                          style: kInfoTextStyle.copyWith(color: kDarkBlue),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
