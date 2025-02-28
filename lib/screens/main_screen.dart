import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/widgets/weather_drawer.dart';
import 'package:weather_app/weather_service/data_fetcher_service.dart';
import 'package:weather_app/widgets/weather_sliverAppbar.dart';
import '../widgets/data_box.dart';
import '../widgets/weather_data_box.dart';
import '../widgets/divide_box.dart';
import '../widgets/search_box.dart';

class MainScreen extends StatefulWidget {
  static String pageKey = 'SecondPage';
  final DataFetcher dataFetcher;
  const MainScreen({super.key, required this.dataFetcher});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _textAnimationController;
  late AnimationController _textFieldAnimationController;
  double? alignAnimation;

  @override
  void initState() {
    super.initState();
    _textAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _textFieldAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 600));

    ///Triggers animations based on scroll position.
    _scrollController.addListener(() {
      if (!_scrollController.position.isScrollingNotifier.value) {
        return;
      }
      ///Defines horizontal axis of container.
      setState(() {
        alignAnimation = (_scrollController.position.pixels / MediaQuery.of(context).size.width * 3).clamp(0, 2) - 1;
      });
      ///Defines _textAnimationController value by horizontal axis of container.
      if (alignAnimation! >= 0.0) {
        _textAnimationController.forward();
      } else if (_textAnimationController.isForwardOrCompleted) {
        _textAnimationController.reverse();
      }
      ///Defines _textFieldAnimationController by scroll position.
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent / 1.28) {
        if (!_textFieldAnimationController.isCompleted) {
          _textFieldAnimationController.forward();
        }
      } else {
        _textFieldAnimationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _textAnimationController.dispose();
    _textFieldAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [kDarkSteel, kSteelBlue, kSilverGray],
              transform: GradientRotation(pi / 2),
              stops: [0, 0.6, 1])),
      child: Scaffold(
        drawer: WeatherDrawer(
          dataFetcher: widget.dataFetcher,
        ),
        body: CustomScrollView(
          controller: _scrollController,
          slivers: [
            ///Appbar with current weather data.
            WeatherSliverAppbar(
              cityName:
                  jsonDecode(widget.dataFetcher.currentData)['name'].toString(),
              temp: jsonDecode(widget.dataFetcher.currentData)['main']['temp'].round().toString(),
              tempMax: jsonDecode(widget.dataFetcher.data)['list'][1]['temp']['max'].round().toString(),
              tempMin: jsonDecode(widget.dataFetcher.data)['list'][1]['temp']['min'].round().toString(),
              description: jsonDecode(widget.dataFetcher.currentData)['weather'][0]['description'],
            ),
            SliverToBoxAdapter(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///Animated container indicating scroll position.
                Align(
                    alignment: Alignment(alignAnimation ?? -1, -1),
                    child: DivideBox()),
                SizedBox(
                  height: MediaQuery.of(context).size.width / 12,
                ),
                ///Animated weather description.
                SizeTransition(
                  sizeFactor: _textAnimationController,
                  child: FadeTransition(
                    opacity: _textAnimationController,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                            '${jsonDecode(widget.dataFetcher.currentData)['main']['temp'].round()}°',
                            style: getHighText(context).copyWith(height: 0.6)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                jsonDecode(widget.dataFetcher.currentData)['weather'][0]['description'],
                                style: getLowText(context)),
                            Text(
                              '${jsonDecode(widget.dataFetcher.data)['list'][1]['temp']['max'].round()}°/${jsonDecode(widget.dataFetcher.data)['list'][1]['temp']['min'].round()}° Feels like ${jsonDecode(widget.dataFetcher.currentData)['main']['feels_like'].round()}°',
                              style: getLowText(context),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.width / 16),
                ///Weather forecast for 8 days.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width / 16),
                    ...List.generate(
                      4,
                      (index) => WeatherDataBox(
                          daysAhead: index,
                          tempMin: jsonDecode(widget.dataFetcher.data)['list'][index]['temp']['min'].round(),
                          tempMax: jsonDecode(widget.dataFetcher.data)['list'][index]['temp']['max'].round(),
                          weatherId: jsonDecode(widget.dataFetcher.data)['list'][index]['weather'][0]['id']),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 16),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.width / 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width / 16),
                    ...List.generate(
                      4,
                      (index) => WeatherDataBox(
                          daysAhead: index + 4,
                          tempMin: jsonDecode(widget.dataFetcher.data)['list'][index + 4]['temp']['min'].round(),
                          tempMax: jsonDecode(widget.dataFetcher.data)['list'][index + 4]['temp']['max'].round(),
                          weatherId: jsonDecode(widget.dataFetcher.data)['list'][index + 4]['weather'][0]['id']),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 16),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width / 8),
                  child: Center(child: DivideBox(shadow: true)),
                ),
                ///Displays weather details - humidity, pressure, wind speed and visibility.
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width / 8),
                    DataBox(icon: Icons.water_drop,title: 'Humidity', iconColor: Colors.blue,content: '${jsonDecode(widget.dataFetcher.currentData)['main']['humidity']} %',),
                    SizedBox(width: MediaQuery.of(context).size.width / 16),
                    DataBox(icon: Icons.compress, title: 'Pressure', iconColor: Colors.pink, content: '${(jsonDecode(widget.dataFetcher.currentData)['main']['pressure'] ?? 0 )*0.75006.round()} mmHg',),
                    SizedBox(width: MediaQuery.of(context).size.width / 8),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.width / 16),
                Row(
                  children: [
                    SizedBox(width: MediaQuery.of(context).size.width / 8),
                    DataBox(icon: Icons.air, iconColor: Colors.white, title: 'Wind', content: '${(jsonDecode(widget.dataFetcher.currentData)['wind']['speed']*3.6).round()} km/h',),
                    SizedBox(width: MediaQuery.of(context).size.width / 16),
                    DataBox(icon: Icons.visibility, iconColor: Colors.greenAccent, title: 'Visibility', content: '${(jsonDecode(widget.dataFetcher.currentData)['visibility'] ?? 0) / 1000} m',),
                    SizedBox(width: MediaQuery.of(context).size.width / 8),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.width / 8),
                ///Animated text field allowing to search cities for weather forecast.
                AnimatedBuilder(
                    animation: _textFieldAnimationController,
                    builder: (context, child) {
                      double animatedWidth = Tween<double>(
                        begin: 0,
                        end: MediaQuery.of(context).size.width / 1.4,
                      ).evaluate(_textFieldAnimationController);
                      return SearchBox(
                        width: animatedWidth,
                        dataFetcher: widget.dataFetcher,
                        city: jsonDecode(widget.dataFetcher.currentData)['name'],
                      );
                    }),
                SizedBox(height: MediaQuery.of(context).size.width / 8),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
