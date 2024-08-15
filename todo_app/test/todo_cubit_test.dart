import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/controller/cubit.dart';
import 'package:todo_app/controller/state.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/network/remote/dio_helper.dart';

void main() {
  late TodoCubit todoCubit;

  setUp(() {
    DioHelper.init();
    setupDioForTests();
    todoCubit = TodoCubit();
  });

  test('تسجيل الدخول بنجاح', () async {
    todoCubit.userLogin(email: 'emilys', password: 'emilyspass');
    await Future.delayed(
        Duration(seconds: 10));

    expect(todoCubit.state, isA<TodoLoginSuccessState>());
  });

  test('إضافة مهمة بنجاح', () async {

    todoCubit.addTask( taskName: 'New Task');
    await Future.delayed(
        Duration(seconds: 10));
    expect(todoCubit.state, isA<TodoAddTaskSuccessState>());

  });

  test('تحديث مهمة بنجاح', () async {
    todoCubit.updateTask(id: '2', complite: true);
    await Future.delayed(
        Duration(seconds: 10));
    expect(todoCubit.state, isA<TodoUpdateTaskSuccessState>());
  });

  test('حذف مهمة بنجاح', () async {
    todoCubit.deleteTask(id: '2');
    await Future.delayed(
        Duration(seconds: 10));

    expect(todoCubit.state, isA<TodoDeleteTaskSuccessState>());
  });
}
