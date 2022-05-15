///Used for GoalCreatePage with related functional

import 'package:flutter/material.dart';

class GoalCreatePage extends StatefulWidget{
  @override
  _GoalCreatePageState createState() => _GoalCreatePageState();
}

class _GoalCreatePageState extends State<GoalCreatePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Center(
            child: Text(
              "Мои цели",
              style: TextStyle(color: Colors.black),
            )),
      ),
    );
  }
}