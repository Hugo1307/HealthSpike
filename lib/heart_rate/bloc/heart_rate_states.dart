import 'dart:collection';

import 'package:equatable/equatable.dart';

enum HeartRateStatus { initial, saved, saving, lastValueLoaded, loadingLastValue, allValuesLoaded, loadingAllValues, maxValueLoaded, minValueLoaded, avgValueLoaded }

class HeartRateState extends Equatable {
  
  final HeartRateStatus heartRateStatus;
  final DateTime? timestamp;
  final double heartRate;
  final SplayTreeMap<DateTime, double>? allHeartRates;

  const HeartRateState({this.heartRateStatus=HeartRateStatus.initial, this.timestamp, this.heartRate=-1, this.allHeartRates});

  @override
  List<Object?> get props => [heartRateStatus, timestamp, heartRate, allHeartRates];

}
