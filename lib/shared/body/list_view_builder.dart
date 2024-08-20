import 'package:flutter/material.dart';

Widget buildListView({
  required List<Map<String,dynamic>> tasks,
  required Widget?Function(Map<String,dynamic> map,BuildContext context) taskBuilder,
})=>Column(
  children: [
    Expanded(
      child: ListView.separated(
        itemBuilder: (context, index) => taskBuilder(tasks[index],context),
        separatorBuilder: (context, index) {
          return const Divider(
            height: 1,
            indent: 15,
            endIndent: 15,
            color: Colors.grey,
            thickness: .5,
          );
        },
        itemCount: tasks.length,

      ),
    ),
    SizedBox(height: 22,),
  ],
);