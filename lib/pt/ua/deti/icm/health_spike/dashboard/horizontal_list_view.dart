import 'package:flutter/material.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/themes/app_theme.dart';
import 'package:health_spike/pt/ua/deti/icm/health_spike/utils/weather_data.dart';
import 'package:intl/intl.dart';

class WeatherListView extends StatefulWidget {
  const WeatherListView({Key? key}) : super(key: key);

  @override
  _WeatherListViewState createState() => _WeatherListViewState();
}

class _WeatherListViewState extends State<WeatherListView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 226,
        width: double.infinity,
        child: FutureBuilder<List<WeatherData>>(
          future: WeatherDataStore.loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 10, right: 16, left: 16),
                itemCount: snapshot.data!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return WeatherView(
                    weatherData: snapshot.data![index],
                  );
                },
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: 1,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return const Center(child: Text('Loading'));
                },
              );
            }
          },
        ));
  }
}

class WeatherView extends StatelessWidget {
  const WeatherView({Key? key, this.weatherData}) : super(key: key);

  final WeatherData? weatherData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 25),
      width: 130,
      child: Stack(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 32, left: 0, right: 0, bottom: 5),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: HealthSpikeTheme.mainGreen.withOpacity(0.6),
                      offset: const Offset(1.1, 4.0),
                      blurRadius: 8.0),
                ],
                gradient: LinearGradient(
                  colors: [
                    HealthSpikeTheme.mainGreen,
                    HealthSpikeTheme.mainGreen.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(8.0),
                  bottomLeft: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(54.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 54, left: 16, right: 16, bottom: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      DateFormat('EEEE')
                          .format(weatherData!.dateTime)
                          .toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: HealthSpikeTheme.fontName,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.2,
                        color: HealthSpikeTheme.white,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 90,
                              child: Text(
                                weatherData!.getDescription(),
                                style: const TextStyle(
                                  fontFamily: HealthSpikeTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  letterSpacing: 0.2,
                                  color: HealthSpikeTheme.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 5),
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          weatherData!.temperature.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: HealthSpikeTheme.fontName,
                            fontWeight: FontWeight.w500,
                            fontSize: 22,
                            letterSpacing: 0.2,
                            color: HealthSpikeTheme.white,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 3),
                          child: Text(
                            'ºC',
                            style: TextStyle(
                              fontFamily: HealthSpikeTheme.fontName,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              letterSpacing: 0.2,
                              color: HealthSpikeTheme.white,
                            ),
                          ),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: HealthSpikeTheme.nearlyWhite.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 8,
            child: SizedBox(
              width: 80,
              height: 80,
              child: weatherData!.getPicture(),
            ),
          )
        ],
      ),
    );
  }
}
