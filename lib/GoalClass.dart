///GoalClass is used for definition of data model in fact.
///For the begin it is just tree node with information related the goal
///and an elements of the same type.

class GoalClass{
  List<GoalClass> SubGoals = [];
  late String Description;
  late String Name;
  late DateTime CreationDateTime;
  late DateTime ChangingDateTime = DateTime(0);
  late DateTime AchieveDateTime = DateTime(0);
  bool Achieved = false;
  bool Changed = false;

  ///Update an existing goal with full information about it
  ///No need pass value of DateTime, 'cause it will be calculated automatically
  void UpdateGoal(String Name, String Description, bool Achieved, List<GoalClass> AchievedSubGoals, List<GoalClass> DeletedSubGoals){
    if(Achieved){
      AchieveDateTime = DateTime.now();
    }
    this.Achieved = Achieved;
    ChangingDateTime = DateTime.now();
    this.Description = Description;
    this.Name = Name;

    SubGoals.removeWhere((element) => DeletedSubGoals.contains(element));

    SubGoals.forEach((element) {
      if (AchievedSubGoals.contains(element))
        element.AchieveGoal(true);
    });
  }

  ///Changes achieved state for goal
  ///No need pass value of DateTime, 'cause it will be calculated automatically
  void AchieveGoal(bool Achieved){
    if(Achieved){
      AchieveDateTime = DateTime.now();
      this.Achieved = Achieved;
    }
    else
      AchieveDateTime = DateTime(0);
    ChangingDateTime = DateTime.now();
  }

  ///Constructor consume only description value, 'cause no additional information
  ///exist in moment of creation
  GoalClass(this.Description, this.Name){
    CreationDateTime = DateTime.now();
  }
}