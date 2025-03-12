import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
///Returns the appropriate weather icon based on the given weatherId.
class WeatherIconUtils {
  static Icon get(int weatherId) {
    switch(weatherId){
      case < 300 : return Icon(Icons.thunderstorm, color: Colors.deepPurple[100]);
      case < 400 : return Icon(CupertinoIcons.cloud_drizzle_fill, color: Colors.blue[100]);
      case < 600 : return Icon(CupertinoIcons.cloud_rain_fill, color: Colors.blueGrey[300]);
      case < 800 : return Icon(Icons.cloudy_snowing, color: Colors.blue[100]);
      case 800 : return Icon(CupertinoIcons.sun_max_fill, color: Colors.yellow[200]);
      case <= 804 : return Icon(Icons.cloud, color: Colors.white);
      default : return Icon(CupertinoIcons.sun_max_fill, color: Colors.yellow[200]);
    }
  }
}