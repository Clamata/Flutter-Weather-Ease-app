import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
///Responsible for retrieving weather data.
class DataProvider extends ChangeNotifier{
  String unit = 'metric';
  String? currentData;
  String? data;
  final String currentWeatherUrl = 'https://api.openweathermap.org/data/2.5/weather?'; // Current weather forecast
  final String weatherUrl = 'https://api.openweathermap.org/data/2.5/forecast/daily?cnt=8&'; // Weather forecast for 8 days
  String? longitude;
  String? latitude;

  List<String>tempMin = List.filled(8, '0°');
  List<String>tempMax = List.filled(8, '0°');
  List<int>weatherId = List.filled(8, 200);
  late String tempCurrent;
  String? city;
  late String humidity;
  late String pressure;
  late String wind;
  late String visibility;
  late String feelsLike;
  late String description;

  Future<void> setUnit(String unit) async {
    this.unit = unit;
    await fetchData();
  }
  Future<void> setCity(String city) async {
    this.city = city;
    longitude = null;
    latitude = null;
    await fetchData();

  }
  String? appid = dotenv.env['OPENWEATHER_API_KEY'];
  Future<void> fetchData({String? longitude, String? latitude}) async {
    if (longitude != null && latitude != null) {
      http.Response response = await http.get(Uri.parse(
          '${currentWeatherUrl}lat=$latitude&lon=$longitude&units=$unit&appid=$appid'));
      if (response.statusCode == 200) {
      currentData = response.body;
      }
      response = await http.get(Uri.parse(
          '${weatherUrl}lat=$latitude&lon=$longitude&units=$unit&appid=$appid'));
      if (response.statusCode == 200) {
      data = response.body;
      }
    }
    else {
      city ??= 'London';
      http.Response response = await http.get(
          Uri.parse('${currentWeatherUrl}q=$city&units=$unit&appid=$appid'));
      if (response.statusCode == 200) {
      currentData = response.body;
      }
      response = await http
          .get(Uri.parse('${weatherUrl}q=$city&units=$unit&appid=$appid'));
      if (response.statusCode == 200) {
      data = response.body;
      }
    }
    _updateData();
  }
  void _updateData() {
    if (currentData != null) {
      tempCurrent =
          '${jsonDecode(currentData!)['main']['temp'].round()}°';
      city = jsonDecode(currentData!)['name'].toString() ;
      humidity = '${jsonDecode(currentData!)['main']['humidity']} %';
      pressure = '${(jsonDecode(currentData!)['main']['pressure'] * 0.75006)
          .round()} mmHg' ;
      wind =
          '${(jsonDecode(currentData!)['wind']['speed'] * 3.6).round()} km/h';
      visibility =
          '${jsonDecode(currentData!)['visibility'] / 1000} km';
      feelsLike =
          '${jsonDecode(currentData!)['main']['feels_like'].round()}°';
      description =
          jsonDecode(currentData!)['weather'][0]['description'];
    }
    else {
      tempCurrent = '0°';
      city = 'unknown';
      humidity = '0 %';
      pressure = '0 mmHg';
      wind = '0 km/h';
      visibility = '0 km';
      feelsLike = '0°';
      description = 'unknown';
    }
    if (data != null){
      for (int i = 0; i < 8; i++) {
        tempMin[i] = '${jsonDecode(data!)['list'][i]['temp']['min'].round()}°';
        tempMax[i] = '${jsonDecode(data!)['list'][i]['temp']['max'].round()}°';
        weatherId[i] = jsonDecode(data!)['list'][i]['weather'][0]['id'];
      }
    }
    else {
      for (int i = 0; i < 8; i++) {
        tempMin[i] = '0°';
        tempMax[i] = '0°';
        weatherId[i] = 200;
      }
    }
    notifyListeners();
  }
}
