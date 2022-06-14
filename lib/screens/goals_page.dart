///Used for GoalsPage with related functional.
///Allow to view all main goals and add a new main goal

import 'package:flutter/material.dart';
import '../constants/theme_constants.dart';
import '../data_base_handler.dart';
import '../model/goal_class.dart';
import 'goal_create_page.dart';
import 'goal_show_page.dart';
import '../constants/constant_texts.dart';

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
        appBar: _buildScaffoldAppBar(),
        floatingActionButton: _buildScaffoldFloatingActionButton(),
        body: _buildScaffoldBody(),
        bottomNavigationBar: _buildScaffoldNavBar());
  }

  AppBar _buildScaffoldAppBar() {
    return AppBar(
      backgroundColor: ConstantsTheme.mainColor,
      title: const Center(
          child: Text(
        ConstantTexts.myGoals,
        style: TextStyle(color: ConstantsTheme.darkColor),
      )),
    );
  }

  Widget _buildScaffoldBody() {
    return ListView.builder(
        itemCount: goals.length,
        itemBuilder: (context, index) {
          final item = goals[index];

          return Dismissible(
            key: Key(item.getId().toString()),
            background: Container(
              color: item.getAchieved()
                  ? ConstantsTheme.yellowColor
                  : ConstantsTheme.greenColor,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 10),
              child: item.getAchieved()
                  ? const Icon(
                      Icons.close,
                    )
                  : const Icon(
                      Icons.done,
                    ),
            ),
            secondaryBackground: Container(
                color: ConstantsTheme.redColor,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 10),
                child: const Icon(
                  Icons.delete,
                )),
            child: InkWell(
              child: Card(
                child: ListTile(
                  onTap: () => _viewGoal(context, item),
                  title: Text(item.getName()),
                  trailing: Icon(
                    item.getAchieved() ? Icons.check : Icons.close,
                    color: item.getAchieved()
                        ? ConstantsTheme.greenColor
                        : ConstantsTheme.redColor,
                  ),
                ),
              ),
            ),
            confirmDismiss: (direction) {
              if (direction == DismissDirection.endToStart) {
                return _confirmDismiss(direction, item);
              }
              return _confirmDone(direction, item);
            },
            onDismissed: (direction) => _dismissItem(item),
          );
        });
  }

  Widget _buildScaffoldNavBar() {
    return BottomAppBar(
      color: ConstantsTheme.mainColor,
      child: TextButton.icon(
        icon: const Icon(Icons.sort_by_alpha, color: ConstantsTheme.darkColor),
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
            style: TextStyle(color: ConstantsTheme.darkColor)),
      ),
    );
  }

  Widget _buildScaffoldFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: ConstantsTheme.mainColor,
      child: const Icon(
        Icons.add,
        color: ConstantsTheme.darkColor,
      ),
      onPressed: () {
        _addNewGoal(context);
      },
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
  Future<bool> _confirmDone(DismissDirection direction, GoalClass goal) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: !goal.getAchieved()
                ? const Text(ConstantTexts.doneSure)
                : const Text(ConstantTexts.undoSure),
            content: const Text(ConstantTexts.rollback),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  setState(() {
                    goal.achieveGoal(!goal.getAchieved());
                  });
                  DataBaseHandler.updateDataBase(goal);
                  Navigator.of(context).pop(false);
                },
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

  void _viewGoal(BuildContext context, GoalClass item) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return GoalShowPage(item);
    })).then((value) => setState(() {}));
  }

  void _dismissItem(GoalClass goal) {
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
