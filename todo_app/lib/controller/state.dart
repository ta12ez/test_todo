import 'package:todo_app/models/login_model.dart';
import 'package:todo_app/models/task_model.dart';

abstract class TodoStates{}
class TodoInitialState extends TodoStates{}
//Login States
class TodoLoginSuccessState extends TodoStates{
  final LoginModel? loginModel;
  TodoLoginSuccessState(this.loginModel);
}

class TodoLoginErorrState extends TodoStates{
  final erorr;

  TodoLoginErorrState(this.erorr);
}
class TodoLoginLoadingState extends TodoStates{}
class TodoLoginChangePasswordVisibilityState extends TodoStates{}
//get

class TodoGetDataLoadingState extends TodoStates {}

class TodoGetDataSuccessState extends TodoStates {
  final List<TaskModel> tasks;

  TodoGetDataSuccessState(this.tasks);
}

class TodoGetDataErrorState extends TodoStates {
  final String error;

  TodoGetDataErrorState(this.error);
}
class TodoDeleteTaskLoadingState extends TodoStates{}
class TodoDeleteTaskSuccessState extends TodoStates{}
class TodoDeleteTaskErorrState extends TodoStates{}

class TodoUpdateTaskLoadingState extends TodoStates{}
class TodoUpdateTaskSuccessState extends TodoStates{}
class TodoUpdateTaskErorrState extends TodoStates{}

class TodoAddTaskLoadingState extends TodoStates{}
class TodoAddTaskSuccessState extends TodoStates{}
class TodoAddTaskErorrState extends TodoStates{}