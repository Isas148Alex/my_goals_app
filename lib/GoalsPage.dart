import 'package:flutter/material.dart';

import 'GoalClass.dart';
import 'GoalCreatePage.dart';
import 'GoalShowPage.dart';

class GoalsPage extends StatefulWidget {
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  var Goals = [GoalClass("Test Goals"),GoalClass("Test Goals 2")];

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
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.amber,
            child: Icon(
              Icons.add,
              color: Colors.black,
            ),
            onPressed: () {
              (Navigator.push(context,
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return GoalCreatePage();
              })));
            },
          ),
          body: ListView.builder(
              itemCount: Goals.length,
              itemBuilder: (context, index) {
                final item = Goals[index];
                return Material(
                    child: InkWell(
                        child: Container(
                  child: TextButton(
                    onPressed: () {
                      (Navigator.push(context,
                          MaterialPageRoute<void>(builder: (BuildContext context) {
                            return GoalShowPage(item);
                          })));
                    },
                    child: Text(
                      (item as GoalClass).Description,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                )));
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
