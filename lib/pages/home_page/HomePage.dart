import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:review_app/database/app_database.dart';

import '../../models/task_type.dart';
import 'add_task_bottom_sheet.dart';
import '../../models/tasks.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  Future<List<Task?>>? _tasksFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tasksFuture = AppDatabase.instance.readAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task List",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Outfit',
              fontSize: 25,
          ),),
        backgroundColor: Colors.greenAccent,
      ),
      body: 
      FutureBuilder<List<Task?>>(
          future: _tasksFuture,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }else if(snapshot.hasError){
              return const Center(child: Text("Error loading tasks"),);
            }else if(snapshot.hasData){
              final tasks = snapshot.data ?? [];

              if(tasks.isEmpty){
                return const Center(child: Text("No Tasks Found!"),);
              }
              return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder:(context, index){
                    final task = tasks[index];

                    return ListTile(
                      title: Text(task?.title ?? '',
                        style: const TextStyle(
                            fontFamily: 'Outfit',
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      subtitle: Text(task?.description ?? '',
                          style: const TextStyle(
                          fontFamily: 'Zilla',
                          fontWeight: FontWeight.bold
                      )),
                      trailing: task!.isDone ?
                      const Icon(Icons.check_circle, color: Colors.green,)
                          :
                      const Icon(Icons.circle_outlined, color: Colors.grey,),
                      onTap: (){
                        print(task.title ?? '');
                        print(task.description ?? '');

                        showModalBottomSheet(
                          context: context,
                          builder: (context) =>  TaskBottomSheet(
                            taskTitle: task.title ,
                            description: task.description! ,
                            taskType: task.taskType,
                            isComplete: false,
                            isEdit: true,
                            dueDate: task.dueDate,
                          ),
                        );
                      },
                    );

                  }
                  );
            }else{
              //if not tasks are found
              return const Center(child: Text('No tasks found.'));

            }
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            showModalBottomSheet(
              context: context,
              builder: (context) => TaskBottomSheet(
                taskTitle: '',
                description: '',
                taskType: TaskType.today,
                isComplete: false,
                isEdit: false,
                dueDate: DateTime.now(),
              ),
            );
          },
          backgroundColor: Colors.greenAccent,
          child: const Icon(Icons.add),),
    );
  }
}
