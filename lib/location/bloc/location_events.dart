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

}

class GetLastLocationEvent extends LocationEvent { }

class GetTotalDistanceEvent extends LocationEvent { }

class GetDailyDistanceEvent extends LocationEvent { }