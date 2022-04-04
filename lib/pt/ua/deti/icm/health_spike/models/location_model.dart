import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationModel extends ChangeNotifier {
  double _distance = 0;

  void setDistance(double distance) {
    _distance = distance;

    notifyListeners();
  }

  // Getters for private fields

  double get distance {
    return _distance;
  }
}
