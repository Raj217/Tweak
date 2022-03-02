import 'dart:async';
import 'package:flutter/material.dart';
import '../utils/local_storage.dart';
import 'dart:convert';
import '../utils/constants.dart';

class Time extends ChangeNotifier {
  DateTime? _beginDateTime;
  String fileName = 'time.json';
  FileHandler fileHandler = FileHandler();
  DateTime _prevDateTime = DateTime(0);
  DateTime _currentDateTime = DateTime(0);
  String _currentUserState = 'work';

  DateTime get prevDateTime {
    return _prevDateTime;
  }

  /* bool get getIsEndable {
    return _timeWork > _timeWorkMin;
  }

  bool get getIsContinuable {
    return _timeSleepPrevDay.didExceed(dirnUp: false);
  }
  */
  String get getCurrentUserState {
    return _currentUserState; // TODO: make it dynamic
  }

  /*  DateTime? get getBeginDateTime {
    _beginDateTime = _currentDateTime.subtract(Duration(
        seconds: _timeWork +
            _timeSleepCurrentDay.getTimePassed.inSeconds +
            _timeRest.getTimePassed.inSeconds));
    return _beginDateTime;
  }

  void addSleepTime(
      {required Duration duration, bool subtractFromWork = true}) {
    if (duration.inSeconds > 0) {
      _timeSleepCurrentDay.addTime(dt: duration);
      _timeWork -= subtractFromWork ? duration.inSeconds : 0;
      _boundTimeAll();
      notifyListeners();
    }
  }

  void subtractSleepTime(
      {required Duration duration,
      bool addToWork = true,
      bool subtractPrevDay = false}) {
    if (duration.inSeconds > 0) {
      if (subtractPrevDay) {
        _timeSleepPrevDay.subtractTime(dt: duration);
        _timeWork += addToWork ? duration.inSeconds : 0;
      } else {
        _timeSleepCurrentDay.subtractTime(dt: duration);
        _timeWork -= addToWork ? duration.inSeconds : 0;
      }
      _boundTimeAll();
      notifyListeners();
    }
  }

  void addRestTime({required Duration duration, bool subtractFromWork = true}) {
    if (duration.inSeconds > 0) {
      _timeRest.addTime(dt: duration);
      _timeWork -= subtractFromWork ? duration.inSeconds : 0;
      _timeWork = _timeWork < 0 ? 0 : _timeWork;
      _boundTimeAll();
      notifyListeners();
    }
  }

  void subtractRestTime({required Duration duration, bool addToWork = true}) {
    if (duration.inSeconds > 0) {
      _timeRest.subtractTime(dt: duration);
      _timeWork += addToWork
          ? (duration.inSeconds > 0 ? duration.inSeconds : -duration.inSeconds)
          : 0;
      _timeWork = _timeWork > 86400 ? 86400 : _timeWork;
      _boundTimeAll();
      notifyListeners();
    }
  }

  void addWasteTime(
      {required Duration duration, bool subtractFromWork = true}) {
    if (duration.inSeconds > 0) {
      _timeWaste.addTime(dt: duration);
      _timeWork -= subtractFromWork ? duration.inSeconds : 0;
      _boundTimeAll();
      notifyListeners();
    }
  }

  void subtractWasteTime({required Duration duration, bool addToWork = true}) {
    if (duration.inSeconds > 0) {
      _timeWaste.subtractTime(dt: duration);
      _timeWork += addToWork
          ? (duration.inSeconds > 0 ? duration.inSeconds : -duration.inSeconds)
          : 0;
      _boundTimeAll();
      notifyListeners();
    }
  }

  void startSleepTimer() {
    _timer?.cancel;
    _timerSleep = Timer.periodic(const Duration(seconds: 1), (_) {
      _timeSleepPrevDay.addTime();
      saveTime(dayStarted: false);
      notifyListeners();
    });
  }

  void startWorkTimer() {
    // TODO: Might be a bug like prev time for _timer?.cancel()
    _timerSleep?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _timeWork += _timeWork < 86400 ? 1 : 0;
      saveTime();
      notifyListeners();
    });
  }

  void endTimer() async {
    startSleepTimer();
    /*
    _timeWork = 0;
    _timeSleepPrevDay = Category(
        lowerLim: const Duration(seconds: 12600), // 3:30 hr
        upperLim: const Duration(seconds: 25200), // 7 hr
        baseColor: kYellow);
    _timeSleepCurrentDay = Category(
        upperLim: const Duration(seconds: 3600), // 1 hr
        baseColor: kYellow);
    _timeRest =
        Category(upperLim: const Duration(seconds: 7200), baseColor: kGreen);
    _timeWaste =
        Category(upperLim: const Duration(seconds: 7200), baseColor: kGreen); */
    _timer?.cancel();
    Map<String, String> data = {
      "time elapsed": _timeWork.toString(),
      'dateTime': _currentDateTime.toString(),
      'prevDaySleepTime': _timeSleepPrevDay.toString(),
      'currentDaySleepTime': '0',
      'restTime': '0',
      'timeWaste': '0',
      'dayStarted': 'false'
    };
    await fileHandler.write(fileName: fileName, data: json.encode(data));
    notifyListeners();
  }

  void saveTime({bool dayStarted = true}) async {
    _getCurrentDateTime();
    Map<String, dynamic> data = {
      "time elapsed": _timeWork.toString(),
      'dateTime': _currentDateTime.toString(),
      'prevDaySleepTime': _timeSleepPrevDay.getDataToSave,
      'currentDaySleepTime': _timeSleepCurrentDay.getDataToSave,
      'restTime': _timeRest.getDataToSave,
      'timeWaste': _timeWaste.getDataToSave,
      'dayStarted': dayStarted.toString()
    };
    await fileHandler.write(fileName: fileName, data: json.encode(data));
  }

  void readTime() async {
    if (await fileHandler.fileExists(fileName: fileName)) {
      String data = await fileHandler.readData(fileName: fileName);
      dynamic dataDecoded = json.decode(data);

      _timeWork = int.parse(dataDecoded['time elapsed']);
      _prevDateTime = DateTime.parse(dataDecoded['dateTime']);
      _timeSleepPrevDay = Category.parse(
          data: dataDecoded['prevDaySleepTime'],
          baseColor: kYellow,
          overTimeColor: kRed);
      _timeSleepCurrentDay = Category.parse(
          data: dataDecoded['currentDaySleepTime'],
          baseColor: kYellow,
          overTimeColor: kRed);
      _timeWaste = Category.parse(
          data: dataDecoded['timeWaste'],
          baseColor: kGreen,
          overTimeColor: kRed);
      _timeRest = Category.parse(
          data: dataDecoded['timeWaste'],
          baseColor: kGreen,
          overTimeColor: kRed);

      bool dayStarted = dataDecoded['dayStarted'] == 'true' ? true : false;

      Duration difference = DateTime.now().difference(_prevDateTime);
      if (dayStarted) {
        _timeWork += difference.inSeconds;
      } else {
        _timeSleepPrevDay.addTime(dt: difference);
      }

      _boundTimeAll();
      _timeWork != 0 ? startWorkTimer() : startSleepTimer();
    }
  }

  void _getCurrentDateTime() {
    _currentDateTime = DateTime.now();
  }
 */
  static String durationExtractor(Duration duration) {
    int hour = duration.inHours;
    int minutes = duration.inMinutes - hour * 60;
    String output;

    if (hour == 0) {
      output = '${minutes}min';
    } else if (minutes == 0) {
      output = '${hour}h';
    } else {
      output = '${hour}h ${minutes}min';
    }

    return output;
  }
}
