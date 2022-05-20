///Used for GoalChangePage with related functional.
///Allow to change current goal, its status (achieved or not) and additional information.

import 'package:flutter/material.dart';
import 'goal_class.dart';
import 'constant_texts.dart';

class GoalChangePage extends StatefulWidget {
  GoalClass goal;

  GoalChangePage(this.goal, {Key? key}) : super(key: key);

  @override
  State<GoalChangePage> createState() => _GoalChangePageState();
}

class _GoalChangePageState extends State<GoalChangePage> {
  final name = TextEditingController();
  final additionalInfo = TextEditingController();
  late String nameBuf;
  late String additionalInfoBuf;
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    isChecked = widget.goal.getAchieved();
    nameBuf = widget.goal.getName();
    additionalInfoBuf = widget.goal.getAdditionalInfo();
  }

  @override
  void dispose() {
    additionalInfo.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    name.text = nameBuf;
    additionalInfo.text = additionalInfoBuf;

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.amber,
              onPressed: () => {_editGoalEnd(context)},
              child: const Icon(
                Icons.save,
                color: Colors.black,
              ),
            ),
            appBar: AppBar(
                centerTitle: true,
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                backgroundColor: Colors.amber,
                title: const Text(
                  ConstantTexts.changeGoal,
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
                  controller: additionalInfo,
                ),
                const Text(ConstantTexts.achieved),
                Checkbox(
                  checkColor: Colors.white,
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      nameBuf = name.text;
                      additionalInfoBuf = additionalInfo.text;
                      isChecked = value!;
                    });
                  },
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: widget.goal.subgoals.length,
                        itemBuilder: (context, index) {
                          return _buildListSubgoals(index);
                        }))
              ],
            )));
  }

  ///Allow to build the subgoals list
  Widget _buildListSubgoals(int index) {
    final goal = widget.goal.subgoals[index];
    return InkWell(
      child: Card(
        key: Key(goal.getId().toString()),
        child: ListTile(
          onTap: () => {},
          title: Center(
            child: Text(goal.getName()),
          ),
        ),
      ),
    );
  }

  ///Allow to use popup dialog for saving changes
  Future<bool> _onWillPop() async {
    if (additionalInfo.text != "" &&
        name.text != "" &&
        (additionalInfo.text != widget.goal.getAdditionalInfo() ||
            name.text != widget.goal.getName())) {
      return (await showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
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

  ///Called when goal has been changed and save button has been pressed
  void _editGoalEnd(BuildContext context) {
    widget.goal.updateGoal(name.text, additionalInfo.text, isChecked, [], []);
    Navigator.pop(context, widget.goal);
  }
}
