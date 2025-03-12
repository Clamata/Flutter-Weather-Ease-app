import 'dart:math';
import 'package:flutter/material.dart';
import 'package:weather_app/utils/day_utils.dart';
import 'package:weather_app/utils/weather_icon_utils.dart';
import '../utils/constants.dart';
///Weather data box displays the day, weather icon, and temperature range.
class WeatherDataBox extends StatelessWidget {
  const WeatherDataBox(
      {super.key, this.daysAhead = 0, required this.tempMax, required this.tempMin, required this.weatherId});
  ///daysAhead represents how many days ahead to show
  final int daysAhead;
  final String tempMax;
  final String tempMin;
  final int weatherId;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Container(
          width: MediaQuery.of(context).size.width / 5.0,
          height: MediaQuery.of(context).size.width / 5.2 * 1.4,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                  Radius.circular(MediaQuery.of(context).size.width / 15)),
              gradient: LinearGradient(
                  colors: [kSilverGray, kSteelBlue],
                  transform: GradientRotation(pi / 3),
                  stops: [0, 1]),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, 3))
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                DayUtils.get(daysAhead: daysAhead),
                style: getLowText(context),
              ),
              WeatherIconUtils.get(weatherId),
              Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/70),
                child: Text(
                  '$tempMax $tempMin',
                  style: getUltraLowText(context),
                ),
              )
            ],
          )),
    );
  }
}