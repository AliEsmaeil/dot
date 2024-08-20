import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_with_cubit/layout/cubit/cubit.dart';
import 'package:todo_with_cubit/layout/cubit/states.dart';
import 'package:todo_with_cubit/models/task.dart';
import 'package:todo_with_cubit/modules/archived_tasks.dart';
import 'package:todo_with_cubit/modules/done_tasks.dart';
import 'package:todo_with_cubit/modules/new_tasks.dart';
import 'package:todo_with_cubit/shared/text_field/default_text_field.dart';
import 'package:todo_with_cubit/shared/text_field/text_form_field_validator.dart';

class HomeLayout extends StatelessWidget {

  final titles = <String>['Done Tasks','Archived Tasks',];
  final screens = const <Widget>[DoneTasks(),ArchivedTasks()];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final timeController = TextEditingController();
  final dateController = TextEditingController();

  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context)=>HomeLayoutCubit()..initiateDatabase(),
      child: BlocConsumer<HomeLayoutCubit,HomeLayoutStates>(
        listener: (context, states){},
        builder: (context,states){
          var cubit = HomeLayoutCubit.getCubit(context);
          return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(cubit.currentIndex == -1 ? 'New Tasks' : titles[cubit.currentIndex]),
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 1,
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 25,
                  color: Colors.black,
                ),
                scrolledUnderElevation: 0,
                titleSpacing: 2,
              ),
              body: ConditionalBuilder(
                condition: states is! LoadingState,
                builder: (context) => cubit.currentIndex == -1 ? const NewTasks() : screens[cubit.currentIndex],
                fallback: (context)=> Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue.shade700,
                    strokeWidth: 1.5,
                    semanticsLabel: 'Wait a second',
                  ),
                )
              ),
              bottomNavigationBar: BottomAppBar(
                elevation: 1,
                shape: const CircularNotchedRectangle(),
                color: Colors.blue.shade200,
                height: 60,
                notchMargin: 7.5,
                shadowColor: Colors.white,
                surfaceTintColor: Colors.white38,
                clipBehavior: Clip.antiAlias,
                child: NavigationBar(
                  backgroundColor: Colors.blue.shade200,
                  elevation: 0,
                  indicatorColor: cubit.currentIndex == -1? Colors.white.withAlpha(0): Colors.white,
                  selectedIndex: cubit.currentIndex == -1 ? 0 : cubit.currentIndex,

                  onDestinationSelected: (index){
                    cubit.changeScreensByCurrentIndex(index);
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.done),
                      label: 'Done',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.archive),
                      label: 'Archive',
                    ),
                  ],
                ),

              ),
              extendBody: true,
              floatingActionButton: FloatingActionButton(
                onPressed: (){
                  cubit.changeScreensByCurrentIndex(-1);

                  if(cubit.isBottomSheetShown){
                    if(formKey.currentState!.validate()){
                      // insert new task
                      cubit.insertTaskIntoDatabase(Task(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text,
                      ));
                      cubit.setBottomSheetVisibility(false);
                      Navigator.of(context).pop();
                      clearTextControllers();
                    }
                  }
                  else
                  {
                    cubit.setBottomSheetVisibility(true);
                    scaffoldKey.currentState!.showBottomSheet((context) =>
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(
                                  height: 35,
                                ),
                                defaultTextField(
                                  label: 'Title',
                                  controller: titleController,
                                  preIcon: Icons.title,
                                  validator: getValidateFunction(errorMessage: 'Title is empty!'),
                                  keyboardType: TextInputType.name,
                                ),
                                const SizedBox(height: 15,),
                                defaultTextField(
                                    label: 'Time',
                                    controller: timeController,
                                    preIcon: Icons.watch_later_outlined,
                                    validator: getValidateFunction(errorMessage: 'Time isn\'t selected!'),
                                    readOnly: true,
                                    onTap: (){
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) => timeController.text= value!.format(context))
                                          .catchError((error)=>'error occurred in time picking $error')
                                      ;
                                    }
                                ),
                                const SizedBox(height: 15,),

                                defaultTextField(
                                    label: 'Date',
                                    controller: dateController,
                                    preIcon: Icons.calendar_month_outlined,
                                    validator: getValidateFunction(errorMessage: 'Date isn\'t selected!'),
                                    readOnly: true,
                                    onTap: (){
                                      showDatePicker(
                                          context: context,
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime.now().add(const Duration(days: 30)),
                                      ).then((value) => dateController.text=value.toString().substring(0,10))
                                          .catchError((error)=>'error occurred in date picking $error');
                                    }
                                ),
                                const SizedBox(height: 15,),


                              ],
                            ),
                          ),
                        ),
                     // backgroundColor: Colors.blue.shade100,
                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ).closed.then((value) {
                      clearTextControllers();
                      cubit.setBottomSheetVisibility(false);
                    } );
                  }
                },
                backgroundColor: Colors.blue,
                elevation: 0,
                foregroundColor: cubit.currentIndex== -1 ? Colors.white : const Color(0xffadafb3),
                shape: const CircleBorder(),
                child: cubit.isBottomSheetShown? const Icon(Icons.add): const Icon(Icons.arrow_drop_up),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              backgroundColor: Colors.white,
              resizeToAvoidBottomInset: false,
          );
        },
      ),
    );
  }

  void clearTextControllers(){
    titleController.text = '';
    timeController.text = '';
    dateController.text = '';
  }
}

