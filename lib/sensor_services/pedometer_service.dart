import 'package:flutter/foundation.dart';
import 'package:health_spike/events/pedometer_events.dart';
import 'package:pedometer/pedometer.dart';

import '../main.dart';

class AppPedometerSensor {

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?';

  void onStepCount(StepCount event) {

    if (kDebugMode) {
      print(event);
    }

    eventBus.fire(StepsUpdatedEvent(event.steps, event.timeStamp));
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {

    if (kDebugMode) {
      print(event);
    }
    eventBus.fire(PedestrianStatusUpdatedEvent(event.status, event.timeStamp));
    
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
  }

  void initPlatformState() {

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

  }


}