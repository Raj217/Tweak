import 'package:flutter/cupertino.dart';
import 'package:tweak/utils/constants.dart';
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

  List<TaskTile> get getTasksInverted {
    sortTasks();
    return _tasks.reversed.toList();
  }

  void addTask({required TaskTile task, bool trimCurrentTaskStartTime = true}) {
    int len = _tasks.length;
    if (len == 0) {
      _tasks.add(task);
    } else {
      TaskTile lastTask = _tasks[len - 1];
      Duration difference = task.startDateTime.difference(lastTask.endDateTime);
      if (difference.inSeconds == 0) {
        _tasks.add(task);
      } else if (difference.inSeconds > 0) {
        int index = len;
        DateTime startDateTime = lastTask.endDateTime;
        DateTime endDateTime = task.startDateTime;
        String taskName = 'Unregistered Task';
        String taskDesc = 'What you did in this period was not registered.';
        String taskCategory = 'unregistered';
        _tasks.add(TaskTile(
          index: index,
          startDateTime: startDateTime,
          endDateTime: endDateTime,
          taskName: taskName,
          taskDesc: taskDesc,
          taskCategory: taskCategory,
          baseColor: kRed,
        ));
        _tasks.add((TaskTile(
          index: task.index + 1,
          startDateTime: task.startDateTime,
          endDateTime: task.endDateTime,
          taskName: task.taskName,
          taskDesc: task.taskDesc,
          taskCategory: task.taskCategory,
          baseColor: task.baseColor,
        )));
      } else {
        if (trimCurrentTaskStartTime == true) {
          _tasks.add((TaskTile(
            index: task.index,
            startDateTime: lastTask.endDateTime,
            endDateTime: task.endDateTime,
            taskName: task.taskName,
            taskDesc: task.taskDesc,
            taskCategory: task.taskCategory,
            baseColor: task.baseColor,
          )));
        } else {
          editTask(
              index: len - 1,
              task: TaskTile(
                index: lastTask.index,
                startDateTime: lastTask.startDateTime,
                endDateTime: task.startDateTime,
                taskName: lastTask.taskName,
                taskDesc: lastTask.taskDesc,
                taskCategory: lastTask.taskCategory,
                baseColor: lastTask.baseColor,
              ));
          _tasks.add(task);
        }
      }
    }

    _saveTasks();
    notifyListeners();
  }

  int get nTasks {
    return _tasks.length;
  }

  TaskTile get getLastTask {
    return _tasks[_tasks.length - 1];
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
      TaskTile last2Task = _tasks[nTasks - 2];
      if (trimCurrentTaskStartTime == true) {
        _tasks[nTasks - 1] = TaskTile(
          index: task.index,
          startDateTime: last2Task.endDateTime,
          endDateTime: task.endDateTime,
          taskName: task.taskName,
          taskDesc: task.taskDesc,
          taskCategory: task.taskCategory,
          baseColor: task.baseColor,
        );
      } else {
        _tasks[nTasks - 2] = TaskTile(
          index: last2Task.index,
          startDateTime: last2Task.startDateTime,
          endDateTime: task.startDateTime,
          taskName: last2Task.taskName,
          taskDesc: last2Task.taskDesc,
          taskCategory: last2Task.taskCategory,
          baseColor: last2Task.baseColor,
        );
        _tasks[nTasks - 1] = task;
      }
    }

    _saveTasks();
    notifyListeners();
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
        'taskCategory': taskCategory,
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
          task: TaskTile(
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
