import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_with_cubit/layout/cubit/cubit.dart';
import 'package:todo_with_cubit/layout/cubit/states.dart';
import 'package:todo_with_cubit/shared/body/list_view_builder.dart';
import 'package:todo_with_cubit/shared/empty_screen/empty_screen.dart';


class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<HomeLayoutCubit,HomeLayoutStates>(
      listener: (context,states){},
      builder: (context,states) {
        List<Map<String,dynamic>> tasks = HomeLayoutCubit.archivedTasks;

        return ConditionalBuilder(
          condition: tasks.isNotEmpty,
          builder: (context)=> buildListView(tasks: tasks , taskBuilder: buildArchivedTaskItem) ,
          fallback: (context)=> imageScreenWithHint(hint: 'Archive Your Tasks.'),

        );
      },
    );
  }
  Widget buildArchivedTaskItem(Map<String,dynamic> task, context){

    var cubit = HomeLayoutCubit.getCubit(context);

    return Dismissible(
      key: Key(task['id'].toString()),
      direction:DismissDirection.horizontal,
      onDismissed: (dd){
        cubit.deleteTaskFromDatabase(query: 'DELETE FROM tasks where id = ${task['id']}');
      },
      child: Card(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black,
        margin: const EdgeInsets.all(10),
        child: Container(
          width: double.infinity,
          height: 100,
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Color((task['id'] * 0x12C1A0).toInt()).withOpacity(1.0),
                foregroundColor: Colors.white,
                child: Text(
                  task['time'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 5,),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task['title'],
                      style: const TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      task['date'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.deepPurpleAccent,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),

              IconButton(
                icon: const Icon(Icons.unarchive),
                onPressed: (){
                  cubit.updateTaskInDatabase(query: "UPDATE tasks SET status = 'new' WHERE id = ${task['id']}");
                },
                iconSize: 23,
                color: const Color(0xfff3dc00),

              ),

            ],
          ),
        ),
      ),
    );
  }
}
