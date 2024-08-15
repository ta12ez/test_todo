class TaskModel {
  final int id;
  final String todo;
  final dynamic completed;
  final int userId;

  TaskModel({
    required this.id,
    required this.todo,
    required this.completed,
    required this.userId,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      todo: json['todo'],
      completed: json['completed']==1||json['completed']==true?true:false,
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': todo,
      'completed': completed ==true?1:0,
      'userId': userId,
    };
  }
}

