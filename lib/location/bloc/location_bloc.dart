import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_spike/location/bloc/location_events.dart';
import 'package:health_spike/location/bloc/location_states.dart';
import 'package:health_spike/location/model/distance_model.dart';
import 'package:health_spike/location/model/location_model.dart';
import 'package:health_spike/location/repository/location_repository.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  
  final LocationRepository locationRepository;
  
  LocationBloc({required this.locationRepository}) : super(const LocationState()) {
    on<LocationUpdatedEvent>(_mapLocationUpdatedEventToState);
    on<DistanceUpdatedEvent>(_mapDistanceUpdatedEventToState);
    on<GetLastLocationEvent>(_mapGetLastLocationEventToState);
    on<GetTotalDistanceEvent>(_mapGetTotalDistanceEventToState);
    on<GetDailyDistanceEvent>(_mapGetDailyDistanceEventToState);
    on<GetWeeklyDistanceEvent>(_mapGetWeeklyDistanceEventToState);
  }

  void _mapLocationUpdatedEventToState(LocationUpdatedEvent event, Emitter<LocationState> emitter) async {
    emitter(LocationState(status: LocationStatus(event, LocationStateStatus.saving, false)));
    await locationRepository.saveLocation(LocationModel(timestamp: event.timestamp, latitude: event.latitude, longitude: event.longitude)).then((value) {
      emitter(LocationState(status: LocationStatus(event, LocationStateStatus.saved, true)));
    });
  }

  void _mapDistanceUpdatedEventToState(DistanceUpdatedEvent event, Emitter<LocationState> emitter) async {
    emitter(LocationState(status: LocationStatus(event, LocationStateStatus.saving, false)));
    await locationRepository.saveDistance(DistanceModel(timestamp: event.timestamp, distance: event.distance)).then((value) => 
      emitter(LocationState(status: LocationStatus(event, LocationStateStatus.saved, false)))
    );
  }

  void _mapGetLastLocationEventToState(GetLastLocationEvent event, Emitter<LocationState> emitter) async {
    emitter(LocationState(status: LocationStatus(event, LocationStateStatus.loading, LocationModel(timestamp: DateTime.fromMillisecondsSinceEpoch(0), latitude: 0, longitude: 0))));
    await locationRepository.getRecentLocation().then((value) => 
      emitter(LocationState(status: LocationStatus(event, LocationStateStatus.loaded, value)))
    );
  }

  void _mapGetTotalDistanceEventToState(GetTotalDistanceEvent event, Emitter<LocationState> emitter) async {
    emitter(LocationState(status: LocationStatus(event, LocationStateStatus.loading, 0)));
    await locationRepository.getTotalDistance().then((value) =>
      emitter(LocationState(status: LocationStatus(event, LocationStateStatus.loaded, value)))
    );
  }

  void _mapGetDailyDistanceEventToState(GetDailyDistanceEvent event, Emitter<LocationState> emitter) async {
    emitter(LocationState(status: LocationStatus(event, LocationStateStatus.loading, 0)));
    await locationRepository.getDailyDistance(event.date).then((value) => 
      emitter(LocationState(status: LocationStatus(event, LocationStateStatus.loaded, value)))
    );
  }

  void _mapGetWeeklyDistanceEventToState(GetWeeklyDistanceEvent event, Emitter<LocationState> emitter) async {
    emitter(LocationState(status: LocationStatus(event, LocationStateStatus.loading, 0)));
    await locationRepository.getWeeklyDistance(event.date).then((value) => 
      emitter(LocationState(status: LocationStatus(event, LocationStateStatus.loaded, value)))
    );
  }

}