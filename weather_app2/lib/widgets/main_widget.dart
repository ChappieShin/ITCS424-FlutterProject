import 'package:flutter/material.dart';
import 'weather_tile.dart';

class MainWidget extends StatelessWidget {
  final location;
  final country;
  final temp;
  final tempMin;
  final tempMax;
  final weather;
  final humidity;
  final windSpeed;
  final unitSymbol;

  MainWidget({
    @required this.location,
    @required this.country,
    @required this.temp,
    @required this.tempMin,
    @required this.tempMax,
    @required this.weather,
    @required this.humidity,
    @required this.windSpeed,
    @required this.unitSymbol,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Current Weather',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(
                  'https://content.api.news/v3/images/bin/9da010285ed2df52012e9db32f3bf03b'),
              fit: BoxFit.cover,
              opacity: 0.3,
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${location.toString()}, ${country.toString()}',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Text(
                    '${temp.toInt().toString()}${unitSymbol}',
                    style: TextStyle(
                        color: Colors.cyan,
                        fontSize: 40.0,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Text(
                  'High: ${tempMax.toInt().toString()}${unitSymbol}, Low: ${tempMin.toInt().toString()}${unitSymbol}',
                  style: TextStyle(
                    color: Color(0XFF9E9E9E),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  WeatherTile(
                      icon: Icons.thermostat_outlined,
                      title: 'Temperature',
                      subtitle: '${temp.toInt().toString()}${unitSymbol}'),
                  WeatherTile(
                      icon: Icons.filter_drama_outlined,
                      title: 'Weather',
                      subtitle: '${weather.toString()}'),
                  WeatherTile(
                    icon: Icons.wb_sunny,
                    title: 'Humidity',
                    subtitle: '${humidity.toString()}%',
                  ),
                  WeatherTile(
                    icon: Icons.waves_outlined,
                    title: 'Wind Speed',
                    subtitle: '${windSpeed.toInt().toString()} MPH',
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
