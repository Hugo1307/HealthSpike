import 'package:location/location.dart';

class DistanceUpdatedEvent {
  DateTime timestamp;
  double distance;

  DistanceUpdatedEvent({required this.timestamp, required this.distance});
}

class LocationStatusUpdatedEvent {
  DateTime timestamp;
  String locationStatus;

  LocationStatusUpdatedEvent(this.locationStatus, this.timestamp);
}

class LocationChangedEvent {
  final LocationData location;

  LocationChangedEvent(this.location);
}
