import 'package:equatable/equatable.dart';

class LocationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LocationUpdatedEvent extends LocationEvent {

  final DateTime timestamp;
  final double latitude;
  final double longitude;

  LocationUpdatedEvent({required this.timestamp, required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [timestamp, latitude, longitude];

}

class DistanceUpdatedEvent extends LocationEvent {

  final DateTime timestamp;
  final double distance;

  DistanceUpdatedEvent({required this.timestamp, required this.distance});

  @override
  List<Object?> get props => [timestamp, distance];
  
}

class GetLastLocationEvent extends LocationEvent { }

class GetTotalDistanceEvent extends LocationEvent { }

class GetDailyDistanceEvent extends LocationEvent {

  final DateTime date;

  GetDailyDistanceEvent({required this.date});

  @override
  List<Object?> get props => [date];

}

class GetWeeklyDistanceEvent extends LocationEvent {

  final DateTime date;

  GetWeeklyDistanceEvent({required this.date});

  @override
  List<Object?> get props => [date];

}