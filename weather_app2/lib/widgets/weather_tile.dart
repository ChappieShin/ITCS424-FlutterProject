import 'package:flutter/material.dart';

class WeatherTile extends StatelessWidget {
  IconData? icon;
  String? title, subtitle;

  WeatherTile({@required this.icon, @required this.title, @required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.cyan,)
        ],
      ),
      title: Text(
        title!,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle!,
        style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: Color(0XFF9E9E9E),
        ),
      ),
    );
  }
}