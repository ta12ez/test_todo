import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/controller/state.dart';
import 'package:todo_app/models/login_model.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/shared/constans/constant.dart';
import 'package:todo_app/shared/constans/urls.dart';
import 'package:todo_app/shared/network/local/db_helper.dart';
import 'package:todo_app/shared/network/remote/dio_helper.dart';

class TodoCubit extends Cubit<TodoStates> {
  TodoCubit() : super(TodoInitialState());
  static TodoCubit get(context) => BlocProvider.of(context);
//Login function
  LoginModel? loginModel;
  void userLogin({required String email, required String password}) {
    emit(TodoLoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        'username': '${email}',
        'password': '${password}',
      },
    ).then((value) {
      print(value.data.toString());
      loginModel = LoginModel.fromJson(value.data);
      emit(TodoLoginSuccessState(loginModel));
    }).catchError((erorr) {
      String? err;
      if (erorr is DioException) {

        if (erorr.response != null) {

          print( erorr.response!.data);
          err= erorr.response!.data['message'];
        } else {
          print("Error: ${erorr.message}");
          err="connection erorr";
        }
      } else {
        print("Unexpected error: $erorr");
        err="Unexpected error";
      }
      emit(TodoLoginErorrState(err));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isSecret = true;
  void ChangePasswordVisibility() {
    isSecret = !isSecret;
    suffix =
        isSecret ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(TodoLoginChangePasswordVisibilityState());
  }

//getTask
  //'https://dummyjson.com/todos?limit=3&skip=10'

  // List of tasks
  DBHelper dbHelper = DBHelper();

  List<TaskModel> tasks = [];
  List<TaskModel> doneTasks = [];
  List<TaskModel> undoneTasks = [];

  int limit = 10;
  int skip = 0;
  int total = 0;
  bool hasMore = true;


  // Fetch tasks with pagination
  void getTasks() async {
    if (!hasMore || state is TodoGetDataLoadingState) return;

    emit(TodoGetDataLoadingState());

    // Check for internet connection
      // Fetch from API if connected
  print("!");
      DioHelper.getData(

        url: '${GITTASKS}',
        qury: {
          'limit': limit,
          'skip': skip,
        },
      ).
      then((value) async {
        total = value.data['total'];

        final List<dynamic> newTasksJson = value.data['todos'];
        final List<TaskModel> newTasks = newTasksJson.map((taskJson) => TaskModel.fromJson(taskJson)).toList();

        tasks.addAll(newTasks);
        skip += limit;

        // Save tasks in SQLite
        for (var task in newTasks) {
          await dbHelper.insertTask(task);
        }

        tasks.forEach((element) {
          print(element.id);
          if (element.completed==true) {
            doneTasks.add(element);

          } else {
            undoneTasks.add(element);

          }
        });

        if (tasks.length >= total) {
          hasMore = false;
        }

        emit(TodoGetDataSuccessState(tasks));
      }).
      catchError((error) async{
        String? err;
        dbHelper.fetchTasks().then((value)  {
        tasks=value ;
            tasks.forEach((element) {
          if (element.completed==true) {
            doneTasks.add(element);

          } else {
            undoneTasks.add(element);

          }});
        }).catchError((e){print(e);});


        if (error is DioException) {
          if (error.response != null) {
            print(error.response!.data);
            err = error.response!.data['message'];
          } else {
            print("Error: ${error.message}");
            err = "Connection error";
          }
        } else {
          print("Unexpected error: $error");
          err = "Unexpected error";
        }
        emit(TodoGetDataErrorState(err!));

      });
    }
  //delete
  void deleteTask({required id}) {
    emit(TodoDeleteTaskLoadingState());
    DioHelper.DeleteData(
      url: "${DELETETASK}/${id}",

    ).then((value) {
      if(value.data["isDeleted"]==true){

        emit(TodoDeleteTaskSuccessState());
      }
    }).catchError((erorr) {
      String? err;
      if (erorr is DioException) {

        if (erorr.response != null) {

          print( erorr.response!.data);
          err= erorr.response!.data['message'];
        } else {
          print("Error: ${erorr.message}");
          err="connection erorr";
        }
      } else {
        print("Unexpected error: $erorr");
        err="Unexpected error";
      }
      emit(TodoDeleteTaskErorrState());
    });
  }
//update
  void updateTask({required id ,complite}) {
    emit(TodoUpdateTaskLoadingState());
    var complete=complite!;
    DioHelper.putData(
      url: "${UPDATETASK}/${id}",
data: {
        "completed":complete
}
    ).then((value) {
        emit(TodoUpdateTaskSuccessState());

    }).catchError((erorr) {
      String? err;
      if (erorr is DioException) {

        if (erorr.response != null) {

          print( erorr.response!.data);
          err= erorr.response!.data['message'];
        } else {
          print("Error: ${erorr.message}");
          err="connection erorr";
        }
      } else {
        print("Unexpected error: $erorr");
        err="Unexpected error";
      }
      emit(TodoUpdateTaskErorrState());
    });
  }
  //add
  void addTask({required String taskName,Id}) {
   int? userid = id;
   if(Id!=null){
     userid=Id;
   }
    emit(TodoAddTaskLoadingState());
    DioHelper.postData(
        url: "${ADDTASK}",
        data: {
          "todo":"${taskName}",
          "userId":"${userid}",
          "completed":false
        }
    ).then((value) {

      emit(TodoAddTaskSuccessState());

    }).catchError((erorr) {
      String? err;
      if (erorr is DioException) {

        if (erorr.response != null) {

          print( erorr.response!.data);
          err= erorr.response!.data['message'];
        } else {
          print("Error: ${erorr.message}");
          err="connection erorr";
        }
      } else {
        print("Unexpected error: $erorr");
        err="Unexpected error";
      }
      emit(TodoAddTaskErorrState());
    });
  }




}
