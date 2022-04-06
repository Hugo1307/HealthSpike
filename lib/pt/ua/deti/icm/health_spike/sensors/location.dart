import 'package:flutter/foundation.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/events/location_events.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/main.dart';
import 'package:location/location.dart';

class AppLocationSensor {
  late Stream<LocationData> _locationDataStream;
  String _distance = '?', _status = '?';

  void onDistanceCount(Location loc) {
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
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

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

    _locationData = await location.getLocation();

    _distance = _locationData.latitude.toString();
  }
}
