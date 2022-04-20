import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:health_spike/themes/app_theme.dart';
import 'package:location/location.dart';

class LocationMainWidget extends StatefulWidget {
  const LocationMainWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LocationMainWidgetState();
}

class _LocationMainWidgetState extends State<LocationMainWidget> {
  late Stream<LocationData> _locationDataStream;
  String _distance = '?', _status = '?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onDistanceCount(Location event) {
    if (kDebugMode) {
      print(event);
    }

    setState(() {
      _distance = event.getLocation().toString();
    });
  }

  void onDistanceCountError() {
    print('onDistanceCountError');
    setState(() {
      _distance = 'Distance Count not available';
    });
  }

  Future<void> initPlatformState() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    _distance = _locationData.latitude.toString();

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
                      Container(
                          margin: const EdgeInsets.only(left: 5),
                          child:
                              Text('Distance', style: HealthSpikeTheme.title)),
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
