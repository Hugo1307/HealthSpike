import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_spike/location/bloc/location_bloc.dart';
import 'package:health_spike/location/bloc/location_events.dart';
import 'package:health_spike/location/bloc/location_states.dart';
import 'package:health_spike/location/model/location_model.dart';
import 'package:health_spike/provider_models/location_provider_model.dart';
import 'package:health_spike/themes/app_theme.dart';
import 'package:health_spike/utils/date_formatter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class LocationPanelView extends StatefulWidget {
  const LocationPanelView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LocationPanelViewState();
}

class _LocationPanelViewState extends State<LocationPanelView> {
  
  Timer? dataUpdaterTimer;

  @override
  void initState() {
    super.initState();
    dataUpdaterTimer = Timer.periodic(const Duration(seconds: 5), (Timer t) => updateData());
    updateData();
  }

  @override
  void dispose() {
    dataUpdaterTimer?.cancel();
    super.dispose();
  }

  void updateData() {
    BlocProvider.of<LocationBloc>(context).add(GetDailyDistanceEvent(date: DateTime.now()));
    BlocProvider.of<LocationBloc>(context).add(GetWeeklyDistanceEvent(date: DateTime.now()));
    BlocProvider.of<LocationBloc>(context).add(GetLastLocationEvent());
    BlocProvider.of<LocationBloc>(context).add(GetTotalDistanceEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 18),
      child: Container(
        decoration: BoxDecoration(
          color: HealthSpikeTheme.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0),
              topRight: Radius.circular(68.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: HealthSpikeTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 10.0),
          ],
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(left: 4, bottom: 8, top: 16),
                    child: Text(
                      "Today's Distance",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: HealthSpikeTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: -0.1,
                          color: HealthSpikeTheme.darkText),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 3),
                            child: BlocBuilder<LocationBloc, LocationState>(
                                buildWhen: (previousState, state) =>
                                    previousState != state &&
                                    state.status != null &&
                                    state.status!.event is GetDailyDistanceEvent &&
                                    state.status!.status == LocationStateStatus.loaded,
                                builder: (context, state) {
                                  return Text(
                                    state.status != null
                                        ? state.status!.value is double
                                            ? (state.status!.value as double)
                                                .toStringAsFixed(2)
                                            : '0'
                                        : '0',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: HealthSpikeTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 32,
                                      color: HealthSpikeTheme.nearlyBlue,
                                    ),
                                  );
                                }),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8, bottom: 8),
                            child: Text(
                              'Km',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: HealthSpikeTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                letterSpacing: -0.2,
                                color: HealthSpikeTheme.nearlyBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.access_time,
                                color: HealthSpikeTheme.grey.withOpacity(0.5),
                                size: 16,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: BlocBuilder<LocationBloc, LocationState>(
                                buildWhen: (previousState, state) =>
                                    previousState != state &&
                                    state.status != null &&
                                    state.status!.event is GetLastLocationEvent &&
                                    state.status!.status == LocationStateStatus.loaded,
                                builder: (context, state) =>
                                  Text(
                                    state.status != null ? 
                                    DateFormatter.format(
                                          state.status!.value is LocationModel ?
                                            (state.status!.value as LocationModel).timestamp : DateTime.fromMillisecondsSinceEpoch(0),
                                        DateFormat('EEEE HH:mm')) : 'Unknown',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: HealthSpikeTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: 0.0,
                                      color: HealthSpikeTheme.grey
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 4, bottom: 14),
                            child: Text(
                              'Last Sample',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: HealthSpikeTheme.fontName,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                letterSpacing: 0.0,
                                color: HealthSpikeTheme.nearlyBlue,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
              child: Container(
                height: 2,
                decoration: const BoxDecoration(
                  color: HealthSpikeTheme.background,
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 8, bottom: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        BlocBuilder<LocationBloc, LocationState>(
                          buildWhen: (previousState, state) =>
                              previousState != state &&
                              state.status != null &&
                              state.status!.event is GetTotalDistanceEvent &&
                              state.status!.status ==
                                  LocationStateStatus.loaded,
                          builder: (context, state) => Text(
                            (state.status != null
                                    ? state.status!.value is double
                                        ? (state.status!.value as double)
                                            .toStringAsFixed(2)
                                        : '0'
                                    : '0') +
                                ' Km',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: HealthSpikeTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              letterSpacing: -0.2,
                              color: HealthSpikeTheme.nearlyBlue,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'Total',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: HealthSpikeTheme.fontName,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: HealthSpikeTheme.grey.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            BlocBuilder<LocationBloc, LocationState>(
                              buildWhen: (previousState, state) =>
                                  previousState != state &&
                                  state.status != null &&
                                  state.status!.event
                                      is GetWeeklyDistanceEvent &&
                                  state.status!.status ==
                                      LocationStateStatus.loaded,
                              builder: (context, state) => Text(
                                (state.status != null
                                        ? state.status!.value is double
                                            ? (state.status!.value as double)
                                                .toStringAsFixed(2)
                                            : '0'
                                        : '0') +
                                    ' Km',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: HealthSpikeTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  letterSpacing: -0.2,
                                  color: HealthSpikeTheme.nearlyBlue,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                'Week',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: HealthSpikeTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: HealthSpikeTheme.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Consumer<LocationProviderModel>(
                                builder: (context, locationModel, child) {
                              return Text(
                                locationModel.currentLatitude.toStringAsFixed(2) + ":" + locationModel.currentLongitude.toStringAsFixed(2),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: HealthSpikeTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 11,
                                  color: HealthSpikeTheme.nearlyBlue,
                                ),
                              );
                            }),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                'Location',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: HealthSpikeTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: HealthSpikeTheme.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
}
