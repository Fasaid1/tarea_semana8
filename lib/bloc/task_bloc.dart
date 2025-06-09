import 'dart:async';
import '../models/task.dart';

class TaskBloc {
  final List<Task> _taskList = [];

  final _taskController = StreamController<List<Task>>.broadcast();

  Stream<List<Task>> get taskStream => _taskController.stream;

  void addTask(String title, String marca) {
    _taskList.add(Task(title: title, marca: marca));
    _taskController.sink.add(List.from(_taskList));
  }

  void toggleTask(Task task) {
    task.isCompleted = !task.isCompleted;
    _taskController.sink.add(List.from(_taskList));
  }

  void removeTask(Task task) {
    _taskList.remove(task);
    _taskController.sink.add(List.from(_taskList));
  }

  void updateTask(Task oldTask, String newTitle, String newMarca) {
    final index = _taskList.indexOf(oldTask);
    if (index != -1) {
      _taskList[index] = Task(
        title: newTitle,
        marca: newMarca,
        isCompleted: oldTask.isCompleted,
      );
      _taskController.sink.add(List.from(_taskList));
    }
  }

  void dispose() {
    _taskController.close();
  }
}