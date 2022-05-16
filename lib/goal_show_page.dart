///Used for GoalShowPage with related functional.
///Allow to view a single goal, additional information and list of subgoals.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'goal_class.dart';
import 'goal_change_page.dart';
import 'constant_texts.dart';
import 'goal_create_page.dart';

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
        onPressed: () => {_editGoal(context)},
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
            widget.goal.name,
            style: const TextStyle(color: Colors.black),
          )),
      body: Column(
        children: [
          const Text(ConstantTexts.additionalInfo),
          Text(
            widget.goal.additionalInfo,
          ),
          const Text(ConstantTexts.creationDate),
          Text(
            DateFormat.yMMMEd().format(widget.goal.creationDateTime),
          ),
          if (widget.goal.achieved)
            Column(children: [
              const Text(ConstantTexts.achieveDate),
              Text(
                DateFormat.yMd().format(widget.goal.achieveDateTime),
              )
            ]),
          if (widget.goal.changed)
            Column(children: [
              const Text(ConstantTexts.changeDate),
              Text(
                DateFormat.yMd().format(widget.goal.changingDateTime),
              )
            ]),
          Expanded(
              child: ListView.builder(
                  itemCount: widget.goal.subgoals.length + 1,
                  itemBuilder: (context, index) {
                    return _buildListSubgoals(index);
                  }))
        ],
      ),
    );
  }

  ///Allow to build the subgoals list
  Widget _buildListSubgoals(int index) {
    if (index == 0) {
      return TextButton(
        onPressed: () {
          _addSubGoal(context);
        },
        child: const Text(ConstantTexts.add),
      );
    }
    index--;
    final goal = widget.goal.subgoals[index];
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
          goal.name,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    ));
  }

  ///Called when adding of a new subgoal has been ended
  _addSubGoal(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return const GoalCreatePage();
    }));
    if (result != null) {
      setState(() {
        widget.goal.addSubGoal(result);
      });
    }
  }

  ///Allow to edit a subgoal
  _editGoal(BuildContext context) async {
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
