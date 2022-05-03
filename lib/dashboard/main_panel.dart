import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_spike/location/bloc/location_bloc.dart';
import 'package:health_spike/location/bloc/location_events.dart';
import 'package:health_spike/location/bloc/location_states.dart';
import 'package:health_spike/provider_models/pedometer_provider_model.dart';
import 'package:health_spike/themes/app_theme.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class OverviewPanelView extends StatefulWidget {
  const OverviewPanelView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OverviewPanelViewState();

}

class _OverviewPanelViewState extends State<OverviewPanelView> {

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
  }

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 16, bottom: 18),
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
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
              padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                height: 48,
                                width: 2,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF87A0E5).withOpacity(0.5),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, bottom: 2),
                                      child: Text(
                                        'Steps',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: HealthSpikeTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: -0.1,
                                          color: HealthSpikeTheme.grey
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: Image.asset(
                                              "assets/fitness_app/runner.png"),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 3),
                                          child:
                                              Consumer<PedometerProviderModel>(
                                                  builder: (context, pedometer,
                                                      child) {
                                            return Text(
                                              '${pedometer.stepCount}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontFamily:
                                                    HealthSpikeTheme.fontName,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color:
                                                    HealthSpikeTheme.darkerText,
                                              ),
                                            );
                                          }),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                height: 48,
                                width: 2,
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFF56E98).withOpacity(0.5),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4.0)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 4, bottom: 2),
                                      child: Text(
                                        'Distance',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: HealthSpikeTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                          letterSpacing: -0.1,
                                          color: HealthSpikeTheme.grey
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 28,
                                          height: 28,
                                          child: Image.asset(
                                              "assets/fitness_app/burned.png"),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4, bottom: 3),
                                            child: BlocBuilder<LocationBloc,
                                                    LocationState>(
                                                buildWhen: (previousState,
                                                        state) =>
                                                    previousState != state &&
                                                    state.status != null &&
                                                    state.status!.event
                                                        is GetDailyDistanceEvent &&
                                                    state.status!.status ==
                                                        LocationStateStatus
                                                            .loaded,
                                                builder: (context, state) =>
                                                  Text(
                                                    state.status != null
                                                        ? state.status!.value is double
                                                            ? (state.status!.value as double)
                                                                .toStringAsFixed(2)
                                                            : '0'
                                                        : '0',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontFamily:
                                                          HealthSpikeTheme
                                                              .fontName,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 16,
                                                      color: HealthSpikeTheme
                                                          .darkerText,
                                                    ),
                                                  ),
                                                )),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8, bottom: 3),
                                          child: Text(
                                            'Km',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily:
                                                  HealthSpikeTheme.fontName,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              letterSpacing: -0.2,
                                              color: HealthSpikeTheme.grey
                                                  .withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: HealthSpikeTheme.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100.0),
                                ),
                                border: Border.all(
                                    width: 4,
                                    color: HealthSpikeTheme.nearlyDarkBlue
                                        .withOpacity(0.2)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Consumer<PedometerProviderModel>(
                                      builder: (context, pedometer, child) {
                                    return Text(
                                      '${(pedometer.dailyGoal > pedometer.stepCount ? pedometer.dailyGoal - pedometer.stepCount : pedometer.stepCount).toInt()}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: HealthSpikeTheme.fontName,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 24,
                                        letterSpacing: 0.0,
                                        color: HealthSpikeTheme.darkGrey,
                                      ),
                                    );
                                  }),
                                  Consumer<PedometerProviderModel>(
                                      builder: (context, pedometer, child) {
                                    return Text(
                                      'Steps ${pedometer.dailyGoal > pedometer.stepCount ? 'left' : ''}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: HealthSpikeTheme.fontName,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        letterSpacing: 0.0,
                                        color: HealthSpikeTheme.grey
                                            .withOpacity(0.5),
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Consumer<PedometerProviderModel>(
                                builder: (context, pedometer, child) {
                              return CustomPaint(
                                painter: CurvePainter(
                                    colors: [
                                      HealthSpikeTheme.mainGreen,
                                      HealthSpikeTheme.mainGreen
                                    ],
                                    angle:
                                        (pedometer.goalPercentage * 360 / 100)),
                                child: const SizedBox(
                                  width: 108,
                                  height: 108,
                                ),
                              );
                            }),
                          )
                        ],
                      ),
                    ),
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
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Row(
                children: <Widget>[
                  Consumer<PedometerProviderModel>(
                      builder: (context, pedometer, child) {
                    return Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: Image.asset(
                          pedometer.isPedestrianWalking()
                              ? 'assets/images/walking.png'
                              : 'assets/images/stopped.png',
                          height: 40,
                          width: 40,
                        ));
                  }),
                  Consumer<PedometerProviderModel>(
                      builder: (context, pedometer, child) {
                    return Container(
                        margin: const EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          pedometer.isPedestrianWalking()
                              ? 'Keep up!'
                              : 'Try to walk for a bit...',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontFamily: HealthSpikeTheme.fontName,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            letterSpacing: 0.5,
                            color: HealthSpikeTheme.lightText,
                          ),
                        ));
                  }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  final double? angle;
  final List<Color>? colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = [];
    if (colors != null) {
      colorsList = colors ?? [];
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shadowPaintCenter = Offset(size.width / 2, size.height / 2);
    final shadowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        Rect.fromCircle(center: shadowPaintCenter, radius: shadowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shadowPaint);

    shadowPaint.color = Colors.grey.withOpacity(0.3);
    shadowPaint.strokeWidth = 16;
    canvas.drawArc(
        Rect.fromCircle(center: shadowPaintCenter, radius: shadowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shadowPaint);

    shadowPaint.color = Colors.grey.withOpacity(0.2);
    shadowPaint.strokeWidth = 20;
    canvas.drawArc(
        Rect.fromCircle(center: shadowPaintCenter, radius: shadowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shadowPaint);

    shadowPaint.color = Colors.grey.withOpacity(0.1);
    shadowPaint.strokeWidth = 22;
    canvas.drawArc(
        Rect.fromCircle(center: shadowPaintCenter, radius: shadowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        shadowPaint);

    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle!)),
        false,
        paint);

    const gradient1 = SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = Paint();
    cPaint.shader = gradient1.createShader(rect);
    cPaint.color = Colors.white;
    cPaint.strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle! + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(const Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
