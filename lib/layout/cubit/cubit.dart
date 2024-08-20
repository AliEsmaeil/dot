import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart' show Database, getDatabasesPath, openDatabase;
import 'package:todo_with_cubit/layout/cubit/states.dart';
import 'package:todo_with_cubit/models/task.dart';

class HomeLayoutCubit extends Cubit<HomeLayoutStates>{

  int currentIndex = -1;

  bool isBottomSheetShown = false;


  static late Database db;

  static List<Map<String,dynamic>> newTasks = [] ;
  static List<Map<String,dynamic>> doneTasks = [] ;
  static List<Map<String,dynamic>> archivedTasks = [] ;



  HomeLayoutCubit():super(LoadingState());

  static HomeLayoutCubit getCubit(context)=>BlocProvider.of(context);


  void changeScreensByCurrentIndex(int index){

    currentIndex = index;
    emit(HomeLayoutStateChangedByNavBar());
  }

  void setBottomSheetVisibility(bool isShown){
    isBottomSheetShown = isShown;
    emit(HomeLayoutStateChangedByBottomSheet());

  }

  //////////////////////////////////////////////////////////////////// database ops

  void initiateDatabase()async{

    db = await openDatabase(
      '${await getDatabasesPath()}demo.db',
      version: 1,
      onCreate:(database, version)async{
        await database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR(30) NOT NULL, time VARCHAR(30) NOT NULL,date VARCHAR(30) NOT NULL, status VARCHAR(8) NOT NULL)')
            .catchError((error){});
      },
      onOpen: (database)async{

        await retrieveAllTasksFromDatabase(database);
      }
        );
      }

  Future<void> retrieveAllTasksFromDatabase(Database db)async{

    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(LoadingState());
     await db.rawQuery('SELECT * FROM tasks').then((value) {

       for(var element in value) {
         if (element['status'] == 'new') {
           newTasks.add(element);
         }
         else if (element['status'] == 'done') {
           doneTasks.add(element);
         }
         else {
           archivedTasks.add(element);
         }
       }
       }
       ); // end of then
       emit(GotDataState());
     }

  void insertTaskIntoDatabase(Task task)async{

    await db.transaction((txn) async{
      // review this string query (sqlite may refuse because of the values not surrounded by single ^ double quotes
      await txn.rawInsert("INSERT INTO tasks (title,time,date,status) VALUES ('${task.title}', '${task.time}','${task.date}', 'new')")
           .then((value){emit(InsertState());} );
    });

    await retrieveAllTasksFromDatabase(db);
  }

  void updateTaskInDatabase({required String query})async
  {
    await db.rawUpdate(query).then((value) async{
      emit(UpdateState());
      await retrieveAllTasksFromDatabase(db);

    });
    
  }

  void deleteTaskFromDatabase({required String query})async
  {
    await db.rawDelete(query).then((value) async{
      emit(DeleteState());
      await retrieveAllTasksFromDatabase(db);
    });

  }
  void emitSearchedTasks(List<Map<String,dynamic>> searchedTasks, String whichTaskList){

    emit(LoadingState());

    if(whichTaskList == 'newTasks'){
      newTasks = searchedTasks;
    }
    else if(whichTaskList == 'doneTasks'){
      doneTasks = searchedTasks;
    }
    else{
      archivedTasks = searchedTasks;
    }
    emit(SearchedTasksState());
  }


}

