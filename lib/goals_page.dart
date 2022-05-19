///Used for GoalsPage with related functional.
///Allow to view all main goals and add a new main goal

import 'package:flutter/material.dart';
import 'data_base_handler.dart';
import 'goal_class.dart';
import 'goal_create_page.dart';
import 'goal_show_page.dart';
import 'constant_texts.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  List<GoalClass> goals = [];
  bool order = false;

  @override
  void initState() {
    super.initState();
    DataBaseHandler.getDataFromBase(goals);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      DataBaseHandler.rebuildGoals(goals);
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Center(
            child: Text(
          ConstantTexts.myGoals,
          style: TextStyle(color: Colors.black),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        onPressed: () {
          _addNewGoal(context);
        },
      ),
      body: ListView.builder(
          itemCount: goals.length,
          itemBuilder: (context, index) {
            final item = goals[index];

            return Dismissible(
              key: Key(item.getId().toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 10),
                  child: const Icon(Icons.delete)),
              child: InkWell(
                child: Card(
                  child: ListTile(
                    onTap: () => _viewGoal(context, item),
                    title: Center(
                      child: Text(item.getName()),
                    ),
                  ),
                ),
              ),
              confirmDismiss: (direction) {
                return _confirmDismiss(direction, item);
              },
              onDismissed: (direction) => _deleteItem(item),
            );
          }),
      bottomNavigationBar: BottomAppBar(
        color: Colors.amber,
        child: TextButton.icon(
          icon: const Icon(Icons.sort_by_alpha, color: Colors.black),
          onPressed: () {
            setState(() {
              if (!order) {
                goals.sort((a, b) => a.getName().compareTo(b.getName()));
              } else {
                goals.sort((a, b) => b.getName().compareTo(a.getName()));
              }
              order = !order;
            });
          },
          label: const Text(ConstantTexts.sort,
              style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  Future<bool> _confirmDismiss(
      DismissDirection direction, GoalClass goal) async {
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
  }

  ///Called when viewing a goal has been ended
  void _viewGoal(BuildContext context, GoalClass item) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return GoalShowPage(item);
    })).then((value) => setState(() {}));
  }

  void _deleteItem(GoalClass goal) {
    DataBaseHandler.deleteDataBase(goal);
    goals.remove(goal);
  }

  ///Allow to create a new goal
  void _addNewGoal(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return GoalCreatePage();
    }));
    if (result != null) {
      setState(() {
        goals.add(result);
        DataBaseHandler.addDataBase(result);
      });
    }
  }
}
