import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/controller/cubit.dart';
import 'package:todo_app/controller/state.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/style/color.dart';
import 'package:todo_app/veiw/add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _donesScrollController = ScrollController();
  final ScrollController _undoneScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: BlocConsumer<TodoCubit, TodoStates>(listener: (context, state) {

        if (state is TodoGetDataErrorState) {
          ShowTaost(msg: 'YouAreOffline', state: ToastState.WARNING);
        }
        if (state is TodoDeleteTaskErorrState) {
          ShowTaost(msg: 'YouCanNotDeleteIt', state: ToastState.ERORR);
        }
        if (state is TodoUpdateTaskErorrState) {
          ShowTaost(msg: 'YouCanNotUpdateIt', state: ToastState.ERORR);
        }
      }, builder: (context, state) {
        var cubit = TodoCubit.get(context);
        if (cubit.tasks.isEmpty) {
          cubit.getTasks();
        }
        if(state is TodoDeleteTaskSuccessState ||state is TodoUpdateTaskSuccessState ){
          cubit.tasks=[];
          cubit.undoneTasks=[];
          cubit.doneTasks=[];
          cubit.skip=0;
          cubit.getTasks();

        }
        _scrollController.addListener(() {
          if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
            cubit.getTasks();
          }
        });
        _undoneScrollController.addListener(() {
          if (_undoneScrollController.position.pixels ==
              _undoneScrollController.position.maxScrollExtent) {
            cubit.getTasks();
          }
        });
        _donesScrollController.addListener(() {

          if (_donesScrollController.position.pixels ==
              _donesScrollController.position.maxScrollExtent) {
            cubit.getTasks();
          }
        });
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Tasks",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: defaultColor),
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Row(
                    children: [
                      Text(
                        "All Task",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: defaultColor),
                      )
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Text(
                        "Undone Task",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: defaultColor),
                      )
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      Text(
                        "Done Task",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(color: defaultColor),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              NaveTo(context: context, bage: AddTaskScreen());
            },
            backgroundColor: defaultColor,
            child: const Icon(Icons.add),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Expanded(
                  child:TabBarView(
                    children: [
                      state is TodoGetDataLoadingState && cubit.tasks.isEmpty?const Center(child: CircularProgressIndicator(color: defaultColor,),):
                      cubit.tasks.isEmpty?
                          Center(child: Row(
                            children: [
                              const Text("there is no task"),
                              textbut(context: context,text: "Refrish", function: (){
                                cubit.getTasks();
                              },)
                            ],
                          ))
                          :
                      buildTaskList(
                        cubit: cubit,
                        tasks: cubit.tasks,
                        controller: _scrollController,
                        deleteFunction: cubit.deleteTask,
                        updateFunction: cubit.updateTask,
                        hasMore: cubit.hasMore,
                        state: state,
                      ),
                      state is TodoGetDataLoadingState && cubit.undoneTasks.isEmpty?const Center(child: CircularProgressIndicator(color: defaultColor,),):
                      cubit.undoneTasks.isEmpty?
                      const Center(child: Row(
                        children: [
                          Text("there is no task"),

                        ],
                      ))
                          :
                      buildTaskList(
                        cubit: cubit,
                        tasks: cubit.undoneTasks,
                        controller: _undoneScrollController,
                        deleteFunction: cubit.deleteTask,
                        updateFunction: cubit.updateTask,
                        hasMore: cubit.hasMore,
                        state: state,
                      ),
                      state is TodoGetDataLoadingState && cubit.doneTasks.isEmpty?const Center(child: CircularProgressIndicator(color: defaultColor,),):
                      cubit.doneTasks.isEmpty?
                      const Center(child: Row(
                        children: [
                          Text("there is no task"),

                        ],
                      ))
                          :
                      buildTaskList(
                        cubit: cubit,
                        tasks: cubit.doneTasks,
                        controller: _donesScrollController,
                        deleteFunction: cubit.deleteTask,
                        updateFunction: cubit.updateTask,
                        hasMore: cubit.hasMore,
                        state: state,
                      ),
                    ],
                  )
                  ,
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
