import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LocationProviderModel extends ChangeNotifier {
  
  double _distance = 0;
  double _currentLatitude = 0;
  double _currentLongitude = 0;

  void setDistance(double distance) {
    _distance = distance;

    notifyListeners();
  }

  void setCurrentLocation(double latitude, double longitude) {
    _currentLatitude = latitude;
    _currentLongitude = longitude;
    notifyListeners();
  }

  // Getters for private fields

  double get distance {
    return _distance;
  }

  double get currentLatitude {
    return _currentLatitude;
  }

  double get currentLongitude {
    return _currentLongitude;
  }

}
