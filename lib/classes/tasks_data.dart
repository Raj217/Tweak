import 'package:flutter/cupertino.dart';
import 'package:tweak/utils/constants.dart';
import 'package:tweak/utils/local_storage.dart';
import 'package:tweak/widgets/task_tile.dart';
import 'dart:convert';
import 'package:tweak/overlays/showDesc.dart';

class Tasks extends ChangeNotifier {
  List<TaskTile> _tasks = [];
  FileHandler fileHandler = FileHandler();
  static String fileName = 'tasks.json';

  // ----------------------------- Methods -------------------------------

  // -------------- Return Data --------------

  List<TaskTile> get getTasks {
    sortTasks();
    return _tasks;
  }

  List<TaskTile> get getTasksInverted {
    /// Return tasks list in inverted order
    sortTasks();
    return _tasks.reversed.toList();
  }

  int get nTasks {
    return _tasks.length;
  }

  TaskTile get getLastTask {
    return _tasks[_tasks.length - 1];
  }

  void addTask({required TaskTile task, bool trimCurrentTaskStartTime = true}) {
    int len = _tasks.length;
    if (len == 0) {
      _tasks.add(task); // First task
    } else {
      TaskTile lastTask = _tasks[len - 1];
      Duration difference =
          task.getStartDateTime.difference(lastTask.getEndDateTime);
      if (difference.inSeconds == 0) {
        // Everything is tracked properly from time to time
        _tasks.add(task);
      } else if (difference.inSeconds > 0) {
        // Missing(unregistered) task in between the prev task and the current task to be added
        int index = len;
        DateTime startDateTime = lastTask.getEndDateTime;
        DateTime endDateTime = task.getStartDateTime;
        String taskName = 'Unregistered Task';
        String taskDesc = 'What you did in this period was not registered.';
        String taskCategory = 'unregistered';
        _tasks.add(TaskTile(
          id: index,
          startDateTime: startDateTime,
          endDateTime: endDateTime,
          taskName: taskName,
          taskDesc: taskDesc,
          taskCategory: taskCategory,
          baseColor: kRed,
        )); // Added the unregistered task
        _tasks.add(task.setId(task.getId +
            1)); // Added the tracked task entered by the user and added id 1 so it is pushed (1 for unregistered)
      } else {
        // Overlapping
        if (trimCurrentTaskStartTime == true) {
          // Current task will be trimmed
          _tasks.add(task.setStartDateTime(lastTask.getEndDateTime));
        } else {
          // The previous task will be trimmed
          editTask(
              index: len - 1,
              task: lastTask.setEndDateTime(task.getStartDateTime));
          _tasks.add(task);
        }
      }
    }

    _saveTasks();
    notifyListeners();
  }

  void sortTasks() {
    _tasks.sort((a, b) => a.getId.compareTo(b.getId));
    _saveTasks();
  }

  void _reindex({int index = 0}) {
    // Helpful when task added in between (future) or task deleted
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
    _saveTasks();
    notifyListeners();
  }

  void editTask(
      {required int index,
      required TaskTile task,
      bool trimCurrentTaskStartTime = true,
      bool taskOverlapping = false}) {
    if (!taskOverlapping) {
      _tasks[index] = task;
    } else {
      TaskTile last2ndTask = _tasks[nTasks - 2];
      if (trimCurrentTaskStartTime == true) {
        // Current task to be edited is trimmed
        _tasks[nTasks - 1].setStartDateTime(last2ndTask.getEndDateTime);
      } else {
        // Prev task to be edited is trimmed
        _tasks[nTasks - 2].setEndDateTime(task.getStartDateTime);
        _tasks[nTasks - 1] = task;
      }
    }

    _saveTasks();
    notifyListeners();
  }

  void _saveTasks() {
    List<Map<String, String>> tasksData = [];
    for (TaskTile _task in _tasks) {
      tasksData.add(_task.getDataToSave);
    }
    fileHandler.write(fileName: fileName, data: json.encode(tasksData));
  }

  void readTasks() async {
    if (await fileHandler.fileExists(fileName: fileName)) {
      String data = await fileHandler.readData(fileName: fileName);
      List<TaskTile> temp = [];
      dynamic decodedData = json.decode(data);
      for (int i = 0; i < decodedData.length; i++) {
        temp.add(TaskTile.parse(data: decodedData[i]));
      }
      _tasks = temp;
    }
  }
}
