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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 250,
        width: 250,
        decoration: BoxDecoration(
            color: kDarkBlue,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: catCol, width: 3)),
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
                    color: kGrayTranslucent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: SingleChildScrollView(
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
                    color: kGrayTranslucent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SingleChildScrollView(
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
