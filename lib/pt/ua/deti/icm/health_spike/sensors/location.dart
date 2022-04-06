import 'package:flutter/foundation.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/events/location_events.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/main.dart';
import 'package:location/location.dart';

class AppLocationSensor {
  Location location = Location();

  LocationData? _currentLocation;
  String _distance = '?', _status = '?';

  void onDistanceChanged(Location loc) {
    LocationData locationaData = loc.getLocation() as LocationData;
    double? _distanceDouble = locationaData.latitude?.toDouble();
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
