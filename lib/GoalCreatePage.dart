///Used for GoalCreatePage with related functional

import 'package:flutter/material.dart';
import 'package:my_goals_app/GoalClass.dart';

class GoalCreatePage extends StatefulWidget {
  @override
  _GoalCreatePageState createState() => _GoalCreatePageState();
}

class _GoalCreatePageState extends State<GoalCreatePage> {
  final Name = TextEditingController();
  final Description = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    Description.dispose();
    Name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.amber,
              title: Text(
                "Создать цель",
                style: TextStyle(color: Colors.black),
              )),
          body: Column(
            children: [
              Text("Название: "),
              TextField(
                controller: Name,
              ),
              Text("Описание: "),
              TextField(
                controller: Description,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.amber,
            child: Icon(
              Icons.save,
              color: Colors.black,
            ),
            onPressed: () {
              if (Description.text != "" && Name.text != "") {
                Navigator.pop(context, GoalClass(Description.text, Name.text));
              }
            },
          ),
        ),
        onWillPop: _onWillPop);
  }

  Future<bool> _onWillPop() async {
    if (Description.text != "" || Name.text != "")
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: new Text('Выйти без изменений?'),
              //content: new Text('Do you want to exit an App'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: new Text('Да'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('Нет'),
                ),
              ],
            ),
          )) ??
          false;
    return true;
  }
}
