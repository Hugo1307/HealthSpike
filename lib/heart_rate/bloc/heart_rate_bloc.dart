import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_spike/heart_rate/model/heart_rate_model.dart';
import 'package:health_spike/heart_rate/repository/heart_rate_repository.dart';
import 'package:health_spike/heart_rate/bloc/heart_rate_events.dart';
import 'package:health_spike/heart_rate/bloc/heart_rate_states.dart';

class HeartRateBloc extends Bloc<HeartRateEvent, HeartRateState> {

  final HeartRateRepository heartRateRepository;

  HeartRateBloc({required this.heartRateRepository}) : super(const HeartRateState()) {
    on<GetRecentHeartRate>(_mapGetRecentHeartRateEventToState);
    on<ReceivedHeartRateMeasurement>(_mapReceivedHeartMeasurementEventToState);
    on<GetAllHeartRateMeasurements>(_mapGetAllHeartRateMeasurementsToState);
    on<GetMaxHeartRateMeasure>(_mapGetMaxHeartRateMeasureToState);
    on<GetMinHeartRateMeasure>(_mapGetMinHeartRateMeasureToState);
    on<GetAverageRateMeasure>(_mapGetAverageHeartRateMeasureToState);
  }

  void _mapGetRecentHeartRateEventToState(GetRecentHeartRate event, Emitter<HeartRateState> emit) async {

    emit(const HeartRateState(heartRateStatus: HeartRateStatus.loadingLastValue));
    await heartRateRepository.getMostRecent().then((value) => emit(HeartRateState(heartRateStatus: HeartRateStatus.lastValueLoaded, timestamp: value.timestamp, heartRate: value.heartRateValue)));

  }

  void _mapReceivedHeartMeasurementEventToState(ReceivedHeartRateMeasurement event, Emitter<HeartRateState> emit) async {
    
    emit(HeartRateState(heartRateStatus: HeartRateStatus.saving, heartRate: event.heartRateValue));

    HeartRate heartRateEntity = HeartRate(timestamp: DateTime.now(), heartRateValue: event.heartRateValue);

    await heartRateRepository.save(heartRateEntity).then((value) => emit(HeartRateState(heartRateStatus: HeartRateStatus.saved, timestamp: heartRateEntity.timestamp, heartRate: heartRateEntity.heartRateValue)));

  }

  void _mapGetAllHeartRateMeasurementsToState(GetAllHeartRateMeasurements event, Emitter<HeartRateState> emit) async {
    await heartRateRepository.getDailyAverages().then((value) {
      emit(HeartRateState(heartRateStatus: HeartRateStatus.allValuesLoaded, allHeartRates: value));
    });
  }

  void _mapGetMaxHeartRateMeasureToState(GetMaxHeartRateMeasure event, Emitter<HeartRateState> emit) async {
    await heartRateRepository.getMaxHeartRate().then((value) {
      value.isNaN ? emit(const HeartRateState(heartRateStatus: HeartRateStatus.maxValueLoaded, heartRate: 0)) : emit(HeartRateState(heartRateStatus: HeartRateStatus.maxValueLoaded, heartRate: value));
    });
  }

  void _mapGetMinHeartRateMeasureToState(GetMinHeartRateMeasure event, Emitter<HeartRateState> emit) async {
    await heartRateRepository.getMinHeartRate().then((value) {
      value.isNaN ? emit(const HeartRateState(heartRateStatus: HeartRateStatus.minValueLoaded, heartRate: 0)) : emit(HeartRateState(heartRateStatus: HeartRateStatus.minValueLoaded, heartRate: value));
    });
  }

  void _mapGetAverageHeartRateMeasureToState(GetAverageRateMeasure event, Emitter<HeartRateState> emit) async {
    await heartRateRepository.getAverageHeartRate().then((value) {
      value.isNaN ? emit(const HeartRateState(heartRateStatus: HeartRateStatus.avgValueLoaded, heartRate: 0)) : emit(HeartRateState(heartRateStatus: HeartRateStatus.avgValueLoaded, heartRate: value.roundToDouble()));
    });
  }

}
