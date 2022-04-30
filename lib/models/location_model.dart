import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationModel extends ChangeNotifier {
  
  double _distance = 0;
  LocationData? _currentLocation;

  void setDistance(double distance) {
    _distance = distance;

    notifyListeners();
  }

  void setCurrentLocation(LocationData currentLocation) {
    _currentLocation = currentLocation;
    notifyListeners();
  }

  // Getters for private fields

  double get distance {
    return _distance;
  }

  LocationData? get currentLocation {
    return _currentLocation;
  }
}
