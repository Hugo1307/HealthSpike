
import 'dart:math';

import 'package:health_spike/events/location_events.dart';
import 'package:health_spike/main.dart';
import 'package:location/location.dart';

class AppLocationSensor {

  Location location = Location();

  LocationData? _currentLocationData;
  double _totalDistance = 0;
  
  double rad(degrees) {
    return (degrees * pi) / 180;
  }

  Future<double> calcDistance(LocationData oldLocationData, LocationData newLocationData) async {

    double oldLocationLatituteRad = rad(oldLocationData.latitude!.toDouble());
    double oldLocationLongitudeRad = rad(oldLocationData.longitude!.toDouble());
      
    double newLocationLatitudeRad = rad(newLocationData.latitude!.toDouble());
    double newLocationLongitudeRad = rad(newLocationData.longitude!.toDouble());

    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((newLocationLatitudeRad - oldLocationLatituteRad) * p)/2 + 
          c(oldLocationLatituteRad * p) * c(newLocationLatitudeRad * p) * 
          (1 - c((newLocationLongitudeRad - oldLocationLongitudeRad) * p))/2;
    return 12742 * asin(sqrt(a));

  }

  void onDistanceChanging(final LocationData newLocationData) async {
    
    if (_currentLocationData != null) {
      _totalDistance = _totalDistance + await calcDistance(_currentLocationData!, newLocationData);
    }

    _currentLocationData = newLocationData;

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
      onDistanceChanging(currentSensorLocation);
      eventBus.fire(DistanceUpdatedEvent(timestamp: DateTime.now(), distance: _totalDistance));
    });

  }

}
