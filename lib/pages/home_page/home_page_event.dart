part of 'home_page_bloc.dart';

@immutable
sealed class HomePageEvent {}

class addTask extends HomePageEvent{
  final String taskName;
  final String taskDescription;
  final bool isDone;
  final TaskType taskType;
  final DateTime dueDate;

  addTask({
    required this.taskName,
    required this.taskDescription,
    required this.isDone,
    required this.taskType,
    required this.dueDate
});
}

class readAllTasks extends HomePageEvent{
  Future<List<Task?>>? taskList;
  readAllTasks({
    required this.taskList
  }) {
    // TODO: implement addTask
    throw UnimplementedError();
  }
}

