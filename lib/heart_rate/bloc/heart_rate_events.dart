import 'package:equatable/equatable.dart';

class HeartRateEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRecentHeartRate extends HeartRateEvent {}

class GetAllHeartRateMeasurements extends HeartRateEvent {}

class GetMaxHeartRateMeasure extends HeartRateEvent {}

class GetMinHeartRateMeasure extends HeartRateEvent {}

class GetAverageRateMeasure extends HeartRateEvent {}

class ReceivedHeartRateMeasurement extends HeartRateEvent {

  final double heartRateValue;

  ReceivedHeartRateMeasurement({required this.heartRateValue});

  @override
  List<Object?> get props => [heartRateValue];

}
