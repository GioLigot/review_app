import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:review_app/database/app_database.dart';
import 'package:review_app/models/task_type.dart';

import '../../models/tasks.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageInitial()) {
    on<HomePageEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<addTask>((event, HomePageState){
      emit(HomePageLoading());


      final newTask = Task(
          title: event.taskName,
          description: event.taskDescription,
          dueDate: event.dueDate,
          taskType: event.taskType,
          isDone: event.isDone);

      AppDatabase.instance.createTask(newTask);

    });

    on<readAllTasks>((event, HomePageState){
      emit(HomePageLoading());

      event.taskList =  AppDatabase.instance.readAllTasks();
      
      if(event.taskList == null){
        
        emit();
        
      }
      
      
      
    });


  }
}
