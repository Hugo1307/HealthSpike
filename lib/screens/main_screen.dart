import 'package:dart_amqp/dart_amqp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_spike/dashboard/dashboard.dart';
import 'package:health_spike/events/heart_rate_changed.dart';
import 'package:health_spike/events/pedometer_events.dart';
import 'package:health_spike/heart_rate/bloc/heart_rate_bloc.dart';
import 'package:health_spike/heart_rate/bloc/heart_rate_events.dart';
import 'package:health_spike/location/bloc/location_bloc.dart';
import 'package:health_spike/location/bloc/location_events.dart';
import 'package:health_spike/main.dart';
import 'package:health_spike/pages/distance_page/distance_page.dart';
import 'package:health_spike/pages/heart_page/main_heart_page.dart';
import 'package:health_spike/pages/steps_page/steps_page.dart';
import 'package:health_spike/provider_models/heart_rate_provider_model.dart';
import 'package:health_spike/provider_models/location_provider_model.dart';
import 'package:health_spike/provider_models/pedometer_provider_model.dart';
import 'package:health_spike/screens/commons/app_body.dart';
import 'package:health_spike/screens/commons/bottom_navbar.dart';
import 'package:health_spike/screens/commons/topbar.dart';
import 'package:health_spike/steps/bloc/steps_bloc.dart';
import 'package:health_spike/steps/bloc/steps_events.dart';
import 'package:health_spike/utils/app_page.dart';
import 'package:provider/provider.dart';

class HealthSpikeAppContainer extends StatefulWidget {
  const HealthSpikeAppContainer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HealthSpikeAppContainerState();
}

class _HealthSpikeAppContainerState extends State<HealthSpikeAppContainer> {
  int _selectedItemIndex = 0;

  static final List<AppPage> _listOfPages = [
    AppPage(0, 'Dashboard', const DashboardBody()),
    AppPage(1, 'Heart', const HeartPageBody()),
    AppPage(2, 'Steps', const StepsPageBody()),
    AppPage(3, 'Distance', const DistancePageBody())
  ];

  @override
  void initState() {

    super.initState();

    eventBus.on<StepsUpdatedEvent>().listen((event) {

      Provider.of<PedometerProviderModel>(context, listen: false)
          .setStepsCount(event.stepsCount);

      BlocProvider.of<StepsBloc>(context).add(UpdatedStepsEvent(
          stepsValue: event.stepsCount, timestamp: event.timestamp));

    });

    eventBus.on<PedestrianStatusUpdatedEvent>().listen((event) {
      Provider.of<PedometerProviderModel>(context, listen: false)
          .setPedestrianState(event.pedestrianStatus);
    });

    eventBus.on<DistanceUpdatedEvent>().listen((event) {

      Provider.of<LocationProviderModel>(context, listen: false)
          .setDistance(event.distance);

      BlocProvider.of<LocationBloc>(context).add(DistanceUpdatedEvent(
          timestamp: event.timestamp, distance: event.distance));

    });

    eventBus.on<LocationUpdatedEvent>().listen((event) {

      Provider.of<LocationProviderModel>(context, listen: false)
          .setCurrentLocation(event.latitude, event.longitude);

      BlocProvider.of<LocationBloc>(context).add(LocationUpdatedEvent(
          timestamp: event.timestamp, latitude: event.latitude, longitude: event.longitude));

    });

    rabbitMQHandler.consumeMessage()
        ?.then((consumer) => consumer.listen((AmqpMessage message) {

              HeartRateChangedEvent heartRateChangedEvent =
                  HeartRateChangedEvent.fromJson(message.payloadAsJson);

              BlocProvider.of<HeartRateBloc>(context).add(
                  ReceivedHeartRateMeasurement(
                      heartRateValue: heartRateChangedEvent.heartRate));

              Provider.of<HeartRateProviderModel>(context, listen: false)
                  .setCurrentHeartRate(
                      heartRateChangedEvent.heartRate, DateTime.now());

            }));
  }

  void refreshChild(childIndex) {
    setState(() {
      _selectedItemIndex = childIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: AppBody(child: _listOfPages.elementAt(_selectedItemIndex).widget),
      bottomNavigationBar: BottomNavBar(callbackOnUpdate: refreshChild),
    );
  }

}