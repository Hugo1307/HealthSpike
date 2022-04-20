import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:health_spike/themes/app_theme.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class PedometerMainWidget extends StatefulWidget {
  const PedometerMainWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PedometerMainWidgetState();
}

class _PedometerMainWidgetState extends State<PedometerMainWidget> {

  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    if (kDebugMode) {
      print(event);
    }

    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    if (kDebugMode) {
      print(event);
    }

    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    Permission.activityRecognition.isGranted
        .then((b) => print('Hey ' + b.toString()));

    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0,
        child: InkWell(
            splashColor: Colors.grey,
            onTap: () => {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 15, top: 15),
                  child: Row(
                    children: [
                      SizedBox(
                          height: 30,
                          width: 30,
                          child: Image.asset('assets/images/tab_2s.png')),
                      Container(margin: const EdgeInsets.only(left: 5), child: Text('Steps', style: HealthSpikeTheme.title)),
                    ],
                  ),
                ),
                Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 18),
                    child: Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(left: 15),
                            child: const Text(
                              'Hello',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            )),
                      ],
                    ))
              ],
            )));
  }
}
