import 'dart:async';
import 'dart:collection';

import 'package:health_spike/heart_rate/model/heart_rate_model.dart';
import 'package:health_spike/main.dart';
import 'package:health_spike/objectbox.g.dart';

class HeartRateRepository {

  final Box<HeartRate> heartRateBox = objectBoxInstance.store.box<HeartRate>();

  Future<int> save(HeartRate heartRate) {
    return heartRateBox.putAsync(heartRate);
  }

  Future<HeartRate> getMostRecent() {

    var completer = Completer<HeartRate>();

    List<HeartRate> allHeartRates = heartRateBox.getAll();

    allHeartRates.sort((a,b) => a.timestamp.compareTo(b.timestamp));

    if (allHeartRates.isNotEmpty) {
      completer.complete(allHeartRates.last);
    } else {
      completer.complete(HeartRate(timestamp: DateTime.fromMicrosecondsSinceEpoch(0), heartRateValue: 0));
    }

    return completer.future;

  }

  Future<List<HeartRate>> getAllMeasurements() {

    var completer = Completer<List<HeartRate>>();

    List<HeartRate> allHeartRates = heartRateBox.getAll();

    allHeartRates.removeWhere((element) => element.heartRateValue == 0);

    completer.complete(allHeartRates);
    return completer.future;

  }

  Future<SplayTreeMap<DateTime, double>> getDailyAverages() async {

    List<HeartRate> allHeartRates = await getAllMeasurements();
    SplayTreeMap<DateTime, double> totalMeasurementsValue = SplayTreeMap<DateTime, double>();
    SplayTreeMap<DateTime, int> totalMeasurementsCount = SplayTreeMap<DateTime, int>();
    SplayTreeMap<DateTime, double> averageMeasurements = SplayTreeMap<DateTime, double>();

    for (HeartRate heartRate in allHeartRates) {
      
      DateTime newDateTime = DateTime(heartRate.timestamp.year, heartRate.timestamp.month, heartRate.timestamp.day, heartRate.timestamp.hour, heartRate.timestamp.minute);

      if (totalMeasurementsValue.containsKey(newDateTime)) {
        totalMeasurementsValue[newDateTime] = (totalMeasurementsValue[newDateTime]! + heartRate.heartRateValue);
      } else {
        totalMeasurementsValue[newDateTime] = heartRate.heartRateValue;
      } 

      if (totalMeasurementsCount.containsKey(newDateTime)) {
        totalMeasurementsCount[newDateTime] = (totalMeasurementsCount[newDateTime]! + 1);
      } else {
        totalMeasurementsCount[newDateTime] = 1;
      } 

    }

    for (DateTime measurementKey in totalMeasurementsValue.keys) {
      
      if (totalMeasurementsCount.containsKey(measurementKey)) {
        averageMeasurements[measurementKey] = (totalMeasurementsValue[measurementKey]! / totalMeasurementsCount[measurementKey]!);
      }

    }

    return averageMeasurements;

  }

  Future<double> getMaxHeartRate() {
    
    var completer = Completer<double>();

    final QueryBuilder<HeartRate> query = heartRateBox.query(HeartRate_.heartRateValue.greaterThan(0));
    final Query<HeartRate> queries = query.build();

    PropertyQuery<double> pq = queries.property(HeartRate_.heartRateValue);
    completer.complete(pq.max());

    return completer.future;

  }

  Future<double> getMinHeartRate() {
    
    var completer = Completer<double>();

    final QueryBuilder<HeartRate> query = heartRateBox.query(HeartRate_.heartRateValue.greaterThan(0));
    final Query<HeartRate> queries = query.build();

    PropertyQuery<double> pq = queries.property(HeartRate_.heartRateValue);
    completer.complete(pq.min());

    return completer.future;

  }

  Future<double> getAverageHeartRate() {
    
    var completer = Completer<double>();

    final QueryBuilder<HeartRate> query = heartRateBox.query(HeartRate_.heartRateValue.greaterThan(0));

    final Query<HeartRate> queries = query.build();

    PropertyQuery<double> pq = queries.property(HeartRate_.heartRateValue);
    completer.complete(pq.average());

    return completer.future;

  }

}
