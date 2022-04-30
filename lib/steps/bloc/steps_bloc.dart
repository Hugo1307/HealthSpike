import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_spike/steps/bloc/steps_events.dart';
import 'package:health_spike/steps/bloc/steps_states.dart';
import 'package:health_spike/steps/model/steps_model.dart';
import 'package:health_spike/steps/repository/steps_repository.dart';

class StepsBloc extends Bloc<StepsEvent, StepsState> {
  
  final StepsRepository stepsRepository;
  
  StepsBloc({required this.stepsRepository}) : super(const StepsState()) {
    on<GetRecentStepsCountEvent>(_mapGetRecentStepsCountToState);
    on<GetLastWalkTimestampEvent>(_mapGetLastWalkTimestampEvent);
    on<UpdatedStepsEvent>(_mapUpdatedStepsToState);
    on<GetDailyStepsEvent>(_mapGetDailyStepsToState);
    on<GetWeeklyStepsEvent>(_mapGetWeeklyStepsToState);
  }

  void _mapGetRecentStepsCountToState(GetRecentStepsCountEvent event, Emitter<StepsState> emit) async {

    emit(StepsState(status: StepsStatus(event, Status.loading, 0)));
    await stepsRepository.getAllSteps().then((value) {
      emit(StepsState(status: StepsStatus(event, Status.loaded, value.count)));
    });

  }

  void _mapGetLastWalkTimestampEvent(GetLastWalkTimestampEvent event, Emitter<StepsState> emit) async {

    emit(StepsState(status: StepsStatus(event, Status.loading, 0)));
    await stepsRepository.getAllSteps().then((value) {
      emit(StepsState(status: StepsStatus(event, Status.loaded, value.timestamp)));
    });

  }
  
  void _mapUpdatedStepsToState(UpdatedStepsEvent event, Emitter<StepsState> emit) async {

    emit(StepsState(status: StepsStatus(event, Status.saving, false)));
    await stepsRepository.save(Steps(timestamp: event.timestamp, count: event.stepsValue)).then((value) {
      emit(StepsState(status: StepsStatus(event, Status.saved, true)));
    });

  }

  void _mapGetDailyStepsToState(GetDailyStepsEvent event, Emitter<StepsState> emit) async {
    
    emit(StepsState(status: StepsStatus(event, Status.loading, 0)));
    await stepsRepository.getStepsForDay(event.date).then((value) {
      emit(StepsState(status: StepsStatus(event, Status.loaded, value)));
    });

  }

  void _mapGetWeeklyStepsToState(GetWeeklyStepsEvent event, Emitter<StepsState> emit) async {
    
    emit(StepsState(status: StepsStatus(event, Status.loading, 0)));
    await stepsRepository.getStepsForLastWeek(event.date).then((value) {
      emit(StepsState(status: StepsStatus(event, Status.loaded, value)));
    });

  }

}