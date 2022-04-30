import 'package:equatable/equatable.dart';

class StepsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetRecentStepsCountEvent extends StepsEvent {}

class GetLastWalkTimestampEvent extends StepsEvent {}

class UpdatedStepsEvent extends StepsEvent {

  final DateTime timestamp;
  final int stepsValue;

  UpdatedStepsEvent({required this.stepsValue, required this.timestamp});

  @override
  List<Object?> get props => [stepsValue, timestamp];

}

class GetDailyStepsEvent extends StepsEvent {

  final DateTime date;

  GetDailyStepsEvent({required this.date});

  @override
  List<Object?> get props => [date];

}

class GetWeeklyStepsEvent extends StepsEvent {

  final DateTime date;

  GetWeeklyStepsEvent({required this.date});

  @override
  List<Object?> get props => [date];

}