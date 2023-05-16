import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';

Future<List<AirPollutionInfo>> fetchAirPollution() async {
  await Geolocator.checkPermission();
  await Geolocator.requestPermission();
  final position = await Geolocator.getCurrentPosition();
  final lat = position.latitude;
  final lon = position.longitude;
  final apiKey = '9faaa353aabc666a3adc3c02a13a6362';
  final requestUrl =
      'https://api.openweathermap.org/data/2.5/air_pollution?lat=${lat}&lon=${lon}&appid=${apiKey}';

  final response = await http.get(Uri.parse(requestUrl));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final airPollutionList = List<AirPollutionInfo>.from(
        jsonResponse['list'].map((data) => AirPollutionInfo.fromJson(data)));
    return airPollutionList;
  } else {
    throw Exception('Error');
  }
}

class AirPollutionInfo {
  final DateTime date;
  final int aqi;
  final dynamic co;
  final dynamic no;
  final dynamic no2;
  final dynamic o3;
  final dynamic so2;
  final dynamic pm2_5;
  final dynamic pm10;
  final dynamic nh3;

  AirPollutionInfo({
    required this.date,
    required this.aqi,
    required this.co,
    required this.no,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm2_5,
    required this.pm10,
    required this.nh3,
  });

  factory AirPollutionInfo.fromJson(Map<String, dynamic> json) {
    return AirPollutionInfo(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000, isUtc: true),
      aqi: json['main']['aqi'],
      co: json['components']['co'].toDouble(),
      no: json['components']['no'].toDouble(),
      no2: json['components']['no2'].toDouble(),
      o3: json['components']['o3'].toDouble(),
      so2: json['components']['so2'].toDouble(),
      pm2_5: json['components']['pm2_5'].toDouble(),
      pm10: json['components']['pm10'].toDouble(),
      nh3: json['components']['nh3'].toDouble(),
    );
  }
}

class AirPollution extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AirPollution();
  }
}

class _AirPollution extends State<AirPollution> {
  Future<List<AirPollutionInfo>>? futureAirPollution;

  @override
  void initState() {
    super.initState();
    futureAirPollution = fetchAirPollution();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Air Pollution',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<List<AirPollutionInfo>>(
        future: futureAirPollution,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    for (var airPollutionInfo in snapshot.data!)
                      Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Air Pollution Information',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyan,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              '${DateFormat('EEEE, MMM d').format(airPollutionInfo.date)}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${DateFormat.jm().format(airPollutionInfo.date)}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Air Quality Index (AQI):',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${airPollutionInfo.aqi} (${_getAQIDescription(airPollutionInfo.aqi)})',
                              style: TextStyle(
                                fontSize: 32,
                                color: _getAQIColor(airPollutionInfo.aqi),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text('Carbon Monoxide (CO): ${airPollutionInfo.co}'),
                            Text('Nitrogen Monoxide (NO): ${airPollutionInfo.no}'),
                            Text('Nitrogen Dioxide(NO2): ${airPollutionInfo.no2}'),
                            Text('Ozone (O3): ${airPollutionInfo.o3}'),
                            Text('Sulphur Dioxide (SO2): ${airPollutionInfo.so2}'),
                            Text('PM2.5: ${airPollutionInfo.pm2_5}'),
                            Text('PM10: ${airPollutionInfo.pm10}'),
                            Text('Ammonia (NH3): ${airPollutionInfo.nh3}'),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
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

  String _getAQIDescription(int aqi) {
    switch (aqi) {
      case 1:
        return 'Good';
      case 2:
        return 'Fair';
      case 3:
        return 'Moderate';
      case 4:
        return 'Poor';
      case 5:
        return 'Very Poor';
      default:
        return 'Unknown';
    }
  }

  Color _getAQIColor(int aqi) {
    switch (aqi) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.red;
      case 5:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
