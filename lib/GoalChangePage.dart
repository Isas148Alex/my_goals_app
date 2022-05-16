///Used for GoalChangePage with related functional

import 'package:flutter/material.dart';
import 'package:my_goals_app/GoalClass.dart';

class GoalChangePage extends StatefulWidget {
  GoalClass goal;

  GoalChangePage(this.goal, {Key? key}) : super(key: key);

  @override
  State<GoalChangePage> createState() => _GoalChangePageState();
}

class _GoalChangePageState extends State<GoalChangePage> {
  final Name = TextEditingController();
  final Description = TextEditingController();
  late String nameBuf;
  late String descriptionBuf;
  late bool isChecked;

  @override
  void initState() {
    isChecked = widget.goal.Achieved;
    nameBuf = widget.goal.Name;
    descriptionBuf = widget.goal.Description;
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    Description.dispose();
    Name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Name.text = nameBuf;
    Description.text = descriptionBuf;

    return WillPopScope(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.amber,
            onPressed: () => {
              _editGoalEnd(context)
            },
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
              title: Text(
                "Изменение цели",
                style: const TextStyle(color: Colors.black),
              )),
          body: Column(
            children: [
              const Text("название: "),
              TextField(
                controller: Name,
              ),
              const Text("Описание: "),
              TextField(
                controller: Description,
              ),
              const Text("Достигнута: "),
              Checkbox(
                checkColor: Colors.white,
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    nameBuf = Name.text;
                    descriptionBuf = Description.text;
                    isChecked = value!;
                  });
                },),
              Expanded(
                  child: ListView.builder(
                      itemCount: widget.goal.SubGoals.length,
                      itemBuilder: (context, index) {
                        return _buildListSubGoals(index);
                      }))
            ],
          ),
        ),
        onWillPop: _onWillPop);
  }

  Widget _buildListSubGoals(int index) {
    final goal = widget.goal.SubGoals[index];
    return Material(
        child: InkWell(
      child: TextButton(
        onPressed: () {
          // (Navigator.push(context,
          //     MaterialPageRoute<void>(builder: (BuildContext context) {
          //       return GoalShowPage(goal);
          //     })));
        },
        child: Text(
          goal.Name,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    ));
  }

  Future<bool> _onWillPop() async {
    if (Description.text != "" && Name.text != ""
    && (Description.text != widget.goal.Description || Name.text != widget.goal.Name))
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

  void _editGoalEnd(BuildContext context){
    widget.goal.UpdateGoal(Name.text, Description.text, isChecked, [], []);
    Navigator.pop(context, widget.goal);
  }
}
