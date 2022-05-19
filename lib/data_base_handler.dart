import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_goals_app/goal_class.dart';

class DataBaseHandler {
  static int _maxId = 0;

  static int getId() {
    return _maxId;
  }

  static GoalClass buildGoal(QueryDocumentSnapshot<Object?>? doc, int index) {
    return GoalClass.fromQuery(
      index,
      doc?.get('parent'),
      doc?.get('name'),
      doc?.get('additionalInfo'),
      doc?.get('creationDateTime'),
      doc?.get('changingDateTime'),
      doc?.get('achieveDateTime'),
      doc?.get('achieved'),
      doc?.get('changed'),
    );
  }

  static List<GoalClass> getDataFromBase() {
    List<GoalClass> goals = [];
    var result = FirebaseFirestore.instance.collection('goals').snapshots();

    result.forEach((snapshot) {
      goals.clear();
      for (var doc in snapshot.docs) {
        goals.add(buildGoal(doc, int.parse(doc.id)));
      }
    });

    return goals;
  }

  static List<GoalClass> rebuildGoals(List<GoalClass> goals){
    var toRemove = [];
    var newGoals;

    for (var isSubgoal in goals) {
      if (isSubgoal.getId() > _maxId) {
        _maxId = isSubgoal.getId();
      }
      if (isSubgoal.getParent() != 0) {
        GoalClass.findGoal(goals, isSubgoal.getParent())!.subgoals.add(isSubgoal);
        toRemove.add(isSubgoal);
      }
    }

    goals.removeWhere((element) => toRemove.contains(element));
    newGoals = goals;
    return newGoals;
  }

  static void addDataBase(GoalClass goal) {
    _maxId++;

    FirebaseFirestore.instance
        .collection('goals')
        .doc(goal.getId().toString())
        .set({
      'parent': goal.getParent(),
      'name': goal.getName(),
      'additionalInfo': goal.getAdditionalInfo(),
      'creationDateTime': goal.getCreationDate(),
      'changingDateTime': goal.getChangingDate(),
      'achieveDateTime': goal.getAchieveDate(),
      'achieved': goal.getAchieved(),
      'changed': goal.getChanged()
    });
  }

  static void updateDataBase(GoalClass goal) {
    FirebaseFirestore.instance
        .collection('goals')
        .doc(goal.getId().toString())
        .update({
      'name': goal.getName(),
      'additionalInfo': goal.getAdditionalInfo(),
      'changingDateTime': goal.getChangingDate(),
      'achieveDateTime': goal.getAchieveDate(),
      'achieved': goal.getAchieved(),
      'changed': goal.getChanged()
    });
  }

  static void deleteDataBase(GoalClass goal) {
    for (var sg in goal.subgoals) {
      deleteDataBase(sg);
    }

    FirebaseFirestore.instance
        .collection('goals')
        .doc(goal.getId().toString())
        .delete();
  }
}
