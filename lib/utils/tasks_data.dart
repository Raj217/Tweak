import 'package:flutter/cupertino.dart';
import 'package:tweak/widgets/task_tile.dart';

class Tasks extends ChangeNotifier {
  List<TaskTile> _tasks = [TaskTile(), TaskTile(), TaskTile(), TaskTile()];

  List<TaskTile> get getTasks {
    return _tasks;
  }
}
