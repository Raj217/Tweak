import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';

class Category extends ChangeNotifier {
  late String _id;
  late String _cat;
  DateTime _time = DateTime.now();
  DateTime _beginTime = DateTime.now();
  Duration _lowerLim = const Duration(seconds: 0);
  Duration _upperLim = const Duration(seconds: 0);
  Color _baseColor = kLightBlue;
  Color _overTimeColor = kRed;
  Timer? _timer;
  String _hintText = 'Unknown Task';
  String _hintDesc = '';
  String _run = '0'; // 0: false, 1: true
  Duration _bias = const Duration(seconds: 0);
  // -------------------------------- Constants --------------------------------
  final DateFormat dfDateExtractor = DateFormat('EEE MMM d, yyyy');

  // ------------------------------ Initialisation -----------------------------
  Category(
      {String? id,
      String? cat,
      DateTime? baseTime,
      DateTime? beginTime,
      Duration? lowerLim,
      Duration? upperLim,
      Color? baseColor,
      Color? overTimeColor,
      String? hintText,
      String? hintDesc,
      String? run,
      Duration? bias}) {
    _id = id ?? '';
    _cat = cat ?? '';
    _time = baseTime ?? _time;
    _beginTime = beginTime ?? _beginTime;
    _lowerLim = lowerLim ?? _lowerLim;
    _upperLim = upperLim ?? _upperLim;
    _baseColor = baseColor ?? _baseColor;
    _overTimeColor = overTimeColor ?? _overTimeColor;
    _hintText = hintText ?? _hintText;
    _hintDesc = hintDesc ?? _hintDesc;
    _run = run ?? _run;
    _bias = bias ?? _bias;
  }

  // --------------------------- Operator Overloading ---------------------------
  Duration operator +(Category other) {
    Duration t1 = getTimePassed;
    Duration t2 = other.getTimePassed;
    return t1 + t2;
  }

  // ----------------------------- Public Methods -------------------------------

  // -------------- Return Data --------------

  String getDate({DateFormat? dateFormat}) {
    dateFormat = dateFormat ?? dfDateExtractor;
    return dateFormat.format(_time);
  }

  String getTimeFormatted({Duration? diff}) {
    diff = diff ?? getTimePassed;
    String diffStr = diff.toString();
    int hInd, minInd;
    hInd = diffStr.indexOf(':');
    minInd = diffStr.indexOf(':', hInd + 1);
    String out = '';

    int h = int.parse(diffStr.substring(0, hInd));
    int min = int.parse(diffStr.substring(hInd + 1, minInd));
    int sec = double.parse(diffStr.substring(minInd + 1)).toInt();
    if (diff.inSeconds < 0) {
      out += '-';
    }
    if (h > 0) {
      out += '${h}h ';
      if (min > 0) {
        out += '${min}min';
      }
    } else {
      if (min > 0) {
        out += '${min}min ';
      }
      out += '${sec}s';
    }

    return out;
  }

  Duration get getTimePassed {
    Duration time = _time.difference(_beginTime);
    if ((time + _bias).inSeconds >= 0) {
      return time;
    } else {
      _beginTime = _time.add(_bias);
      return const Duration(seconds: 0);
    }
  }

  String get getHintText {
    return _hintText;
  }

  String get getHintDesc {
    return _hintDesc;
  }

  String get getCat {
    return _cat;
  }

  bool get isRunning {
    return _run == '0' ? false : true;
  }

  Color get getCategoryColor {
    return didExceed(dt: _upperLim) ? _overTimeColor : _baseColor;
  }

  Map<String, String> get getDataToSave {
    return {
      'id': _id,
      'cat': _cat,
      'base time': _time.toString(),
      'begin time': _beginTime.toString(),
      'lower lim': _lowerLim.inSeconds.toString(),
      'upper lim': _upperLim.inSeconds.toString(),
      'base Color red': _baseColor.red.toString(),
      'base Color blue': _baseColor.blue.toString(),
      'base Color green': _baseColor.green.toString(),
      'base Color opacity': _baseColor.opacity.toString(),
      'over time Color red': _overTimeColor.red.toString(),
      'over time Color blue': _overTimeColor.blue.toString(),
      'over time Color green': _overTimeColor.green.toString(),
      'over time Color opacity': _overTimeColor.opacity.toString(),
      'hint text': _hintText,
      'hint desc': _hintDesc,
      'run': _run,
      'bias': _bias.inSeconds.toString()
    };
  }

  bool didExceed({Duration? dt, bool dirnUp = true}) {
    // Here dt is the time difference (duration) and
    // dirn Up refers to the upper bound if this is false
    // dt will be treated as the lower bound
    Duration diff = getTimePassed;
    if (dirnUp) {
      dt = dt ?? _upperLim;

      return (_upperLim.inSeconds == 0)
          ? false
          : (diff.inSeconds > dt.inSeconds ? true : false); // Upper Bound
    } else {
      dt = dt ?? _lowerLim;
      return diff.inSeconds < dt.inSeconds ? true : false; // Lower bound
    }
  }
  // -------------- Change Class Variables' value --------------

  void addTime({Duration dt = const Duration(seconds: 1)}) {
    // By default 1 sec is added
    _time = _time.add(dt);
    //_boundTime();
    notifyListeners();
  }

  void startTimerBool() {
    _run = '1';
  }

  void subtractTime({required Duration dt}) {
    _time = getTimePassed <= const Duration(seconds: 0)
        ? _beginTime
        : _time.subtract(dt);
    notifyListeners();
  }

  // -------------- Timer related methods --------------
  void startTimer(
      {Duration dt = const Duration(seconds: 1), void Function()? func}) {
    if (_run == '1') {
      _timer?.cancel();
      _timer = Timer.periodic(dt, (_) {
        addTime(dt: dt);
        if (func != null) {
          func();
        }
      });
    }
  }

  void endTimer() {
    _timer?.cancel();
    _run = '0';
  }

  void resetTime() {
    _beginTime = DateTime.now().add(_bias);
    _time = DateTime.now();
  }

  void setUpperLim(Duration duration) {
    _upperLim = duration;
    notifyListeners();
  }

  void setLowerLim(Duration duration) {
    _lowerLim = duration;
    notifyListeners();
  }

  // ----------------------------- Static Methods -----------------------------
  static Category parse({required Map<String, dynamic> data}) {
    return Category(
        id: data['id'],
        cat: data['cat'],
        baseTime: DateTime.parse(data['base time']),
        beginTime: DateTime.parse(data['begin time']),
        lowerLim: Duration(seconds: int.parse(data['lower lim'])),
        upperLim: Duration(seconds: int.parse(data['upper lim'])),
        baseColor: Color.fromRGBO(
            int.parse(data['base Color red']),
            int.parse(data['base Color green']),
            int.parse(data['base Color blue']),
            double.parse(data['base Color opacity'])),
        overTimeColor: Color.fromRGBO(
            int.parse(data['over time Color red']),
            int.parse(data['over time Color green']),
            int.parse(data['over time Color blue']),
            double.parse(data['over time Color opacity'])),
        hintText: data['hint text'],
        hintDesc: data['hint desc'],
        run: data['run'],
        bias: Duration(seconds: int.parse(data['bias'])));
  }
}
