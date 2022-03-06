import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tweak/utils/local_storage.dart';
import 'category.dart';
import 'package:tweak/utils/constants.dart';

class Categories extends ChangeNotifier {
  static const String fileName = 'categories.json';
  static const String timeFileName = 'time.json';
  late DateTime beginDateTime;
  String currentUserState = 'work';

  FileHandler fileHandler = FileHandler();
  final Map<String, Category> _categories = {
    'work': Category(
        id: 'work',
        lowerLim: const Duration(seconds: 0),
        upperLim: const Duration(hours: 24),
        hintText: 'Unknown Task', // 12:00hr
        boundUpperLim: '1'),
    'sleep prev night': Category(
      id: 'sleep prev night',
      cat: 'sleep previous night',
      lowerLim: const Duration(seconds: 12600), // 3:30 hr
      upperLim: const Duration(seconds: 25200), // 7 hr
      baseColor: kYellow,
      hintText: 'Sleep',
    ),
    'sleep current day': Category(
      // Default sleep
      id: 'sleep current day',
      cat: 'sleep current day',
      upperLim: const Duration(seconds: 3600), // 1 hr
      baseColor: kYellow,
      hintText: 'Sleep',
    ),
    'rest': Category(
      id: 'rest',
      upperLim: const Duration(seconds: 7200), // 2 hour
      baseColor: kGreen,
      hintText: 'Rest',
    ),
    'time waste': Category(
        id: 'time waste',
        upperLim: const Duration(seconds: 7200), // 2 hr
        baseColor: kOrange,
        hintText: 'Time Wasted'),
    'unregistered':
        Category(id: 'unregistered', baseColor: kRed, hintText: 'Unregistered'),
  };

  Map<String, Category> get getCategories {
    return Map.unmodifiable(_categories);
  }

  String get getCurrentUserState {
    return currentUserState;
  }

  DateTime get getBeginDateTime {
    return beginDateTime;
  }

  void addCategory(Category cat) {
    _categories[cat.getCat] = cat;
  }

  void toggleCategories(
      {required String cat1,
      required String cat2,
      void Function()? startTimerFunc,
      bool resetTime1 = false,
      bool resetTime2 = false}) {
    Category category1 = _categories[cat1]!;
    Category category2 = _categories[cat2]!;

    if (category1.isRunning) {
      category1.endTimer();
      category2.startTimerBool();
      category2.startTimer(func: startTimerFunc);
    } else {
      category2.endTimer();
      category1.startTimerBool();
      category1.startTimer(func: startTimerFunc);
    }

    if (resetTime1) {
      category1.resetTime();
    }
    if (resetTime2) {
      category2.resetTime();
    }
  }

  void resetAllTime() {
    _categories.forEach((key, value) {
      if (key != 'sleep prev night') {
        _categories[key]!.resetTime();
      }
    });
  }

  Duration get getWorkTime {
    return _categories['work']!.getTimePassed;
  }

  void saveBeginTimeData() {
    beginDateTime = DateTime.now();
    fileHandler.write(
        fileName: timeFileName, data: json.encode(beginDateTime.toString()));
  }

  Future<void> _readBeginTimeData() async {
    if (await fileHandler.fileExists(fileName: timeFileName)) {
      dynamic decodedData =
          json.decode(await fileHandler.readData(fileName: timeFileName));
      beginDateTime = DateTime.parse(decodedData);
    }
  }

  void saveCategories({bool saveBeginTime = false}) {
    Map<String, List<String>> data = {};
    _categories.forEach((key, value) {
      data[key] = value.getDataToSave;
    });
    fileHandler.write(fileName: fileName, data: json.encode(data));
  }

  void readCategories() async {
    if (await fileHandler.fileExists(fileName: fileName)) {
      dynamic dataDecoded =
          json.decode(await fileHandler.readData(fileName: fileName));
      dataDecoded.forEach((key, value) {
        _categories[key] = Category(
            id: value[0],
            cat: value[1],
            baseTime: DateTime.parse(value[2]),
            beginTime: DateTime.parse(value[3]),
            lowerLim: Duration(seconds: int.parse(value[4])),
            upperLim: Duration(seconds: int.parse(value[5])),
            baseColor: Color(int.parse(value[6])),
            overTimeColor: Color(int.parse(value[7])),
            hintText: value[8],
            hintDesc: value[9],
            run: value[10]);
      });
    }
    await _readBeginTimeData();
    String cat = 'work';
    if (!_categories['work']!.isRunning) {
      cat = 'sleep prev night';
    }
    _categories[cat]!.addTime(dt: DateTime.now().difference(beginDateTime));
  }
}
