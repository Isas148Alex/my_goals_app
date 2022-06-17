///Used for GoalShowPage with related functional.
///Allow to view a single goal, additional information and list of subgoals.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_goals_app/data_base_handler.dart';
import '../constants/theme_constants.dart';
import '../model/goal_class.dart';
import 'goal_change_page.dart';
import '../constants/constant_texts.dart';
import 'goal_create_page.dart';

class GoalShowPage extends StatefulWidget {
  GoalClass goal;

  GoalShowPage(this.goal, {Key? key}) : super(key: key);

  @override
  State<GoalShowPage> createState() => _GoalShowPageState();
}

class _GoalShowPageState extends State<GoalShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildScaffoldAppBar(),
      floatingActionButton: _buildScaffoldFloatingActionButton(),
      body: _buildScaffoldBody(),
    );
  }

  AppBar _buildScaffoldAppBar() {
    return AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: ConstantsTheme.darkColor,
        ),
        backgroundColor: ConstantsTheme.mainColor,
        title: Text(
          widget.goal.getName(),
          style: const TextStyle(color: ConstantsTheme.darkColor),
        ));
  }

  Widget _buildScaffoldFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: ConstantsTheme.mainColor,
      onPressed: () => {_editGoal(context)},
      child: const Icon(
        Icons.edit,
        color: ConstantsTheme.darkColor,
      ),
    );
  }

  Widget _buildScaffoldBody() {
    return Column(
      children: [
        const Text(ConstantTexts.additionalInfo),
        Text(
          widget.goal.getAdditionalInfo(),
        ),
        const Text(ConstantTexts.creationDate),
        Text(
          DateFormat(ConstantsTheme.dateFormat)
              .format(widget.goal.getCreationDate().toDate()),
        ),
        if (widget.goal.getChanged())
          Column(children: [
            const Text(ConstantTexts.changeDate),
            Text(
              DateFormat(ConstantsTheme.dateFormat)
                  .format(widget.goal.getChangingDate().toDate()),
            )
          ]),
        if (widget.goal.getAchieved())
          Column(children: [
            const Text(ConstantTexts.achieveDate),
            Text(
              DateFormat(ConstantsTheme.dateFormat)
                  .format(widget.goal.getAchieveDate().toDate()),
            )
          ]),
        Expanded(
            child: ListView.builder(
                itemCount: widget.goal.subgoals.length + 1,
                itemBuilder: (context, index) {
                  return _buildListSubgoals(index);
                }))
      ],
    );
  }

  ///Allow to build the subgoals list
  Widget _buildListSubgoals(int index) {
    if (index == 0) {
      return TextButton(
        onPressed: () {
          _addSubGoal(context);
        },
        child: const Text(ConstantTexts.add),
      );
    }
    index--;
    final item = widget.goal.subgoals[index];

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

  void _viewGoal(BuildContext context, GoalClass item) {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return GoalShowPage(item);
    })).then((value) => setState(() {}));
  }

  void _dismissItem(GoalClass goal) {
    widget.goal.subgoals.remove(goal);
    DataBaseHandler.deleteDataBase(goal);
  }

  ///Called when adding of a new subgoal has been ended
  _addSubGoal(BuildContext context) async {
    final result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return GoalCreatePage(parentId: widget.goal.getId());
    }));
    if (result != null) {
      setState(() {
        widget.goal.addSubGoal(result);
        DataBaseHandler.addDataBase(result);
      });
    }
  }

  ///Allow to edit a subgoal
  _editGoal(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return GoalChangePage(widget.goal);
    }));
    if (result != null) {
      setState(() {
        widget.goal = result;
        DataBaseHandler.updateDataBase(result);
      });
    }
  }
}
