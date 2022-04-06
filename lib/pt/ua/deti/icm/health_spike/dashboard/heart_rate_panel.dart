import 'package:flutter/material.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/models/heart_rate_model.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/themes/app_theme.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/utils/date_formatter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HeartRateView extends StatefulWidget {
  const HeartRateView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HeartRateViewState();
}

class _HeartRateViewState extends State<HeartRateView> {
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
                      'Heart Rate',
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
                            child: Consumer<HeartRateModel>(
                                builder: (context, heartRateModel, child) {
                              return Text(
                                heartRateModel.currentHeartRate.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: HealthSpikeTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 32,
                                  color: HealthSpikeTheme.mainRed,
                                ),
                              );
                            }),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8, bottom: 8),
                            child: Text(
                              'bpm',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: HealthSpikeTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                letterSpacing: -0.2,
                                color: HealthSpikeTheme.mainRed,
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
                                child: Consumer<HeartRateModel>(
                                    builder: (context, heartRateModel, child) {
                                  return Text(
                                    DateFormatter.format(
                                        heartRateModel.lastTimestamp != null
                                            ? heartRateModel.lastTimestamp!
                                            : DateTime
                                                .fromMicrosecondsSinceEpoch(0),
                                        DateFormat('EEEE HH:mm')),
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
                                color: HealthSpikeTheme.mainRed,
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
                        const Text(
                          '185 cm',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: HealthSpikeTheme.fontName,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            letterSpacing: -0.2,
                            color: HealthSpikeTheme.darkText,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            'Height',
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
                            const Text(
                              '27.3 BMI',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: HealthSpikeTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                letterSpacing: -0.2,
                                color: HealthSpikeTheme.darkText,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                'Overweight',
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
                            const Text(
                              '20%',
                              style: TextStyle(
                                fontFamily: HealthSpikeTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                letterSpacing: -0.2,
                                color: HealthSpikeTheme.darkText,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                'Body fat',
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
