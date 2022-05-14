import 'package:flutter/material.dart';

import 'GoalClass.dart';

class GoalsPage extends StatefulWidget {
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  var Goals = [
    TextButton(
      onPressed: () {},
      child: Text("Добавить цель"),
    ),
    GoalClass("Test Goals")
  ];

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
      body: Center(
        child: Scaffold(
          body: ListView.builder(
              itemCount: Goals.length,
              itemBuilder: (context, index) {
                final item = Goals[index];

                try {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [(item as TextButton)],
                  );
                } catch (e) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text((item as GoalClass).getDescription())],
                  );
                }
              }),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.amber,
        child: TextButton.icon(
          icon: Icon(Icons.sort, color: Colors.black),
          onPressed: () {},
          label: Text("Сортировка", style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}
