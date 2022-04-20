import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/events/location_events.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/main.dart';
import 'package:location/location.dart';

class AppLocationSensor {
  Location location = Location();

  double? _distanceDouble;

  LocationData? _currentLocation;
  String _distance = '?', _status = '?';

  void onDistanceChanged(Location loc) {
    LocationData locationaData = loc.getLocation() as LocationData;

    if (_currentLocation != null) {
      double? latitude1 =
          (_currentLocation.latitude?.toDouble())! / 57.29577951;
      double? longitude1 =
          (_currentLocation.longitude?.toDouble())! / 57.29577951;

      double? latitude2 = (locationaData.latitude?.toDouble())! / 57.29577951;
      double? longitude2 = (locationaData.longitude?.toDouble())! / 57.29577951;

      _distanceDouble = 3963.0 *
          acos((sin(latitude1) * sin(latitude2)) +
              cos(latitude1) * cos(latitude2) * cos(longitude2 - longitude1));
    } else {
      _distanceDouble = _distanceDouble! + 0;
    }

    if (_distanceDouble != null) {
      eventBus.fire(DistanceUpdatedEvent(_distanceDouble, DateTime.now()));
    } else {
      onDistanceCountError();
    }
  }

  void onDistanceCountError() {
    print('onDistanceCountError');
  }

  Future<void> initPlatformState() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentSensorLocation) {
      print('Location Changed');
      _currentLocation = currentSensorLocation;
      eventBus.fire(LocationChangedEvent(_currentLocation!));
    });

    // _distance = _currentLocation!.latitude.toString();
  }
}
