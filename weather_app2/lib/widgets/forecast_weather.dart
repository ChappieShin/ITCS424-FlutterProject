import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';

Future<List<WeatherInfo>> fetchWeather(String unit, String unitSymbol) async {
  await Geolocator.checkPermission();
  await Geolocator.requestPermission();
  final position = await Geolocator.getCurrentPosition();
  final lat = position.latitude;
  final lon = position.longitude;
  final apiKey = '9faaa353aabc666a3adc3c02a13a6362';
  final requestUrl = 'https://api.openweathermap.org/data/2.5/forecast?lat=${lat}&lon=${lon}&appid=${apiKey}&units=${unit}';

  final response = await http.get(Uri.parse(requestUrl));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final weatherList = List<WeatherInfo>.from(
        jsonResponse['list'].map((data) => WeatherInfo.fromJson(data, unitSymbol)));
    return weatherList;
  } else {
    throw Exception('Error');
  }
}

class WeatherInfo {
  final DateTime date;
  final double temp;
  final String weather;
  final unitSymbol;

  WeatherInfo({
    required this.date,
    required this.temp,
    required this.weather,
    required this.unitSymbol
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json, String unitSymbol) {
    return WeatherInfo(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temp: json['main']['temp'].toDouble(),
      weather: json['weather'][0]['description'],
      unitSymbol: unitSymbol,
    );
  }
}

class ForecastWeather extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ForecastWeather();
  }
}

class _ForecastWeather extends State<ForecastWeather> {
  Future<List<WeatherInfo>>? futureWeather;
  String selectedUnit = 'metric';
  String selectedUnitSymbol = '°C';

  @override
  void initState() {
    super.initState();
    _loadSelectedUnit();
  }

  Future<void> _loadSelectedUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedUnit = prefs.getString('unit') ?? 'metric';
      if (selectedUnit == 'metric') {
        selectedUnitSymbol = '°C';
      } else if (selectedUnit == 'imperial') {
        selectedUnitSymbol = '°F';
      } else if (selectedUnit == 'standard') {
        selectedUnitSymbol = '°K';
      }
      futureWeather = fetchWeather(selectedUnit, selectedUnitSymbol);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weather Forecast',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<WeatherInfo>>(
        future: futureWeather,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final weatherInfo = snapshot.data![index];
                final date = DateFormat('EEEE, MMM d').format(weatherInfo.date);
                final time = DateFormat.jm().format(weatherInfo.date);
                return ListTile(
                  title: Text(date),
                  subtitle: Text(time),
                  leading: Text(
                    '${weatherInfo.temp.round()}${selectedUnitSymbol}',
                    style: TextStyle(
                      color: Colors.cyan,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Text(weatherInfo.weather),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
