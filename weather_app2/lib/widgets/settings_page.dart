import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String selectedUnit = '';
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
      selectedUnitSymbol = prefs.getString('unitSymbol') ?? '°C';
    });
  }

  Future<void> _saveSelectedUnit(String unit, String unitSymbol) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('unit', unit);
    await prefs.setString('unitSymbol', unitSymbol);
    setState(
      () {
        selectedUnit = unit;
        if (unitSymbol == '°C') {
          selectedUnitSymbol = '°C';
        } else if (unitSymbol == '°F') {
          selectedUnitSymbol = '°F';
        } else if (unitSymbol == '°K') {
          selectedUnitSymbol = '°K';
        } else {
          selectedUnitSymbol = '°C';
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Temperature Unit:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Celsius (°C)'),
              leading: Radio(
                value: 'metric',
                groupValue: selectedUnit,
                onChanged: (value) {
                  _saveSelectedUnit(value!, '°C');
                },
              ),
            ),
            ListTile(
              title: Text('Fahrenheit (°F)'),
              leading: Radio(
                value: 'imperial',
                groupValue: selectedUnit,
                onChanged: (value) {
                  _saveSelectedUnit(value!, '°F');
                },
              ),
            ),
            ListTile(
              title: Text('Kelvin (°K)'),
              leading: Radio(
                value: 'standard',
                groupValue: selectedUnit,
                onChanged: (value) {
                  _saveSelectedUnit(value!, '°K');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
