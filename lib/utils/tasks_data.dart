import 'package:flutter/cupertino.dart';
import 'package:tweak/utils/local_storage.dart';
import 'package:tweak/widgets/task_tile.dart';
import 'dart:convert';

class Tasks extends ChangeNotifier {
  List<TaskTile> _tasks = [];
  FileHandler fileHandler = FileHandler();
  static String fileName = 'tasks.json';

  List<TaskTile> get getTasks {
    sortTasks();
    return _tasks;
  }

  void addTask(TaskTile task) {
    _tasks.add(task);
    _saveTasks();
    notifyListeners();
  }

  int get nTasks {
    return _tasks.length;
  }

  void sortTasks() {
    _tasks.sort((a, b) => a.index.compareTo(b.index));
    _saveTasks();
  }

  void _reindex({int index = 0}) {
    for (int i = index; i < _tasks.length; i++) {
      _tasks[i].setIndex(i);
    }
    _saveTasks();
  }

  void deleteAllTasks() {
    _tasks = [];
    fileHandler.deleteFile(fileName);
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    _reindex(index: index);
    notifyListeners();
  }

  void editTask(int index, TaskTile task) {
    _tasks[index] = task;
  }

  void _saveTasks() {
    List<Map<String, String>> tasksData = [];
    for (TaskTile _task in _tasks) {
      int index = _task.index;
      DateTime startDateTime = _task.startDateTime;
      DateTime endDateTime = _task.endDateTime;
      Duration duration =
          _task.duration ?? endDateTime.difference(startDateTime);
      String taskName = _task.taskName ?? 'Unknown Task';
      String taskDesc = _task.taskDesc ?? 'No Description';
      String taskCategory = _task.taskCategory;
      Map<String, String> data = {
        'index': index.toString(),
        'startDateTime': startDateTime.toString(),
        'endDateTime': endDateTime.toString(),
        'taskName': taskName,
        'taskDesc': taskDesc,
        'durationSecs': duration.inSeconds.toString(),
        'taskCategory': taskCategory
      };
      tasksData.add(data);
    }
    fileHandler.write(fileName: fileName, data: json.encode(tasksData));
  }

  void readTasks() async {
    if (await fileHandler.fileExists(fileName: fileName)) {
      String data = await fileHandler.readData(fileName: fileName);

      dynamic decodedData = json.decode(data);

      for (int i = 0; i < decodedData.length; i++) {
        addTask(
          TaskTile(
            index: int.parse(decodedData[i]['index']),
            startDateTime: DateTime.parse(decodedData[i]['startDateTime']),
            endDateTime: DateTime.parse(decodedData[i]['endDateTime']),
            taskName: decodedData[i]['taskName'],
            taskDesc: decodedData[i]['taskDesc'],
            duration: Duration(
              seconds: int.parse(decodedData[i]['durationSecs']),
            ),
            taskCategory: decodedData[i]['taskCategory'],
          ),
        );
      }
    }
  }
}
