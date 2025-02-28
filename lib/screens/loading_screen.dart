import 'package:flutter/material.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/screens/main_screen.dart';
import 'package:weather_app/weather_service/data_fetcher_service.dart';
import 'package:weather_app/weather_service/location_service.dart';

class LoadingScreen extends StatefulWidget {
  static final String pageKey = 'firstPage';
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getCurrentPositionData();
  }
  ///Collects position data and data from API.
  void getCurrentPositionData() async {
    Location location = Location();
    await location.determinePosition().then((_) {
      if (mounted) {
        location.showProperDialog(context);
      }
    });
    DataFetcher dataFetcher = DataFetcher();
    dataFetcher.currentWeatherUrl = 'https://api.openweathermap.org/data/2.5/weather?';
    dataFetcher.weatherUrl = 'https://api.openweathermap.org/data/2.5/forecast/daily?cnt=8&';
    dataFetcher.city = 'London';
    dataFetcher.longitude = location.longitude;
    dataFetcher.latitude = location.latitude;
    await dataFetcher.fetchData();
    if (mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(
              dataFetcher: dataFetcher,
            ),
          ));
    }
  }

  ///Displays loading screen until data is collected.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSteelBlue,
      body: Center(child: CircularProgressIndicator(
        strokeWidth: 6.0,
        valueColor: AlwaysStoppedAnimation(Colors.white),
        backgroundColor: kDarkSteel,)),
    );
  }
}
