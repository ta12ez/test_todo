import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/controller/cubit.dart';
import 'package:todo_app/shared/bloc_opserver.dart';
import 'package:todo_app/shared/constans/constant.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';
import 'package:todo_app/shared/network/remote/dio_helper.dart';
import 'package:todo_app/shared/style/theme.dart';
import 'package:todo_app/veiw/home_screen.dart';
import 'package:todo_app/veiw/login_screen.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();
  Bloc.observer=MyBlocObserver();
  id=CacheHelper.getData(key: 'userId');
  Widget startWidget;

  if(id!=null){
    startWidget=HomeScreen();
  }else{
    startWidget=LoginScreen();
  }


  runApp( MyApp(startWidget: startWidget,));
}

class MyApp extends StatelessWidget {
  Widget startWidget;
   MyApp({super.key,required this.startWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:(context)=> TodoCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lighttheme,
        home: startWidget,
      ),
    );
  }
}

