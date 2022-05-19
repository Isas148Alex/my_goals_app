///Used for GoalShowPage with related functional.
///Allow to view a single goal, additional information and list of subgoals.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_goals_app/data_base_handler.dart';
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
            widget.goal.getName(),
            style: const TextStyle(color: Colors.black),
          )),
      body: Column(
        children: [
          const Text(ConstantTexts.additionalInfo),
          Text(
            widget.goal.getAdditionalInfo(),
          ),
          const Text(ConstantTexts.creationDate),
          Text(
            DateFormat.yMMMEd().format(widget.goal.getCreationDate().toDate()),
          ),
          if (widget.goal.getChanged())
            Column(children: [
              const Text(ConstantTexts.changeDate),
              Text(
                DateFormat.yMd().format(widget.goal.getChangingDate().toDate()),
              )
            ]),
          if (widget.goal.getAchieved())
            Column(children: [
              const Text(ConstantTexts.achieveDate),
              Text(
                DateFormat.yMd().format(widget.goal.getAchieveDate().toDate()),
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
    return Dismissible(
      key: Key(goal.getId().toString()),
      child: Card(
          child: InkWell(
              child: TextButton(
                onPressed: () {
                  _viewGoal(context, goal);
                },
                child: Text(
                  goal.getName(),
                  style: const TextStyle(color: Colors.black),
                ),
              ))),
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(ConstantTexts.deleteSure),
            content: const Text(ConstantTexts.noRollback),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(ConstantTexts.yes),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(ConstantTexts.no),
              ),
            ],
          ),
        ) ??
            false;
      },
      onDismissed: (direction) => _deleteItem(goal),
    );
  }

  void _viewGoal(BuildContext context, GoalClass item) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return GoalShowPage(item);
    })).then((value) => setState(() {}));
  }

  void _deleteItem(GoalClass goal) {
    setState((){
      widget.goal.subgoals.remove(goal);
      DataBaseHandler.deleteDataBase(goal);
    });
  }

  ///Called when adding of a new subgoal has been ended
  _addSubGoal(BuildContext context) async {
    final result = await Navigator.of(context).push(
        MaterialPageRoute(builder: (BuildContext context) {
      return GoalCreatePage(parentId: widget.goal.getId());
    }));
    if (result != null) {
      setState(() {
        widget.goal.addSubGoal(result);
        DataBaseHandler.addDataBase(result);
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
        DataBaseHandler.updateDataBase(result);
      });
    }
  }
}
