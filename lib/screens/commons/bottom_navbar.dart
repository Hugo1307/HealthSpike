import 'package:flutter/material.dart';
import 'package:health_spike/themes/app_theme.dart';

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
                  icon: Icon(Icons.directions_walk),
                  label: 'Steps',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.gps_fixed),
                  label: 'Distance',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: HealthSpikeTheme.mainGreen,
              onTap: _onItemTapped,
            )));
  }
}