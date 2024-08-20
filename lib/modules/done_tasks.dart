import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_with_cubit/layout/cubit/cubit.dart';
import 'package:todo_with_cubit/layout/cubit/states.dart';
import 'package:todo_with_cubit/shared/body/list_view_builder.dart';
import 'package:todo_with_cubit/shared/empty_screen/empty_screen.dart';


class DoneTasks extends StatelessWidget {
  const DoneTasks({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<HomeLayoutCubit,HomeLayoutStates>(
      listener: (context,states){},
      builder: (context,states) {
        List<Map<String,dynamic>> tasks = HomeLayoutCubit.doneTasks;

        return ConditionalBuilder(
          condition: tasks.isNotEmpty,
          builder: (context)=> buildListView(tasks: tasks , taskBuilder: buildDoneTaskItem) ,
          fallback: (context)=> imageScreenWithHint(hint: 'Mark Your Tasks as Done.'),

        );
      },
    );
  }
  Widget buildDoneTaskItem(Map<String,dynamic> task, context){

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
              Checkbox(
                onChanged: (v)async{
                  cubit.updateTaskInDatabase(query: "UPDATE tasks SET status = '${v!? 'done' : 'new'}' WHERE id = ${task['id']}");

                },
                value:  task['status'] == 'done'?true:false,
                activeColor: Colors.green,
                checkColor: Colors.white,
               // side: BorderSide(),
              ),
              IconButton(
                icon: const Icon(Icons.archive),
                onPressed: (){
                  cubit.updateTaskInDatabase(query: "UPDATE tasks SET status = 'archived' WHERE id = ${task['id']}");

                },
                iconSize: 23,

              ),

            ],
          ),
        ),
      ),
    );
  }
}
