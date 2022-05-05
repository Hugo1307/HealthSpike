import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_spike/heart_rate/bloc/heart_rate_bloc.dart';
import 'package:health_spike/heart_rate/repository/heart_rate_repository.dart';
import 'package:health_spike/heart_rate/bloc/heart_rate_events.dart';
import 'package:health_spike/hooks/queue/rabbit_mq_handler.dart';
import 'package:health_spike/location/bloc/location_bloc.dart';
import 'package:health_spike/location/bloc/location_events.dart';
import 'package:health_spike/location/repository/location_repository.dart';
import 'package:health_spike/objectbox/object_box_handler.dart';
import 'package:health_spike/provider_models/heart_rate_provider_model.dart';
import 'package:health_spike/provider_models/location_provider_model.dart';
import 'package:health_spike/provider_models/pedometer_provider_model.dart';
import 'package:health_spike/screens/main_screen.dart';
import 'package:health_spike/screens/steps_goal_screen.dart';
import 'package:health_spike/sensor_services/location_service.dart';
import 'package:health_spike/sensor_services/pedometer_service.dart';
import 'package:health_spike/steps/bloc/steps_bloc.dart';
import 'package:health_spike/steps/bloc/steps_events.dart';
import 'package:health_spike/steps/repository/steps_repository.dart';
import 'package:health_spike/themes/app_theme.dart';
import 'package:health_spike/utils/permissions.dart';
import 'package:provider/provider.dart';


final EventBus eventBus = EventBus();
late RabbitMQHandler rabbitMQHandler;
late ObjectBox objectBoxInstance;

void main() async {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  WidgetsFlutterBinding.ensureInitialized();

  objectBoxInstance = await ObjectBox.create();

  rabbitMQHandler = RabbitMQHandler("68.183.40.100", "guest", "guest");
  await rabbitMQHandler.connect();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => PedometerProviderModel()),
      ChangeNotifierProvider(create: (context) => HeartRateProviderModel()),
      ChangeNotifierProvider(create: (context) => LocationProviderModel())
    ],
    child: MultiRepositoryProvider(
      providers: [
        RepositoryProvider<HeartRateRepository>(
            create: (context) => HeartRateRepository()),
        RepositoryProvider<StepsRepository>(
            create: (context) => StepsRepository()),
        RepositoryProvider<LocationRepository>(
            create: (context) => LocationRepository()),
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider<HeartRateBloc>(
              create: (context) => HeartRateBloc(
                heartRateRepository: context.read<HeartRateRepository>(),
              )
                ..add(GetRecentHeartRate())
                ..add(GetAllHeartRateMeasurements()),
            ),
            BlocProvider<StepsBloc>(
                create: (context) => StepsBloc(
                      stepsRepository: context.read<StepsRepository>(),
                    )..add(GetDailyStepsEvent(date: DateTime.now()))),
            BlocProvider<LocationBloc>(
                create: (context) => LocationBloc(
                      locationRepository: context.read<LocationRepository>(),
                    )..add(GetDailyDistanceEvent(date: DateTime.now()))),
          ],
          child: MaterialApp(
            theme: HealthSpikeTheme.lightTheme,
            initialRoute: '/',
            routes: {
              '/': (context) => const HealthSpikeAppContainer(),
              '/steps_goal': (context) => const StepsGoalScreen(),
            },
          )),
    ),
  ));

  if (kDebugMode) {
    PermissionHandler().printPermissionCheck();
  }

  await PermissionHandler().checkMandatoryPermissions();

  AppPedometerSensor().initPlatformState();

  AppLocationSensor().initPlatformState();

}
