import 'package:dart_amqp/dart_amqp.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_spike/events/heart_rate_changed.dart';
import 'package:health_spike/events/location_events.dart';
import 'package:health_spike/heart_page/main_heart_page.dart';
import 'package:health_spike/heart_rate/bloc/heart_rate_bloc.dart';
import 'package:health_spike/heart_rate/repository/heart_rate_repository.dart';
import 'package:health_spike/heart_rate/bloc/heart_rate_events.dart';
import 'package:health_spike/hooks/queue/rabbit_mq_handler.dart';
import 'package:health_spike/models/heart_rate_model.dart';
import 'package:health_spike/models/location_model.dart';
import 'package:health_spike/models/pedometer_model.dart';
import 'package:health_spike/objectbox/object_box_handler.dart';
import 'package:health_spike/sensors/location.dart';
import 'package:health_spike/sensors/pedometer.dart';
import 'package:health_spike/themes/app_theme.dart';
import 'package:health_spike/utils/app_page.dart';
import 'package:health_spike/utils/permissions.dart';
import 'package:provider/provider.dart';

import 'dashboard/dashboard.dart';
import 'events/pedometer_events.dart';

final EventBus eventBus = EventBus();
late RabbitMQHandler rabbitMQHandler;
late ObjectBox objectBoxInstance;

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
    AppPage(2, 'Trade', const Text('"Trade" is working!')),
    AppPage(3, 'Pay', const Text('"Pay" is working!'))
  ];

  @override
  void initState() {
    super.initState();

    eventBus.on<StepsUpdatedEvent>().listen((event) {
      // All events are of type UserLoggedInEvent (or subtypes of it).
      Provider.of<PedometerModel>(context, listen: false)
          .setStepsCount(event.stepsCount);
    });

    eventBus.on<PedestrianStatusUpdatedEvent>().listen((event) {
      // All events are of type UserLoggedInEvent (or subtypes of it).
      Provider.of<PedometerModel>(context, listen: false)
          .setPedestrianState(event.pedestrianStatus);
    });

    eventBus.on<LocationChangedEvent>().listen((event) {
      // All events are of type UserLoggedInEvent (or subtypes of it).
      Provider.of<LocationModel>(context, listen: false)
          .setCurrentLocation(event.location);
    });

    rabbitMQHandler
        .consumeMessage()
        ?.then((consumer) => consumer.listen((AmqpMessage message) {
              HeartRateChangedEvent heartRateChangedEvent =
                  HeartRateChangedEvent.fromJson(message.payloadAsJson);

              BlocProvider.of<HeartRateBloc>(context).add(
                  ReceivedHeartRateMeasurement(
                      heartRateValue: heartRateChangedEvent.heartRate));
              // BlocProvider.of<HeartRateBloc>(context).add(GetRecentHeartRate());

              Provider.of<HeartRateModel>(context, listen: false)
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
      appBar:
          TopBar(titleStr: _listOfPages.elementAt(_selectedItemIndex).title),
      body: AppBody(child: _listOfPages.elementAt(_selectedItemIndex).widget),
      bottomNavigationBar: BottomNavBar(callbackOnUpdate: refreshChild),
    );
  }
}

class TopBar extends AppBar {
  final String titleStr;

  TopBar({required this.titleStr, Key? key})
      : super(
          key: key,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: ThemeData.light().scaffoldBackgroundColor,
          elevation: 0,
          actions: [
            Container(
                margin: const EdgeInsets.only(top: 32, left: 13),
                child: Image.asset('assets/images/large_healthspike.png',
                    width: 140, fit: BoxFit.cover)),
            const Spacer(),
          ],
        );
}

class AppBody extends StatelessWidget {
  final Widget child;

  const AppBody({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: child);
  }
}

class BottomNavBar extends StatefulWidget {
  final Function callbackOnUpdate;
  const BottomNavBar({Key? key, required this.callbackOnUpdate})
      : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      widget.callbackOnUpdate(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              elevation: 3,
              showUnselectedLabels: true,
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.bold),
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              unselectedItemColor: Colors.black,
              unselectedFontSize: 10,
              selectedFontSize: 10,
              enableFeedback: false,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.monitor_heart),
                  label: 'Heart Rate',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.show_chart),
                  label: 'Negociar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.attach_money),
                  label: 'Pagar',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: HealthSpikeTheme.mainGreen,
              onTap: _onItemTapped,
            )));
  }
}

void main() async {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  WidgetsFlutterBinding.ensureInitialized();

  objectBoxInstance = await ObjectBox.create();

  rabbitMQHandler = RabbitMQHandler("68.183.40.100", "guest", "guest");
  await rabbitMQHandler.connect();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => PedometerModel()),
      ChangeNotifierProvider(create: (context) => HeartRateModel()),
      ChangeNotifierProvider(create: (context) => LocationModel())
    ],
    child: RepositoryProvider(
      create: (context) => HeartRateRepository(),
      child: MultiBlocProvider(
          providers: [
            BlocProvider<HeartRateBloc>(
              create: (context) => HeartRateBloc(
                heartRateRepository: context.read<HeartRateRepository>(),
              )
                ..add(GetRecentHeartRate())
                ..add(GetAllHeartRateMeasurements()),
            ),
          ],
          child: MaterialApp(
            theme: HealthSpikeTheme.lightTheme,
            home: const HealthSpikeAppContainer(),
          )),
    ),
  ));

  AppPedometerSensor().initPlatformState();

  AppLocationSensor().initPlatformState();

  if (kDebugMode) {
    PermissionHandler().printPermissionCheck();
  }

  PermissionHandler().checkMandatoryPermissions();
}
