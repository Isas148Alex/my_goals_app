import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_goals_app/data_base_handler.dart';

///GoalClass is used for definition of data model in fact.
///For the begin it is just tree node with information related the goal
///and an elements of the same type, and also some additional information about
///creation and changes.

class GoalClass {
  late int _id;
  int getId() { return _id; }

  late int _parent;
  int getParent() { return _parent; }

  late String _name;
  String getName() { return _name; }

  late String _additionalInfo;
  String getAdditionalInfo() { return _additionalInfo; }

  Timestamp _creationDateTime = Timestamp.now();
  Timestamp getCreationDate() { return _creationDateTime; }

  Timestamp _changingDateTime = Timestamp(0, 0);
  Timestamp getChangingDate() { return _changingDateTime; }

  Timestamp _achieveDateTime = Timestamp(0, 0);
  Timestamp getAchieveDate() { return _achieveDateTime; }

  bool _achieved = false;
  bool getAchieved() { return _achieved; }

  bool _changed = false;
  bool getChanged() { return _changed; }

  List<GoalClass> subgoals = [];

  ///Update an existing goal with full information about it.
  void updateGoal(String name, String additionalInfo, bool achieved,
      List<GoalClass> achievedSubgoals, List<GoalClass> deletedSubgoals) {
    if (_achieved != achieved ||
        _name != name ||
        _additionalInfo != additionalInfo ||
        achievedSubgoals.isNotEmpty ||
        deletedSubgoals.isNotEmpty) {
      _changed = true;
      _changingDateTime = Timestamp.now();
    }
    if (achieved) {
      _achieveDateTime = Timestamp.now();
    }
    _achieved = achieved;
    _additionalInfo = additionalInfo;
    _name = name;

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
    _changed = true;
    _changingDateTime = Timestamp.now();
  }

  ///Changes achieved state for goal.
  void achieveGoal(bool achieved) {
    if (achieved) {
      _achieveDateTime = Timestamp.now();
    } else {
      _achieveDateTime = Timestamp(0, 0);
    }
    _achieved = achieved;
    _changingDateTime = Timestamp.now();
  }

  ///Constructor takes a name and additional info, 'cause only this values known
  ///at the moment of creation
  GoalClass(this._additionalInfo, this._name, {int? parent}) {
    _id = DataBaseHandler.getId();
    _creationDateTime = Timestamp.now();
    _parent = parent ?? 0;
  }

  GoalClass.fromQuery(
      this._id,
      this._parent,
      this._name,
      this._additionalInfo,
      this._creationDateTime,
      this._changingDateTime,
      this._achieveDateTime,
      this._achieved,
      this._changed,
      );

  static GoalClass? findGoal(List<GoalClass> goals, int id){
    for (var goal in goals) {
      if(goal._id == id) {
        return goal;
      }

      GoalClass? goalCandidate = findGoal(goal.subgoals, id);
      if(goalCandidate != null) {
        return goalCandidate;
      }
    }
    return null;
  }
}
