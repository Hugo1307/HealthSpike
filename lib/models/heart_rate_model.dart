import 'package:flutter/material.dart';

class HeartRateModel extends ChangeNotifier {
  double _currentHeartRate = 0;
  DateTime? _lastTimestamp;

  void setCurrentHeartRate(double heartRate, DateTime timestamp) {
    _currentHeartRate = heartRate;
    _lastTimestamp = timestamp;
    notifyListeners();
  }

  double get currentHeartRate {
    return _currentHeartRate;
  }

  DateTime? get lastTimestamp {
    return _lastTimestamp;
  }
}
