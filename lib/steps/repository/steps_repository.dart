import 'dart:async';

import 'package:health_spike/main.dart';
import 'package:health_spike/objectbox.g.dart';
import 'package:health_spike/steps/model/steps_goal_model.dart';
import 'package:health_spike/steps/model/steps_model.dart';

class StepsRepository {
  final Box<Steps> stepsBox = objectBoxInstance.store.box<Steps>();
  final Box<StepsGoal> stepsGoalBox = objectBoxInstance.store.box<StepsGoal>();
  
  int stepsGoalId = 0;

  Future<int> save(Steps steps) {
    return stepsBox.putAsync(steps);
  }

  Future<Steps> getAllSteps() {
    var completer = Completer<Steps>();

    List<Steps> allSteps = stepsBox.getAll();

    allSteps.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (allSteps.isNotEmpty) {
      completer.complete(allSteps.last);
    } else {
      completer.complete(
          Steps(timestamp: DateTime.fromMillisecondsSinceEpoch(0), count: 0));
    }

    return completer.future;
  }

  Future<Steps> getMostRecentMeasurement() {

    var completer = Completer<Steps>();

    List<Steps> allSteps = stepsBox.getAll();

    allSteps.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    if (allSteps.isNotEmpty) {
      completer.complete(allSteps.last);
    } else {
      completer.complete(Steps(timestamp: DateTime.fromMillisecondsSinceEpoch(0), count: 0));
    }

    return completer.future;

  }

  Future<int> getStepsForDay(DateTime date) async {

    var completer = Completer<int>();

    final QueryBuilder<Steps> todayStepsQueryBuilder = stepsBox.query(Steps_.timestamp.between(date.subtract(const Duration(days: 1)).millisecondsSinceEpoch, date.millisecondsSinceEpoch))..order(Steps_.timestamp, flags: Order.descending);
    final Query<Steps> todayStepsQuery = todayStepsQueryBuilder.build();

    final QueryBuilder<Steps> oldStepsQueryBuilder = stepsBox.query(Steps_.timestamp.between(0, date.subtract(const Duration(days: 1, hours: 1)).millisecondsSinceEpoch))..order(Steps_.timestamp, flags: Order.descending);
    final Query<Steps> oldStepsQuery = oldStepsQueryBuilder.build();

    Steps? highestOldRecord = oldStepsQuery.findFirst();
    Steps? todayHighestRecord = todayStepsQuery.findFirst();

    if (todayHighestRecord != null) {
      if (highestOldRecord != null && todayHighestRecord.count >= highestOldRecord.count) {
        completer.complete(todayHighestRecord.count - highestOldRecord.count);
      } else {
        completer.complete(todayHighestRecord.count);
      }
    } else {
      completer.complete(0);
    }

    return completer.future;

  }

  Future<int> getStepsForLastWeek(DateTime date) async {

    var completer = Completer<int>();

    final QueryBuilder<Steps> weekStepsQueryBuilder = stepsBox.query(Steps_.timestamp.between(date.subtract(const Duration(days: 7)).millisecondsSinceEpoch, date.millisecondsSinceEpoch))..order(Steps_.timestamp, flags: Order.descending);
    final Query<Steps> weekStepsQuery = weekStepsQueryBuilder.build();

    final QueryBuilder<Steps> oldStepsQueryBuilder = stepsBox.query(Steps_.timestamp.between(0, date.subtract(const Duration(days: 7, hours: 1)).millisecondsSinceEpoch))..order(Steps_.timestamp, flags: Order.descending);
    final Query<Steps> oldStepsQuery = oldStepsQueryBuilder.build();

    Steps? highestOldRecord = oldStepsQuery.findFirst();
    Steps? weekHighestRecord = weekStepsQuery.findFirst();

    if (weekHighestRecord != null) {
      if (highestOldRecord != null && weekHighestRecord.count >= highestOldRecord.count) {
        completer.complete(weekHighestRecord.count - highestOldRecord.count);
      } else {
        completer.complete(weekHighestRecord.count);
      }
    } else {
      completer.complete(0);
    }

    return completer.future;

  }

  Future<int> getStepsGoal() async {
    
    if (stepsGoalBox.getAll().isNotEmpty) {
      return stepsGoalBox.getAll().first.stepsGoal;
    } else {
      return 500;
    }

  }

  Future<void> setStepsGoal(int newGoal) async {
    
    if (stepsGoalBox.getAll().isNotEmpty) {
      stepsGoalBox.put(StepsGoal(id: stepsGoalBox.getAll().first.id, stepsGoal: newGoal));
    } else {
      stepsGoalBox.put(StepsGoal(stepsGoal: newGoal));
    }

  }

}
