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
  String _boundUpperLim = '0';
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
      String? boundUpperLim}) {
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
    _boundUpperLim = boundUpperLim ?? _boundUpperLim;
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
    if (diff.inHours > 0) {
      return '${diff.inHours}h ${diff.inMinutes % 60}min';
    } else {
      return '${diff.inMinutes}min ${diff.inSeconds % 60}s';
    }
  }

  Duration get getTimePassed {
    return _time.difference(_beginTime);
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

  List<String> get getDataToSave {
    return [
      _id,
      _cat,
      _time.toString(),
      _beginTime.toString(),
      _lowerLim.inSeconds.toString(),
      _upperLim.inSeconds.toString(),
      _baseColor.toString().substring(6, 16),
      _overTimeColor.toString().substring(6, 16),
      _hintText,
      _hintDesc,
      _run
    ];
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
    _time = getTimePassed >= _upperLim && _boundUpperLim == '1'
        ? _time
        : _time.add(dt);
    _boundTime();
    notifyListeners();
  }

  void startTimerBool() {
    _run = '1';
  }

  void subtractBeginTime({Duration dt = const Duration(seconds: 1)}) {
    // By default 1 sec is added
    _beginTime = _beginTime.add(dt);
    notifyListeners();
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
    _beginTime = _time;
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
  static Category parse(
      {required List<String> data,
      required Color baseColor,
      required Color overTimeColor}) {
    return Category(
        id: data[0],
        cat: data[1],
        baseTime: DateTime.parse(data[2]),
        beginTime: DateTime.parse(data[3]),
        lowerLim: Duration(seconds: int.parse(data[4])),
        upperLim: Duration(seconds: int.parse(data[5])),
        baseColor: baseColor,
        overTimeColor: overTimeColor,
        run: data[6]);
  }

  // ----------------------------- Private Methods -----------------------------
  void _boundTime() {
    if (didExceed()) {
      _time = _beginTime.add(_upperLim - Duration(seconds: 1));
    } else if (didExceed(dt: const Duration(seconds: 0), dirnUp: false)) {
      // TODO: Possible bug
      _time = _beginTime.add(const Duration(seconds: 0));
    }
  }
}
