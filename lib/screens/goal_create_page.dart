///Used for GoalCreatePage with related functional.
///Allow to create a new goal, with name and additional information.

import 'package:flutter/material.dart';
import '../constants/theme_constants.dart';
import '../model/goal_class.dart';
import '../constants/constant_texts.dart';

class GoalCreatePage extends StatefulWidget {
  int? parentId;

  GoalCreatePage({Key? key, int? parentId}) : super(key: key) {
    this.parentId = parentId ?? 0;
  }

  @override
  State<GoalCreatePage> createState() => _GoalCreatePageState();
}

class _GoalCreatePageState extends State<GoalCreatePage> {
  final name = TextEditingController();
  final additionalInfo = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    additionalInfo.dispose();
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: _buildScaffoldAppBar(),
          floatingActionButton: _buildScaffoldFloatingActionButton(),
          body: _buildScaffoldBody(),
        ));
  }

  AppBar _buildScaffoldAppBar() {
    return AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: ConstantsTheme.darkColor,
        ),
        backgroundColor: ConstantsTheme.mainColor,
        title: const Text(
          ConstantTexts.createGoal,
          style: TextStyle(color: ConstantsTheme.darkColor),
        ));
  }

  Widget _buildScaffoldFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: ConstantsTheme.mainColor,
      child: const Icon(
        Icons.save,
        color: ConstantsTheme.darkColor,
      ),
      onPressed: () {
        if (name.text != "") {
          Navigator.of(context).pop(GoalClass(additionalInfo.text, name.text,
              parent: widget.parentId));
        }
      },
    );
  }

  Widget _buildScaffoldBody() {
    return Column(
      children: [
        const Text(ConstantTexts.name),
        TextField(
          controller: name,
        ),
        const Text(ConstantTexts.additionalInfo),
        TextField(
          controller: additionalInfo,
        ),
      ],
    );
  }

  ///Allow to use popup dialog for saving changes
  Future<bool> _onWillPop() async {
    if (additionalInfo.text != "" || name.text != "") {
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
