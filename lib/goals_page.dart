///Used for GoalsPage with related functional.
///Allow to view all main goals and add a new main goal

import 'package:flutter/material.dart';
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
  var goals = [GoalClass("Test Goal", "G1"), GoalClass("Test Goal 2", "G2")];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Center(
            child: Text(
          ConstantTexts.myGoals,
          style: TextStyle(color: Colors.black),
        )),
      ),
      body: Center(
        child: Scaffold(
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
                return Material(
                    child: InkWell(
                        child: TextButton(
                  onPressed: () {
                    _viewGoal(context, item);
                  },
                  child: Text(
                    item.name,
                    style: const TextStyle(color: Colors.black),
                  ),
                )));
              }),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.amber,
        child: TextButton.icon(
          icon: const Icon(Icons.sort, color: Colors.black),
          onPressed: () {},
          label: const Text(ConstantTexts.sort,
              style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  ///Called when viewing a goal has been ended
  void _viewGoal(BuildContext context, GoalClass item) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return GoalShowPage(item);
    })).then((value) => setState(() {}));
  }

  ///Allow to create a new goal
  void _addNewGoal(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return const GoalCreatePage();
    }));
    if (result != null) {
      setState(() {
        goals.add(result);
      });
    }
  }
}
