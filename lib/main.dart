import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_with_cubit/layout/home_layout.dart';
import 'package:todo_with_cubit/shared/bloc_observing/bloc_observer.dart';
void main()async{

  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
    runApp(
      MaterialApp(
        home: HomeLayout(),
        debugShowCheckedModeBanner: false,
        title: 'Dot',
      ),
    );

}