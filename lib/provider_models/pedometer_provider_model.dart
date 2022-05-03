import 'package:flutter/cupertino.dart';

class PedometerProviderModel extends ChangeNotifier {

  int _dailyGoal = 200;
  int _stepCount = 0;
  String _pedestrianState = "";
  double _goalPercentage = 0;

  void setDailyStepsGoal(int newStepsGoal) {
    _dailyGoal = newStepsGoal;
    _updateGoalPercentage();

    notifyListeners();
  }

  void setStepsCount(int newStepsCount) {
    _stepCount = newStepsCount;
    _updateGoalPercentage();

    notifyListeners();
  }

  void setPedestrianState(String pedestrianState) {
    _pedestrianState = pedestrianState;

    notifyListeners();
  }
  
  void _updateGoalPercentage() {
    _goalPercentage = _stepCount / _dailyGoal * 100;
  }

  // Getters for private fields

  int get stepCount {
    return _stepCount;
  }

  int get dailyGoal {
    return _dailyGoal;
  }

  double get goalPercentage {
    return _goalPercentage;
  }

  bool isPedestrianWalking() {
    return _pedestrianState == "walking";
  }

}
