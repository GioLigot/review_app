import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:review_app/components/myTextfield.dart';
import 'package:review_app/models/tasks.dart';
import '../../database/app_database.dart';
import '../../models/task_type.dart';
import 'package:intl/intl.dart';


class TaskBottomSheet extends StatefulWidget {
  final String taskTitle;
  final String description;
  final TaskType taskType;
  final bool isComplete;
  final bool isEdit;
  final DateTime dueDate;

  const TaskBottomSheet({
    Key? key,
    required this.taskTitle,
    required this.description,
    required this.taskType,
    required this.isComplete,
    required this.isEdit,
    required this.dueDate
  }) : super(key: key);

  @override
  _TaskBottomSheetState createState() => _TaskBottomSheetState();
}

class _TaskBottomSheetState extends State<TaskBottomSheet> {
  late TaskType _selectedTaskType;
  late bool _isComplete;
  bool _isTodaySelected = true;
  bool _isPlannedSelected = false;
  bool _isUrgentSelected = false;
  //controllers for text fields
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  // Focus Nodes for TextFields
  final FocusNode titleNode = FocusNode();
  final FocusNode descriptionNode = FocusNode();
  DateTime selectedDateTime = DateTime.now();
  late String formattedDate;
  bool datePicked = false;
  // Inputs
  late String input_taskTitle;
  late String input_description;
  late TaskType input_taskType;
  late bool input_isComplete;
  late DateTime input_dueDate;

  String hintText = "...";

  @override
  void initState() {
    super.initState();
    _selectedTaskType = widget.taskType;
    _isComplete = widget.isComplete;

    if(widget.isEdit){
      setState(() {
        titleController.text = widget.taskTitle;
        descriptionController.text = widget.description;
        _isComplete = widget.isComplete;
        _selectedTaskType = widget.taskType;
        selectedDateTime = widget.dueDate;

      });

    }
  }


  Future<DateTime?> showDateTimeDialog(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        return DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );
      }
    }

    return null; // No date or time selected
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Task Title",
            style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Outfit',
            fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          MyTextField(
              focusNode: titleNode,
              controller: titleController,
              hintText: hintText,
              obscureText: false
          ),
          const SizedBox(height: 10),
          const Text("Description",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Outfit',
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 10),
          MyTextField(
              focusNode: descriptionNode,
              controller: descriptionController,
              hintText: hintText,
              obscureText: false
          ),
          // Task type selection
          Row(
            children: [
              Checkbox(
                value: _isTodaySelected,
                onChanged: (value) {
                  setState(() {
                    _isTodaySelected = value ?? false;
                    _isPlannedSelected = false;
                    _isUrgentSelected = false;
                    input_taskType = TaskType.today;
                  });
                },
              ),
              const Text('Today'),
              const SizedBox(width: 16),
              Checkbox(
                value: _isPlannedSelected,
                onChanged: (value) {
                  setState(() {
                    _isTodaySelected = false;
                    _isPlannedSelected = value ?? false;
                    input_taskType = TaskType.planned;
                    _isUrgentSelected = false;
                  });
                },
              ),
              const Text('Planned'),
              const SizedBox(width: 16),
              Checkbox(
                value: _isUrgentSelected,
                onChanged: (value) {
                  setState(() {
                    _isTodaySelected = false;
                    _isPlannedSelected = false;
                    input_taskType = TaskType.urgent;
                    _isUrgentSelected = value ?? false;
                  });
                },
              ),
              const Text('Urgent'),
            ],
          ),
          // Due date picker
          const SizedBox(height: 10),
          Card(
            elevation: 5,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: GestureDetector(
              onTap: () async {
                selectedDateTime = (await showDateTimeDialog(context))!;

                if (selectedDateTime != null) {
                  // Do something with the selected date and time
                  print("aaaaaaaaaaaaaa");
                  print('Selected date and time: $selectedDateTime');
                  formattedDate = DateFormat('MMMM d, yyyy, h:mm a').format(selectedDateTime!);
                  print('Selected date and time: $formattedDate');

                  setState(() { // Update state to trigger UI rebuild
                    datePicked = true;
                  });
                }
              },
              child: Container(
                color: Colors.grey.shade100,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                height: 50,
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 10),
                    Text(
                        datePicked ? formattedDate : DateFormat('MMMM d, yyyy, h:mm a').format(DateTime.now())),
                    // Use the state variable
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [

              const Text('Complete Task',
                style:
                TextStyle(
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 150,),
              Switch(
                value: _isComplete,
                onChanged: (value) {
                  setState(() {
                    _isComplete = value;
                  });
                },
              ),
            ],
          ),
          // Create button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async{

                  input_taskTitle = titleController.text.toString();
                  input_description = descriptionController.text.toString();
                  input_isComplete = _isComplete;
                  input_dueDate = datePicked ? DateTime.now() : selectedDateTime!;

                  print(input_taskTitle);
                  print(input_description);
                  print(input_isComplete);
                  print(input_dueDate);
                  print(input_taskType.name);

                  final newTask = Task(
                      title: input_taskTitle,
                      description: input_description,
                      dueDate: input_dueDate,
                      taskType: input_taskType,
                      isDone: input_isComplete);

                  await AppDatabase.instance.createTask(newTask);
                  Navigator.pop(context);

                },
                child: const Text('Create'),
              ),
              // Cancel button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
