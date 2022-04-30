import 'dart:async';

import 'package:health_spike/main.dart';
import 'package:health_spike/objectbox.g.dart';
import 'package:health_spike/steps/model/steps_model.dart';

class StepsRepository {
  final Box<Steps> stepsBox = objectBoxInstance.store.box<Steps>();

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

    final QueryBuilder<Steps> queryBuilder = stepsBox.query(Steps_.timestamp.between(0, date.subtract(const Duration(days: 1)).millisecondsSinceEpoch));
    final Query<Steps> query = queryBuilder.build();
    final PropertyQuery<int> pq = query.property(Steps_.count);
    
    int oldSteps = pq.sum();
    await getMostRecentMeasurement().then((currentSteps) {
      completer.complete(currentSteps.count - oldSteps);
    });
    return completer.future;

  }

}
