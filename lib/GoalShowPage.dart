///Used for GoalShowPage with related functional

import 'package:flutter/material.dart';
import 'package:my_goals_app/GoalClass.dart';
import 'package:intl/intl.dart';

class GoalShowPage extends StatefulWidget {
  GoalClass goal;

  GoalShowPage(this.goal, {Key? key}) : super(key: key);

  @override
  State<GoalShowPage> createState() => _GoalShowPageState();
}

class _GoalShowPageState extends State<GoalShowPage> {
  @override
  Widget build(BuildContext context) {
    //widget.goal.SubGoals.add(GoalClass("Description", "Name"));
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              Text("Описание: "),
              Container(
                  child: Text(
                widget.goal.Description,
              )),
              Text("Дата создания: "),
              Container(
                  child: Text(
                DateFormat.yMMMEd().format(widget.goal.CreationDateTime),
              )),
              if (widget.goal.Achieved)
                Column(children: [
                  Text("Дата достижения: "),
                  Text(
                    DateFormat.yMd().format(widget.goal.AchieveDateTime),
                  )
                ]),
              if (widget.goal.Changed)
                Column(children: [
                  Text("Дата изменения: "),
                  Text(
                    DateFormat.yMd().format(widget.goal.ChangingDateTime),
                  )
                ]),
            ],
          ),
        ],
      ),
    );
  }
}
