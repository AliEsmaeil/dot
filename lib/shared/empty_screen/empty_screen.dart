import 'package:flutter/material.dart';

Widget imageScreenWithHint({required String hint})=> Column(
  children: [
    Image.asset(
      'images/task.jpg',
    ),
    SizedBox(height: 10,),
    Text(
      hint,
      style: TextStyle(
        color: Colors.black,
        fontSize: 23,
        fontWeight: FontWeight.w300,
        letterSpacing: 1.5,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
  ],
);