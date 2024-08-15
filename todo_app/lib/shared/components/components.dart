
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/controller/cubit.dart';
import 'package:todo_app/controller/state.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/shared/style/color.dart';

Widget founctionbut({
  required String text,
  double width = double.infinity,
  double height = 50,
  Color back = defaultColor,
  required Function() function,
}) =>
    Container(
        height: height,
        color: back,
        width: width,


        child: MaterialButton(

            onPressed: function,
            child: Text(
              text.toUpperCase(),
              style: TextStyle(color: Colors.white, fontSize: 20),
            )));

Widget TextDef({
  required TextEditingController controller,
  required String lable,
  required TextInputType type,
  Function(String)? onsub,
  Function(String)? onch,
  required IconData prifix,
  IconData? suff,
  Function()? ontap,
  Function()? suffpres,
  vale,
  bool obsec = false,
  bool isen = true,
}) =>
    TextFormField(
      style: TextStyle(color: defaultColor),
      enabled: isen,
      controller: controller,
      decoration: InputDecoration(
        labelText: lable,
        border: OutlineInputBorder(),
        prefixIcon: Icon(prifix),
        suffixIcon: IconButton(
          icon: Icon(suff),
          onPressed: suffpres,
        ),
      ),
      obscureText: obsec,
      keyboardType: type,
      onFieldSubmitted: onsub,
      onChanged: onch,
      validator: vale,
      onTap: ontap,
    );
 Widget TaskItem({context,required TaskModel model,doneFunction,deleteFunction})=>Card(
elevation: 5,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(35),
),
child: Container(
child: Padding(
padding: const EdgeInsets.all(20.0),
child: Row(

children: [
  if(model.completed==true)
    Icon(Icons.check_circle_outline_outlined,size: 30,color:Colors.green,),
Expanded(child: Text("${model.todo}",style: Theme.of(context).textTheme.bodySmall,)),

IconButton(onPressed: doneFunction, icon:model.completed ==true? Icon(Icons.check_circle_outlined,size: 30,color: Colors.green,):Icon(Icons.check_circle_outline_outlined,size: 30,color:defaultColor ,)),
IconButton(onPressed: deleteFunction, icon: Icon(Icons.delete_outline,size: 30,color: Colors.redAccent,)),



],
),
),
),
);
Widget textbut({
  context,
  required String text,
  required Function() function,
}) => TextButton(onPressed: function, child: Text(text.toUpperCase(),style:Theme.of(context).textTheme.bodyMedium!.copyWith(color: defaultColor),));
Widget buildTaskList({
  required List<TaskModel> tasks,
  required ScrollController controller,
  required Function deleteFunction,
  required Function updateFunction,
  required bool hasMore,
  required TodoCubit cubit,
  required TodoStates state,
}) {
  return ListView.separated(
    controller: controller,
    itemBuilder: (context, index) {
      if (index == tasks.length && state is TodoGetDataLoadingState) {
        return Center(
          child: CircularProgressIndicator(color: defaultColor),
        );
      } else if (index == tasks.length) {
        return SizedBox(height: 2);
      } else {
        return TaskItem(
          context: context,
          model: tasks[index],
          deleteFunction: () {cubit.deleteTask(id: tasks[index].id);},
          doneFunction: () {cubit.updateTask(id:tasks[index].id,complite: tasks[index].completed);},
        );
      }
    },
    separatorBuilder: (context, index) => SizedBox(height: 10),
    itemCount: tasks.length + (hasMore ? 1 : 0),
  );
}


void NaveTo({required context,required bage}) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => bage));


void NaveToAndDelet( { context, bage}) =>
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => bage),
            (Route<dynamic> route) => false);

void ShowTaost({
  required String msg,
  required ToastState state,

})=>Fluttertoast.showToast(
    msg:msg ,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: ChooseTaostColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);
enum ToastState{SUCCESS,ERORR,WARNING}
Color ChooseTaostColor(ToastState state){
  Color color;
  switch(state){
    case ToastState.SUCCESS:
      color =Colors.green;
      break;
    case ToastState.ERORR:
      color =Colors.red;
      break;
    case ToastState.WARNING:
      color =Colors.amber;
      break;
  }
  return color;
}

Widget myDiveder()=>Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child:   Container(
    height: 1,
    width: double.infinity,
    color: Colors.grey[300],
  ),
);