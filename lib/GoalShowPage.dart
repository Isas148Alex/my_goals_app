///Used for GoalShowPage with related functional

import 'package:flutter/material.dart';
import 'package:my_goals_app/GoalClass.dart';

class GoalShowPage extends StatefulWidget {
  GoalClass goal;
  GoalShowPage(this.goal, {Key? key}) : super(key: key);

  @override
  State<GoalShowPage> createState() => _GoalShowPageState();
}

class _GoalShowPageState extends State<GoalShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.amber,
          title: Text(
            widget.goal.Name,
            style: TextStyle(color: Colors.black),
          )),
    );
  }
}
