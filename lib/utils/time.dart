import 'dart:async';
import 'package:flutter/material.dart';
import 'local_storage.dart';
import 'dart:convert';
import 'constants.dart';

class Time extends ChangeNotifier {
  int _timeWork = 0;
  int _timeSleepPrevDay = 0;
  int _timeSleepCurrentDay = 0;
  int _timeRest = 0;
  DateTime? _beginDateTime;
  int _timeWorkMin = 4; // 12:00 hr
  int _prevDaySleepTimeUpperLim = 28800; // 7:30 hr
  int _currentDaySleepTimeUpperLim = 3600; // 1 hour
  int _restTimeUpperLim = 10800; // 3 hr
  String _workTimeUnitMajor = '';
  String _workTimeUnitMinor = '';
  String _sleepTimeUnitMajor = '';
  String _sleepTimeUnitMinor = '';
  String _restTimeUnitMajor = '';
  String _restTimeUnitMinor = '';
  String fileName = 'time.json';
  FileHandler fileHandler = FileHandler();
  DateTime _prevDateTime = DateTime(0);
  DateTime _currentDateTime = DateTime(0);
  Timer? _timer;
  Timer? _timerSleep;
  String _currentUserState = 'working';

  String get getTimeWorkMajor {
    List<String> temp = convSecsToString(secs: _timeWork);
    _workTimeUnitMajor = temp[2];
    _workTimeUnitMinor = _workTimeUnitMajor == 'h' ? 'min' : 's';
    return temp[0];
  }

  String get getTimeWorkMinor {
    List<String> temp = convSecsToString(secs: _timeWork);
    return temp[1];
  }

  String get getTimeSleepMajor {
    List<String> temp =
        convSecsToString(secs: _timeSleepCurrentDay + _timeSleepPrevDay);
    _sleepTimeUnitMajor = temp[2];
    _sleepTimeUnitMinor = _sleepTimeUnitMajor == 'h' ? 'min' : 's';
    return temp[0];
  }

  String get getTimeSleepMinor {
    List<String> temp =
        convSecsToString(secs: _timeSleepCurrentDay + _timeSleepPrevDay);
    return temp[1];
  }

  String get getTimeRestMajor {
    List<String> temp = convSecsToString(secs: _timeRest);
    _restTimeUnitMajor = temp[2];
    _restTimeUnitMinor = _restTimeUnitMajor == 'h' ? 'min' : 's';
    return temp[0];
  }

  String get getTimeRestMinor {
    List<String> temp = convSecsToString(secs: _timeRest);
    return temp[1];
  }

  DateTime get prevDateTime {
    return _prevDateTime;
  }

  String get getTimeWork {
    return '$getTimeWorkMajor$_workTimeUnitMajor $getTimeWorkMinor$_workTimeUnitMinor';
  }

  String get getTimeSleep {
    return '$getTimeSleepMajor$_sleepTimeUnitMajor $getTimeSleepMinor$_sleepTimeUnitMinor';
  }

  String get getTimeRest {
    return '$getTimeRestMajor$_restTimeUnitMajor $getTimeRestMinor$_restTimeUnitMinor';
  }

  String get getWorkTimeUnitMajor {
    return _workTimeUnitMajor;
  }

  String get getSleepTimeUnitMajor {
    return _sleepTimeUnitMajor;
  }

  String get getRestTimeUnitMajor {
    return _restTimeUnitMajor;
  }

  String get getWorkTimeUnitMinor {
    return _workTimeUnitMinor;
  }

  String get getSleepTimeUnitMinor {
    return _sleepTimeUnitMinor;
  }

  String get getRestTimeUnitMinor {
    return _restTimeUnitMinor;
  }

  String get getCurrentUserState {
    _currentUserState = _timeWork == 0 ? 'sleeping' : 'working';
    return _currentUserState;
  }

  double get getSecs {
    return _timeWork / 1.0;
  }

  bool get getIsRunning {
    return _timer != null ? true : false;
  }

  bool get getIsEndable {
    return _timeWork > _timeWorkMin;
  }

  Color get getSleepColor {
    return _currentDaySleepTimeUpperLim + _prevDaySleepTimeUpperLim >
            _timeSleepCurrentDay + _timeSleepPrevDay
        ? kYellow
        : kRed;
  }

  Color get getRestColor {
    return _restTimeUpperLim > _timeRest ? kGreen : kRed;
  }

  Color get getCurrentUserStateColor {
    Color tempColor = kLightBlue;
    switch (_currentUserState) {
      case 'sleeping':
        tempColor = getSleepColor;
        break;
      case 'resting':
        tempColor = getRestColor;
        break;
    }

    return tempColor;
  }

  DateTime? get getBeginDateTime {
    _beginDateTime = _currentDateTime.subtract(
        Duration(seconds: _timeWork + _timeSleepCurrentDay + _timeRest));
    return _beginDateTime;
  }

  set setPrevDaySleepTimeUpperLim(int time) {
    _prevDaySleepTimeUpperLim = time;
  }

  set setCurrentDaySleepTimeUpperLim(int time) {
    _currentDaySleepTimeUpperLim = time;
  }

  set setRestTimeUpperLim(int time) {
    _restTimeUpperLim = time;
  }

  int _boundTime(int time) {
    if (time < 0) {
      return 0;
    } else if (time > 86400) {
      return 86400;
    }
    return time;
  }

  void _boundTimeAll() {
    _timeWork = _boundTime(_timeWork);
    _timeSleepPrevDay = _boundTime(_timeSleepPrevDay);
    _timeSleepCurrentDay = _boundTime(_timeSleepCurrentDay);
    _timeRest = _boundTime(_timeRest);
  }

  void addSleepTime(
      {required Duration duration, bool subtractFromWork = true}) {
    if (duration.inSeconds > 0) {
      _timeSleepCurrentDay += duration.inSeconds;
      _timeWork -= subtractFromWork ? duration.inSeconds : 0;
      _boundTimeAll();
      notifyListeners();
    }
  }

  void subtractSleepTime({required Duration duration, bool addToWork = true}) {
    if (duration.inSeconds > 0) {
      _timeSleepCurrentDay -= duration.inSeconds;
      _timeWork -= addToWork ? duration.inSeconds : 0;
      _boundTimeAll();
      notifyListeners();
    }
  }

  void addRestTime({required Duration duration, bool subtractFromWork = true}) {
    if (duration.inSeconds > 0) {
      _timeRest += duration.inSeconds;
      _timeWork -= subtractFromWork ? duration.inSeconds : 0;
      _timeWork = _timeWork < 0 ? 0 : _timeWork;
      _boundTimeAll();
      notifyListeners();
    }
  }

  void subtractRestTime({required Duration duration, bool addToWork = true}) {
    if (duration.inSeconds > 0) {
      _timeRest -= duration.inSeconds;
      _timeWork -= addToWork ? duration.inSeconds : 0;
      _timeWork = _timeWork > 86400 ? 86400 : _timeWork;
      _boundTimeAll();
      notifyListeners();
    }
  }

  void startSleepTimer() {
    _timerSleep = Timer.periodic(const Duration(seconds: 1), (_) {
      _timeSleepPrevDay += 1;
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
    _timeWork = 0;
    _timeSleepPrevDay = 0;
    _timeSleepCurrentDay = 0;
    _timeRest = 0;
    _timer?.cancel();
    Map<String, String> data = {
      "time elapsed": _timeWork.toString(),
      'dateTime': _currentDateTime.toString(),
      'prevDaySleepTime': _timeSleepPrevDay.toString(),
      'currentDaySleepTime': '0',
      'restTime': '0',
      'dayStarted': 'false'
    };
    await fileHandler.write(fileName: fileName, data: json.encode(data));
    notifyListeners();
  }

  void saveTime({bool dayStarted = true}) async {
    _getCurrentDateTime();
    Map<String, String> data = {
      "time elapsed": _timeWork.toString(),
      'dateTime': _currentDateTime.toString(),
      'prevDaySleepTime': _timeSleepPrevDay.toString(),
      'currentDaySleepTime': _timeSleepCurrentDay.toString(),
      'restTime': _timeRest.toString(),
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
      _timeSleepPrevDay = int.parse(dataDecoded['prevDaySleepTime']);
      _timeSleepCurrentDay = int.parse(dataDecoded['currentDaySleepTime']);
      _timeRest = int.parse(dataDecoded['restTime']);

      bool dayStarted = dataDecoded['dayStarted'] == 'true' ? true : false;
      _getCurrentDateTime();

      int difference = _currentDateTime.difference(_prevDateTime).inSeconds;
      if (dayStarted) {
        _timeWork += difference;
      } else {
        _timeSleepPrevDay += difference;
      }

      _boundTimeAll();
      _timeWork != 0 ? startWorkTimer() : startSleepTimer();
    }
  }

  void _getCurrentDateTime() {
    _currentDateTime = DateTime.now();
  }

  List<String> convSecsToString({int secs = 0}) {
    String? majorUnit;
    int hour = secs ~/ 3600;
    secs -= hour * 3600;
    int minutes = secs ~/ 60;
    secs -= minutes * 60;
    hour > 0 ? majorUnit = 'h' : majorUnit = 'min';

    return hour > 0
        ? [hour.toString(), minutes.toString(), majorUnit]
        : [minutes.toString(), secs.toString(), majorUnit];
  }

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
