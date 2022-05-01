import 'dart:async';

import 'package:health_spike/location/model/distance_model.dart';
import 'package:health_spike/location/model/location_model.dart';
import 'package:health_spike/main.dart';
import 'package:health_spike/objectbox.g.dart';

class LocationRepository {

  final Box<LocationModel> locationBox = objectBoxInstance.store.box<LocationModel>();
  final Box<DistanceModel> distanceBox = objectBoxInstance.store.box<DistanceModel>();

  Future<int> saveLocation(LocationModel locationModel) {
    return locationBox.putAsync(locationModel);
  }

  Future<int> saveDistance(DistanceModel distanceModel) {
    return distanceBox.putAsync(distanceModel);
  } 

  
  Future<LocationModel> getRecentLocation() {
    
    Completer<LocationModel> completer = Completer<LocationModel>();

    final QueryBuilder<LocationModel> recentLocationQueryBuilder = locationBox.query()..order(LocationModel_.timestamp, flags: Order.descending);
    final Query<LocationModel> recentLocationQuery = recentLocationQueryBuilder.build();

    LocationModel? recentLocation = recentLocationQuery.findFirst();

    recentLocation != null ? completer.complete(recentLocation) : completer.complete(LocationModel(timestamp: DateTime.fromMillisecondsSinceEpoch(0), latitude: 0, longitude: 0));
    
    return completer.future;

  }
  
}