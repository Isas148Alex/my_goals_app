import 'package:flutter/material.dart';

import 'GoalClass.dart';
import 'GoalCreatePage.dart';
import 'GoalShowPage.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  _GoalsPageState createState() => _GoalsPageState();
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
          "Мои цели",
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
              _navigateEnd(context);
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
                    _showGoalEnd(context, item);
                  },
                  child: Text(
                    item.Name,
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
          label:
              const Text("Сортировка", style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  void _showGoalEnd(BuildContext context, GoalClass item) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return GoalShowPage(item);
    })).then((value) => setState(() {}));
  }

  void _navigateEnd(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return GoalCreatePage();
    }));
    if (result != null) {
      setState(() {
        goals.add(result);
      });
    }
  }
}
