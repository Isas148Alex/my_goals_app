///GoalClass is used for definition of data model in fact.
///For the begin it is just tree node with information related the goal
///and an elements of the same type.

class GoalClass{
  late List<GoalClass> SubGoals;
  late String Description;
  late DateTime CreationDateTime;
  late DateTime? ChangingDateTime;
  late DateTime? AchieveDateTime;

  ///Update an existing goal with full information about it
  ///No need pass value of DateTime, 'cause it will be calculated automatically
  void UpdateGoal(String Description, bool Achieved, List<GoalClass> AchievedSubGoals, List<GoalClass> DeletedSubGoals){
    if(Achieved)
      AchieveDateTime = DateTime.now();
    ChangingDateTime = DateTime.now();
    this.Description = Description;

    SubGoals.removeWhere((element) => DeletedSubGoals.contains(element));

    SubGoals.forEach((element) {
      if (AchievedSubGoals.contains(element))
        element.AchieveGoal(true);
    });
  }

  ///Changes achieved state for goal
  ///No need pass value of DateTime, 'cause it will be calculated automatically
  void AchieveGoal(bool Achieved){
    if(Achieved)
      AchieveDateTime = DateTime.now();
    else
      AchieveDateTime = null;
    ChangingDateTime = DateTime.now();
  }

  ///Constructor consume only description value, 'cause no additional information
  ///exist in moment of creation
  GoalClass(String Descrition){
    this.Description = Descrition;
    CreationDateTime = DateTime.now();
  }
}