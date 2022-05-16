///Used for GoalShowPage with related functional

import 'package:flutter/material.dart';
import 'package:my_goals_app/GoalClass.dart';
import 'package:my_goals_app/GoalChangePage.dart';
import 'package:intl/intl.dart';

import 'GoalCreatePage.dart';

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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        onPressed: () => {_editGoalEnd(context)},
        child: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
      ),
      appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.amber,
          title: Text(
            widget.goal.Name,
            style: const TextStyle(color: Colors.black),
          )),
      body: Column(
        children: [
          const Text("Описание: "),
          Text(
            widget.goal.Description,
          ),
          const Text("Дата создания: "),
          Text(
            DateFormat.yMMMEd().format(widget.goal.CreationDateTime),
          ),
          if (widget.goal.Achieved)
            Column(children: [
              const Text("Дата достижения: "),
              Text(
                DateFormat.yMd().format(widget.goal.AchieveDateTime),
              )
            ]),
          if (widget.goal.Changed)
            Column(children: [
              const Text("Дата изменения: "),
              Text(
                DateFormat.yMd().format(widget.goal.ChangingDateTime),
              )
            ]),
          Expanded(
              child: ListView.builder(
                  itemCount: widget.goal.SubGoals.length + 1,
                  itemBuilder: (context, index) {
                    return _buildListSubGoals(index);
                  }))
        ],
      ),
    );
  }

  Widget _buildListSubGoals(int index) {
    if (index == 0) {
      return TextButton(
        onPressed: () {
          _addSubGoalEnd(context);
        },
        child: const Text("Добавить"),
      );
    }
    index--;
    final goal = widget.goal.SubGoals[index];
    return Material(
        child: InkWell(
      child: TextButton(
        onPressed: () {
          (Navigator.push(context,
              MaterialPageRoute<void>(builder: (BuildContext context) {
            return GoalShowPage(goal);
          })));
        },
        child: Text(
          goal.Name,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    ));
  }

  _addSubGoalEnd(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return GoalCreatePage();
    }));
    if (result != null) {
      setState(() {
        widget.goal.addSubGoal(result);
      });
    }
  }

  _editGoalEnd(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return GoalChangePage(widget.goal);
    }));
    if (result != null) {
      setState(() {
        widget.goal = result;
      });
    }
  }
}
