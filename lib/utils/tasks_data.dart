import 'package:flutter/cupertino.dart';
import 'package:tweak/widgets/task_tile.dart';

class Tasks extends ChangeNotifier {
  List<TaskTile> _tasks = [];

  List<TaskTile> get getTasks {
    sortTasks();
    return _tasks;
  }

  void addTask(TaskTile task) {
    _tasks.add(task);
    notifyListeners();
  }

  int get nTasks {
    return _tasks.length;
  }

  void sortTasks() {
    _tasks.sort((a, b) => a.index.compareTo(b.index));
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    for (int i = index; i < _tasks.length; i++) {
      _tasks[i].setIndex(i);
    }
    notifyListeners();
  }
}
