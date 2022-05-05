import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_spike/screens/commons/app_body.dart';
import 'package:health_spike/screens/commons/topbar.dart';
import 'package:health_spike/steps/bloc/steps_bloc.dart';
import 'package:health_spike/steps/bloc/steps_events.dart';
import 'package:health_spike/steps/bloc/steps_states.dart';
import 'package:health_spike/themes/app_theme.dart';

class StepsGoalScreen extends StatefulWidget {
  const StepsGoalScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StepsGoalScreenState();
}

class _StepsGoalScreenState extends State<StepsGoalScreen> {
  int newDailyGoal = 0;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    BlocProvider.of<StepsBloc>(context).add(GetDailyGoal());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(),
      body: AppBody(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 18),
          child: Container(
            height: 300,
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
                        padding: EdgeInsets.only(left: 4, bottom: 8, top: 8),
                        child: Text(
                          "Daily Goal",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: HealthSpikeTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              letterSpacing: 0.2,
                              color: HealthSpikeTheme.darkText),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, bottom: 3),
                                  child: BlocBuilder<StepsBloc, StepsState>(
                                      buildWhen: (previous, current) =>
                                          previous != current &&
                                          current.status != null &&
                                          current.status!.event is GetDailyGoal,
                                      builder: (context, state) {
                                        return Text(
                                          '${state.status!.value}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily:
                                                HealthSpikeTheme.fontName,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            letterSpacing: -0.2,
                                            color: HealthSpikeTheme.mainGreen,
                                          ),
                                        );
                                      })),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, bottom: 8),
                                child: Text(
                                  'Current Value',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: HealthSpikeTheme.fontName,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color:
                                        HealthSpikeTheme.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 120),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, bottom: 3),
                                  child: Text(
                                    '$newDailyGoal',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: HealthSpikeTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      letterSpacing: -0.2,
                                      color: HealthSpikeTheme.mainGreen,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, bottom: 8),
                                  child: Text(
                                    'New Value',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: HealthSpikeTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: HealthSpikeTheme.grey
                                          .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 8, bottom: 8),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'New Goal',
                                  border: InputBorder.none,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                onChanged: (s) => setState(() {
                                  newDailyGoal = int.tryParse(s) ?? 0;
                                }),
                              ),
                              Text(
                                'Set new goal value',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: HealthSpikeTheme.fontName,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: HealthSpikeTheme.grey.withOpacity(0.5),
                                ),
                              ),
                            ]),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 8, bottom: 8),
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
                      left: 24, right: 24, top: 8, bottom: 8),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: HealthSpikeTheme.mainGreen),
                      primary: HealthSpikeTheme.mainGreen,
                      onSurface: Colors.red,
                    ),
                    onPressed: () {
                      BlocProvider.of<StepsBloc>(context)
                          .add(SetDailyGoal(newDailyGoal));
                      Navigator.pop(context);
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
