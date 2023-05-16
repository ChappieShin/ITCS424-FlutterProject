import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'main_widget.dart';

Future<WeatherInfo> fetchWeather(String unit, String unitSymbol) async {
  await Geolocator.checkPermission();
  await Geolocator.requestPermission();
  final position = await Geolocator.getCurrentPosition();
  final lat = position.latitude;
  final lon = position.longitude;
  final apiKey = '9faaa353aabc666a3adc3c02a13a6362';
  final requestUrl = 'https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${apiKey}&units=${unit}';

  final response = await http.get(Uri.parse(requestUrl));

  if (response.statusCode == 200) {
    return WeatherInfo.fromJson(jsonDecode(response.body), unitSymbol);
  }
  else {
    throw Exception('Error');
  }
}

class WeatherInfo {
  final location;
  final country;
  final temp;
  final tempMin;
  final tempMax;
  final weather;
  final humidity;
  final windSpeed;
  final unitSymbol;

  WeatherInfo({
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

  factory WeatherInfo.fromJson(Map<String, dynamic> json, String unitSymbol) {
    return WeatherInfo(
      location: json['name'],
      country: json['sys']['country'],
      temp: json['main']['temp'],
      tempMin: json['main']['temp_min'],
      tempMax: json['main']['temp_max'],
      weather: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'],
      unitSymbol: unitSymbol,
    );
  }
}

class CurrentWeather extends StatefulWidget { 
  @override
  State<StatefulWidget> createState() {
    return _CurrentWeather();
  }
}

class _CurrentWeather extends State<CurrentWeather> {

  Future<WeatherInfo>? futureWeather;
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
      body: FutureBuilder<WeatherInfo>(
        future: futureWeather,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainWidget(
              location: snapshot.data!.location,
              country: snapshot.data!.country,
              temp: snapshot.data!.temp,
              tempMin: snapshot.data!.tempMin,
              tempMax: snapshot.data!.tempMax,
              weather: snapshot.data!.weather,
              humidity: snapshot.data!.humidity,
              windSpeed: snapshot.data!.windSpeed,
              unitSymbol: snapshot.data!.unitSymbol,
            );
          }
          else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }
          else {
            return  Center(child: CircularProgressIndicator());
          }
        },
      )
    );
  }
}