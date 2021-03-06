import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tweak/utils/local_storage.dart';
import 'category.dart';
import 'package:tweak/utils/constants.dart';

class Categories extends ChangeNotifier {
  static const String fileName = 'categories.json';
  static const String timeFileName = 'time.json';
  late DateTime beginDateTime;
  String _currentUserState = 'work';

  FileHandler fileHandler = FileHandler();
  final Map<String, Category> _categories = {
    'work': Category(
      id: 'work',
      lowerLim: const Duration(seconds: 0),
      hintText: 'Unknown Task', // 12:00hr
    ),
    'sleep prev night': Category(
        id: 'sleep prev night',
        cat: 'sleep previous night',
        lowerLim: const Duration(seconds: 12600), // 3:30 hr
        upperLim: const Duration(seconds: 25200), // 7 hr
        baseColor: kYellow,
        hintText: 'Sleep',
        bias: const Duration(minutes: 5)),
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
    return _currentUserState;
  }

  Color get getCurrentUserStateColor {
    Color out = kBaseColor;
    _categories.forEach((key, value) {
      if (key == _currentUserState) {
        out = value.getCategoryColor;
      }
    });
    return out;
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
    Map<String, Map<String, dynamic>> data = {};
    _categories.forEach((key, value) {
      data[key] = value.getDataToSave;
    });
    fileHandler.write(fileName: fileName, data: json.encode(data));
  }

  Future<void> readCategories() async {
    await _readBeginTimeData();
    if (await fileHandler.fileExists(fileName: fileName)) {
      late DateTime workTime;
      late DateTime sleepPrevNightTime;
      late DateTime dt;
      dynamic dataDecoded =
          json.decode(await fileHandler.readData(fileName: fileName));
      dataDecoded.forEach((key, value) {
        _categories[key] = Category.parse(data: value);
        if (key == 'work') {
          workTime = DateTime.parse(value['base time']);
        } else if (key == 'sleep prev night') {
          sleepPrevNightTime = DateTime.parse(value['base time']);
        }
      });
      String cat = 'work';
      dt = workTime;
      if (!_categories['work']!.isRunning) {
        cat = 'sleep prev night';
        dt = sleepPrevNightTime;
      }

      // NOTE: The bug of extra time is due to the fact that suppose our app is running
      // then we cancel it and start it again so maybe since the begin time of that
      // category was not changed on opening it again it adds extra time
      _categories[cat]!.addTime(dt: DateTime.now().difference(dt));
    }
  }
}
