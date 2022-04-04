class DistanceUpdatedEvent {
  DateTime timestamp;
  double distance;

  DistanceUpdatedEvent(this.distance, this.timestamp);
}

class LocationStatusUpdatedEvent {
  DateTime timestamp;
  String locationStatus;

  LocationStatusUpdatedEvent(this.locationStatus, this.timestamp);
}
