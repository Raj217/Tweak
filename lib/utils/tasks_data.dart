import 'package:flutter/cupertino.dart';
import 'package:tweak/widgets/task_tile.dart';

class Tasks extends ChangeNotifier {
  List<TaskTile> _tasks = [];

  List<TaskTile> get getTasks {
    return _tasks;
  }

  void addTask(TaskTile task) {
    _tasks.add(task);
    print(_tasks);
    notifyListeners();
  }
}
