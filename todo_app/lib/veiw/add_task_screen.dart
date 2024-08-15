import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/controller/cubit.dart';
import 'package:todo_app/controller/state.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/style/color.dart';

class AddTaskScreen extends StatelessWidget {

  var taskeNameController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit,TodoStates>(
      listener: (context,state){

        if (state is TodoAddTaskErorrState) {
          ShowTaost(msg: 'YouCanNotAddTaskWithoutInternet', state: ToastState.ERORR);
        }
      },
      builder: (context,state) {
        var cubit =TodoCubit.get(context);
        if(state is TodoAddTaskSuccessState){
          cubit.tasks=[];
          cubit.undoneTasks=[];
          cubit.doneTasks=[];
          cubit.skip=0;
          cubit.getTasks();
          ShowTaost(msg: 'Add Task Succes', state: ToastState.SUCCESS);

          Navigator.pop(context);

        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "ADD Task",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: defaultColor),
            ),
          ),
          body:  Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Your Taske Name:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(height: 20,),

                        TextDef(
                            controller:taskeNameController ,
                            prifix: Icons.checklist,
                            type: TextInputType.emailAddress,
                            lable: 'Task Name',
                            vale: (String? value) {
                              if (value!.isEmpty) {
                                return 'the email should not be empty';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ConditionalBuilder(
                          condition: state is! TodoAddTaskLoadingState,
                          builder: (BuildContext context) => founctionbut(
                            text: 'Add',
                            function: () {
                              if (formKey.currentState!.validate()) {
                                cubit.addTask(
                                    taskName: '${taskeNameController.text}'
                                );
                              }
                            },
                          ),
                          fallback: (BuildContext context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
