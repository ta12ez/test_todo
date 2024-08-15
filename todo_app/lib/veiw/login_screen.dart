import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/controller/cubit.dart';
import 'package:todo_app/controller/state.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/constans/constant.dart';
import 'package:todo_app/shared/network/local/cache_helper.dart';
import 'package:todo_app/veiw/home_screen.dart';

class LoginScreen extends StatelessWidget {

  var emailController = TextEditingController();
  var passController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoStates>(
      listener: (context, state) {
        if (state is TodoLoginSuccessState) {

            print(state.loginModel?.token);
            ShowTaost(
                msg: 'Welcome',
                state: ToastState.SUCCESS);
            CacheHelper.SaveData(key:'userId',value:state.loginModel!.id  ).then((value){
              id=state.loginModel!.id;
            });
            CacheHelper.SaveData(
                key: 'refreshToken', value: state.loginModel?.refreshToken)
                .then((value) {
              refreshToken =state.loginModel?.refreshToken;
              if (value) {
                CacheHelper.SaveData(
                    key: 'token', value: state.loginModel?.token)
                    .then((value) {
                  token =state.loginModel?.token;
                  if (value) {
                    NaveToAndDelet(context: context, bage: HomeScreen());
                  }
                });

              }
            });

        }
        else if(state is TodoLoginErorrState){
          if(state.erorr =="connection erorr" ){
            ShowTaost(
                msg: 'check Your Connection',
                state: ToastState.ERORR);

          }else if(state.erorr=="Unexpected error"){
            ShowTaost(
                msg: 'Some Thing Unexpected Get Wrong',
                state: ToastState.ERORR);

          }else{
            ShowTaost(
                msg: 'check Your UserName or PassWord',
                state: ToastState.ERORR);

          }

        }
      },
      builder: (context, state) {
        var cubit = TodoCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Center(
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
                          'LOGIN',
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        Text(
                          'login now to manage your time',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextDef(
                            controller: emailController,
                            prifix: Icons.person,
                            type: TextInputType.emailAddress,
                            lable: 'User Name',
                            vale: (String? value) {
                              if (value!.isEmpty) {
                                return 'the email should not be empty';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 20,
                        ),
                        TextDef(
                            controller: passController,
                            prifix: Icons.lock_outline,
                            type: TextInputType.visiblePassword,
                            lable: 'PassWord',
                            onsub: (value) {
                              if (formKey.currentState!.validate()) {
                                cubit.userLogin(
                                    email: '${emailController.text}',
                                    password: '${passController.text}');
                              }
                            },
                            suff: cubit.suffix,
                            suffpres: () {
                              cubit.ChangePasswordVisibility();
                            },
                            obsec: cubit.isSecret,
                            vale: (String? value) {
                              if (value!.isEmpty) {
                                return 'the password is too short';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 30,
                        ),
                        ConditionalBuilder(
                          condition: state is! TodoLoginLoadingState,
                          builder: (BuildContext context) => founctionbut(
                            text: 'LOGIN',
                            function: () {
                              if (formKey.currentState!.validate()) {
                                cubit.userLogin(
                                    email: '${emailController.text}',
                                    password: '${passController.text}');
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



