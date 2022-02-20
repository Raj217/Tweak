import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'local_storage.dart';
import 'dart:convert';

class Time extends ChangeNotifier {
  int _timeWork = 0;
  int _timeSleep = 0;
  int _timeRest = 0;
  String _workTimeUnit = '';
  String _sleepTimeUnit = '';
  String _restTimeUnit = '';
  String fileName = 'time.txt';
  FileHandler fileHandler = FileHandler();
  DateTime _prevDateTime = DateTime(0);
  DateTime _currentDateTime = DateTime(0);
  Timer? _timer;
  String _currentUserState = 'working';

  String get getTimeWork {
    List<String> temp = convSecsToString(secs: _timeWork);
    _workTimeUnit = temp[1];
    return temp[0];
  }

  String get getTimeSleep {
    List<String> temp = convSecsToString(secs: _timeSleep);
    _sleepTimeUnit = temp[1];
    return '${temp[0]} $_sleepTimeUnit';
  }

  String get getTimeRest {
    List<String> temp = convSecsToString(secs: _timeRest);
    _restTimeUnit = temp[1];
    return '${temp[0]} $_restTimeUnit';
  }

  String get getWorkTimeUnit {
    return _workTimeUnit;
  }

  String get getSleepTimeUnit {
    return _sleepTimeUnit;
  }

  String get getRestTimeUnit {
    return _restTimeUnit;
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
    String? unit;
    int hour = secs ~/ 3600;
    secs -= hour * 3600;
    int minutes = secs ~/ 60;
    secs -= minutes * 60;
    hour > 0 ? unit = 'hr' : unit = 'min';

    return hour > 0
        ? ["${_formatTime(hour)}:${_formatTime(minutes)}", unit]
        : ["${_formatTime(minutes)}:${_formatTime(secs)}", unit];
  }

  String _formatTime(int time) {
    return time.toString().padLeft(2, '0');
  }
}
