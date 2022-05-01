import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_spike/location/bloc/location_events.dart';
import 'package:health_spike/location/bloc/location_states.dart';
import 'package:health_spike/location/model/location_model.dart';
import 'package:health_spike/location/repository/location_repository.dart';
import 'package:health_spike/objectbox.g.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  
  final LocationRepository locationRepository;
  
  LocationBloc({required this.locationRepository}) : super(const LocationState()) {
    on<LocationUpdatedEvent>(_mapLocationUpdatedEventToState);
    on<GetLastLocationEvent>(_mapGetLastLocationEventToState);
    on<GetTotalDistanceEvent>(_mapGetTotalDistanceEventToState);
    on<GetDailyDistanceEvent>(_mapGetDailyDistanceEventToState);
  }

  void _mapLocationUpdatedEventToState(LocationUpdatedEvent event, Emitter<LocationState> emitter) async {
    emitter(LocationState(status: LocationStatus(event, LocationStateStatus.saving, false)));
    await locationRepository.saveLocation(LocationModel(timestamp: event.timestamp, latitude: event.latitude, longitude: event.longitude)).then((value) {
      emitter(LocationState(status: LocationStatus(event, LocationStateStatus.saved, true)));
    });
  }

  // TODO:_Add distanceUpdatedEvent to update distance in database.

  void _mapGetLastLocationEventToState(GetLastLocationEvent event, Emitter<LocationState> emitter) {

  }

  void _mapGetTotalDistanceEventToState(GetTotalDistanceEvent event, Emitter<LocationState> emitter) {

  }

  void _mapGetDailyDistanceEventToState(GetDailyDistanceEvent event, Emitter<LocationState> emitter) {

  }

}