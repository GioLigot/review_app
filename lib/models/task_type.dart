enum TaskType{today, planned, urgent}

extension TaskTypeExtension on TaskType{
  String get name{
    switch(this){
      case TaskType.planned:
        return "Planned";
      case TaskType.today:
        return "Today";
      case TaskType.urgent:
        return "Urgent";
      default:
        return "";
    }
  }

  static TaskType fromString(String value){
    switch (value){
      case 'Planned':
        return TaskType.planned;
      case 'Today':
        return TaskType.today;
      case 'Urgent':
        return TaskType.urgent;
      default:
        throw ArgumentError('Invalid TaskType String: $value');
    }
  }
}

