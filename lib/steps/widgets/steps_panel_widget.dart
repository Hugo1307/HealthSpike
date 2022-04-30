import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_spike/heart_rate/bloc/heart_rate_bloc.dart';
import 'package:health_spike/heart_rate/bloc/heart_rate_states.dart';
import 'package:health_spike/models/pedometer_model.dart';
import 'package:health_spike/steps/bloc/steps_bloc.dart';
import 'package:health_spike/steps/bloc/steps_events.dart';
import 'package:health_spike/steps/bloc/steps_states.dart';
import 'package:health_spike/themes/app_theme.dart';
import 'package:health_spike/utils/date_formatter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class StepsPanelView extends StatefulWidget {
  const StepsPanelView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StepsPanelViewState();
}

class _StepsPanelViewState extends State<StepsPanelView> {
  @override
  Widget build(BuildContext context) {

    BlocProvider.of<StepsBloc>(context)
        .add(GetDailyStepsEvent(date: DateTime.now()));

    BlocProvider.of<StepsBloc>(context).add(GetDailyStepsEvent(
        date: DateTime.now().subtract(const Duration(days: 1))));

    BlocProvider.of<StepsBloc>(context)
        .add(GetWeeklyStepsEvent(date: DateTime.now()));

    BlocProvider.of<StepsBloc>(context).add(GetLastWalkTimestampEvent());

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
                      "Today's Steps",
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
                            child: BlocBuilder<StepsBloc, StepsState>(
                                buildWhen: (previous, current) =>
                                    previous != current &&
                                    current.status != null &&
                                    current.status!.event
                                        is GetDailyStepsEvent &&
                                    (current.status!.event
                                                as GetDailyStepsEvent)
                                            .date
                                            .difference(DateTime.now())
                                            .inDays ==
                                        0,
                                builder: (context, state) {
                                  return Text(
                                    (state.status!.value is int)
                                        ? state.status!.value.toString()
                                        : "0",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: HealthSpikeTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 32,
                                      color: HealthSpikeTheme.mainGreen,
                                    ),
                                  );
                                }),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8, bottom: 8),
                            child: Text(
                              'steps',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: HealthSpikeTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                letterSpacing: -0.2,
                                color: HealthSpikeTheme.mainGreen,
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
                                child: BlocBuilder<StepsBloc, StepsState>(
                                    buildWhen: (previous, current) =>
                                        previous != current &&
                                        current.status != null &&
                                        current.status!.event
                                            is GetLastWalkTimestampEvent,
                                    builder: (context, state) {
                                      return Text(
                                        state.status!.value is DateTime
                                            ? DateFormatter.format(
                                                state.status!.value as DateTime,
                                                DateFormat('EEEE HH:mm'))
                                            : 'Unknown',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: HealthSpikeTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          letterSpacing: 0.0,
                                          color: HealthSpikeTheme.grey
                                              .withOpacity(0.5),
                                        ),
                                      );
                                    }),
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
                                color: HealthSpikeTheme.mainGreen,
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
                        BlocBuilder<StepsBloc, StepsState>(
                          buildWhen: (previous, current) =>
                              previous != current &&
                              current.status != null &&
                              current.status!.event is GetDailyStepsEvent &&
                              (current.status!.event as GetDailyStepsEvent).date.difference(DateTime.now()).inDays ==-1,
                          builder: (context, state) => Text(
                            ((state.status!.value.toString() is int) ? state.status!.value.toString() : "0") + ' steps',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: HealthSpikeTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              letterSpacing: -0.2,
                              color: HealthSpikeTheme.mainGreen,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'Yesterday',
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
                            BlocBuilder<StepsBloc, StepsState>(
                              buildWhen: (previous, current) =>
                                  previous != current &&
                                  current.status != null &&
                                  current.status!.event is GetWeeklyStepsEvent,
                              builder: (context, state) => Text(
                                ((state.status!.value.toString() is int) ? state.status!.value.toString() : '0') + ' steps',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: HealthSpikeTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  letterSpacing: -0.2,
                                  color: HealthSpikeTheme.mainGreen,
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
                            Consumer<PedometerModel>(
                                builder: (context, pedometer, child) {
                              return Text(
                                pedometer.stepCount.toString() + ' steps',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: HealthSpikeTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  letterSpacing: -0.2,
                                  color: HealthSpikeTheme.mainGreen,
                                ),
                              );
                            }),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                'All Time',
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
