import 'package:equatable/equatable.dart';
import 'package:health_spike/location/bloc/location_events.dart';

class LocationState extends Equatable {
  
  final LocationStatus? status;

  const LocationState({this.status});

  @override
  List<Object?> get props => [status];
  
}

class LocationStatus {

  final LocationEvent event;
  final LocationStateStatus status;
  final Object value;

  LocationStatus(this.event, this.status, this.value);

}

enum LocationStateStatus {
  loading,
  loaded,
  saving, 
  saved
}