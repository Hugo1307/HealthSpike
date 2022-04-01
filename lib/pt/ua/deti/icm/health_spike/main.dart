import 'package:event_bus/event_bus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/models/pedometer_model.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/sensors/pedometer.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/themes/app_theme.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/utils/app_page.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/utils/permissions.dart';
import 'package:provider/provider.dart';

import 'dashboard/dashboard.dart';
import 'events/pedometer_events.dart';

final EventBus eventBus = EventBus();

class HealthSpikeAppContainer extends StatefulWidget {
  const HealthSpikeAppContainer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HealthSpikeAppContainerState();
}

class _HealthSpikeAppContainerState extends State<HealthSpikeAppContainer> {
  
  int _selectedItemIndex = 0;

  static final List<AppPage> _listOfPages = [
    AppPage(0, 'My Health', const DashboardBody()),
    AppPage(1, 'Stocks', const Text('"Stocks" is working!')),
    AppPage(2, 'Trade', const Text('"Trade" is working!')),
    AppPage(3, 'Pay', const Text('"Pay" is working!'))
  ];


  @override
  void initState() {
    
    super.initState();

    eventBus.on<StepsUpdatedEvent>().listen((event) {
      // All events are of type UserLoggedInEvent (or subtypes of it).
      Provider.of<PedometerModel>(context, listen: false).setStepsCount(event.stepsCount);
    });

    eventBus.on<PedestrianStatusUpdatedEvent>().listen((event) {
      // All events are of type UserLoggedInEvent (or subtypes of it).
      Provider.of<PedometerModel>(context, listen: false).setPedestrianState(event.pedestrianStatus);
    });

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
                  label: 'Página Inicial',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.pie_chart_outline),
                  label: 'Ativos',
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

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PedometerModel())
      ],
      child: MaterialApp(
        theme: HealthSpikeTheme.lightTheme,
        home: const HealthSpikeAppContainer(),
      )));

  AppPedometerSensor().initPlatformState();

  if (kDebugMode) {
    PermissionHandler().printPermissionCheck();
  }

  PermissionHandler().checkMandatoryPermissions();

}
