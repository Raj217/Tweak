import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'local_storage.dart';
import 'dart:convert';

class Time extends ChangeNotifier {
  int _timeWork = 0;
  int _timeSleep = 0;
  int _timeRest = 0;
  String _workTimeUnitMajor = '';
  String _workTimeUnitMinor = '';
  String _sleepTimeUnitMajor = '';
  String _sleepTimeUnitMinor = '';
  String _restTimeUnitMajor = '';
  String _restTimeUnitMinor = '';
  String fileName = 'time.txt';
  FileHandler fileHandler = FileHandler();
  DateTime _prevDateTime = DateTime(0);
  DateTime _currentDateTime = DateTime(0);
  Timer? _timer;
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
    List<String> temp = convSecsToString(secs: _timeSleep);
    _sleepTimeUnitMajor = temp[2];
    _sleepTimeUnitMinor = _sleepTimeUnitMajor == 'h' ? 'min' : 's';
    return temp[0];
  }

  String get getTimeSleepMinor {
    List<String> temp = convSecsToString(secs: _timeSleep);
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
    return _currentUserState;
  }

  double get getSecs {
    return _timeWork / 1.0;
  }

  bool get isRunning {
    return _timer != null ? true : false;
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _timeWork += 1;
      saveTime();
      notifyListeners();
    });
  }

  void endTimer() {
    _timeWork = 0;
    _timer?.cancel();
    fileHandler.deleteFile(fileName);
    notifyListeners();
  }

  void saveTime() async {
    _getCurrentDateTime();
    Map<String, String> data = {
      "time elapsed": _timeWork.toString(),
      'dateTime': _currentDateTime.toString(),
    };
    await fileHandler.write(fileName: fileName, data: json.encode(data));
  }

  void readTime() async {
    if (await fileHandler.fileExists(fileName: fileName)) {
      String data = await fileHandler.readData(fileName: fileName);
      dynamic dataDecoded = json.decode(data);

      _timeWork = int.parse(dataDecoded['time elapsed']);
      _prevDateTime = DateTime.parse(dataDecoded['dateTime']);
      _getCurrentDateTime();

      int difference = _currentDateTime.difference(_prevDateTime).inSeconds;
      _timeWork += difference;

      if (_timeWork != 0) startTimer();
    }
  }

  void _getCurrentDateTime() {
    _currentDateTime = DateTime.now();
  }

  int convStringToSecs({String t = '00:00:00'}) {
    // Time format- hh:mm:ss
    List<String> timeParts = t.split(':');
    int hour = int.parse(timeParts[0] * 3600);
    int minutes = int.parse(timeParts[1] * 60);
    int seconds = int.parse(timeParts[2]);

    return hour + minutes + seconds;
  }

  List<String> convSecsToString({int secs = 0}) {
    String? majorUnit;
    int hour = secs ~/ 3600;
    secs -= hour * 3600;
    int minutes = secs ~/ 60;
    secs -= minutes * 60;
    hour > 0 ? majorUnit = 'h' : majorUnit = 'min';

    return hour > 0
        ? [
            _formatTime(hour).toString(),
            _formatTime(minutes).toString(),
            majorUnit
          ]
        : [
            _formatTime(minutes).toString(),
            _formatTime(secs).toString(),
            majorUnit
          ];
  }

  String _formatTime(int time) {
    return time.toString().padLeft(2, '0');
  }

  static DateTime timeOfDayToDateTime(
      {required TimeOfDay tod, DateTime? date}) {
    date = date ?? DateTime.now();
    DateTime dateTime =
        DateTime(date.year, date.month, date.day, tod.hour, tod.minute);
    return dateTime;
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

  static String differenceTimeOfDay(
      {required TimeOfDay startTime, required TimeOfDay endTime}) {
    return Time.durationExtractor(Time.timeOfDayToDateTime(tod: endTime)
        .difference(Time.timeOfDayToDateTime(tod: startTime)));
  }
}
