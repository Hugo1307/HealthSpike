import 'package:equatable/equatable.dart';
import 'package:health_spike/steps/bloc/steps_events.dart';

class StepsState extends Equatable {

  final StepsStatus? status;

  const StepsState({this.status});

  @override
  List<Object?> get props => [status];

}

class StepsStatus {

  final StepsEvent event;
  final Status status;
  final Object value;

  StepsStatus(this.event, this.status, this.value);

}

enum Status {
  loading,
  loaded,
  saving, 
  saved
}