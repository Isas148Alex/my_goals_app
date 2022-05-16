///GoalClass is used for definition of data model in fact.
///For the begin it is just tree node with information related the goal
///and an elements of the same type, and also some additional information about
///creation and changes.

class GoalClass {
  List<GoalClass> subgoals = [];
  late String additionalInfo;
  late String name;
  late DateTime creationDateTime;
  late DateTime changingDateTime = DateTime(0);
  late DateTime achieveDateTime = DateTime(0);
  bool achieved = false;
  bool changed = false;

  ///Update an existing goal with full information about it.
  void updateGoal(String name, String additionalInfo, bool achieved,
      List<GoalClass> achievedSubgoals, List<GoalClass> deletedSubgoals) {
    if (this.achieved != achieved ||
        this.name != name ||
        this.additionalInfo != additionalInfo ||
        achievedSubgoals.isNotEmpty ||
        deletedSubgoals.isNotEmpty) {
      changed = true;
      changingDateTime = DateTime.now();
    }
    if (achieved) {
      achieveDateTime = DateTime.now();
    }
    this.achieved = achieved;
    this.additionalInfo = additionalInfo;
    this.name = name;

    subgoals.removeWhere((element) => deletedSubgoals.contains(element));

    for (var element in subgoals) {
      if (achievedSubgoals.contains(element)) {
        element.achieveGoal(true);
      }
    }
  }

  ///Add a new subgoal and also change status "changed" on true.
  void addSubGoal(GoalClass subgoal) {
    subgoals.add(subgoal);
    changed = true;
    changingDateTime = DateTime.now();
  }

  ///Changes achieved state for goal.
  void achieveGoal(bool achieved) {
    if (achieved) {
      achieveDateTime = DateTime.now();
      this.achieved = achieved;
    } else {
      achieveDateTime = DateTime(0);
    }
    changingDateTime = DateTime.now();
  }

  ///Constructor takes a name and additional info, 'cause only this values known
  ///at the moment of creation
  GoalClass(this.additionalInfo, this.name) {
    creationDateTime = DateTime.now();
  }
}
