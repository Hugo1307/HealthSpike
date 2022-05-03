
import 'package:health_spike/location/bloc/location_events.dart';
import 'package:health_spike/main.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class AppLocationSensor {

  Location location = Location();

  LocationData? _currentLocationData;
  double _distance = 0;
  
  double rad(degrees) {
    return (degrees * pi) / 180;
  }

  Future<double> calcDistance(LocationData oldLocationData, LocationData newLocationData) async {

    double oldLocationLatitute = oldLocationData.latitude!.toDouble();
    double oldLocationLongitude = oldLocationData.longitude!.toDouble();
      
    double newLocationLatitude = newLocationData.latitude!.toDouble();
    double newLocationLongitude = newLocationData.longitude!.toDouble();

    const Distance distance = Distance();

    return distance.as(LengthUnit.Kilometer, LatLng(oldLocationLatitute,oldLocationLongitude), LatLng(newLocationLatitude,newLocationLongitude));

  }

  void onDistanceChanged(final LocationData newLocationData) async {
    
    if (_currentLocationData != null) {
      _distance = await calcDistance(_currentLocationData!, newLocationData);
    }

    _currentLocationData = newLocationData;

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
      
      onDistanceChanged(currentSensorLocation);

      double latitude = currentSensorLocation.latitude != null ? currentSensorLocation.latitude! : 0;
      double longitude = currentSensorLocation.longitude != null ? currentSensorLocation.longitude! : 0;

      eventBus.fire(LocationUpdatedEvent(timestamp: DateTime.now(), latitude: latitude, longitude: longitude));
      eventBus.fire(DistanceUpdatedEvent(timestamp: DateTime.now(), distance: _distance));

    });

  }

}
