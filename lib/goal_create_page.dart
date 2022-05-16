///Used for GoalCreatePage with related functional.
///Allow to create a new goal, with name and additional information.

import 'package:flutter/material.dart';
import 'goal_class.dart';
import 'constant_texts.dart';

class GoalCreatePage extends StatefulWidget {
  const GoalCreatePage({Key? key}) : super(key: key);

  @override
  State<GoalCreatePage> createState() => _GoalCreatePageState();
}

class _GoalCreatePageState extends State<GoalCreatePage> {
  final name = TextEditingController();
  final description = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    description.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
              backgroundColor: Colors.amber,
              title: const Text(
                ConstantTexts.createGoal,
                style: TextStyle(color: Colors.black),
              )),
          body: Column(
            children: [
              const Text(ConstantTexts.name),
              TextField(
                controller: name,
              ),
              const Text(ConstantTexts.additionalInfo),
              TextField(
                controller: description,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.amber,
            child: const Icon(
              Icons.save,
              color: Colors.black,
            ),
            onPressed: () {
              if (description.text != "" && name.text != "") {
                Navigator.pop(context, GoalClass(description.text, name.text));
              }
            },
          ),
        ));
  }

  ///Allow to use popup dialog for saving changes
  Future<bool> _onWillPop() async {
    if (description.text != "" || name.text != "") {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(ConstantTexts.exitWithoutChanges),
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
          )) ??
          false;
    }
    return true;
  }
}
