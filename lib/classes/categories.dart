import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tweak/utils/local_storage.dart';
import 'category.dart';
import 'package:tweak/utils/constants.dart';

class Categories extends ChangeNotifier {
  static const String fileName = 'categories.json';
  FileHandler fileHandler = FileHandler();
  final Map<String, Category> _categories = {
    'work': Category(
      id: 'work', lowerLim: const Duration(seconds: 430),
      hintText: 'Unknown Task', // 12:00hr
    ),
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
        baseColor: kGreen,
        hintText: 'Time Wasted'),
    'unregistered':
        Category(id: 'unregistered', baseColor: kRed, hintText: 'Unregistered'),
  };

  Map<String, Category> get getCategories {
    return Map.unmodifiable(_categories);
  }

  void addCategory(Category cat) {
    _categories[cat.getCat] = cat;
  }

  void saveCategories() {
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
            hintDesc: value[9]);
        if (value[0] == 'work' &&
            _categories[key]!.getTimePassed.inSeconds > 0) {
          _categories[key]!.startTimer();
        }
      });
    }
  }
}
