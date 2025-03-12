import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/providers/animation_provider.dart';
import 'package:weather_app/widgets/weather_drawer.dart';
import 'package:weather_app/providers/data_provider.dart';
import 'package:weather_app/widgets/weather_sliver_appbar.dart';
import '../widgets/data_box.dart';
import '../widgets/weather_data_box.dart';
import '../widgets/divide_box.dart';
import '../widgets/search_box.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});
  static String pageKey = 'SecondPage';

  @override
  Widget build(BuildContext context) {
    // Container providing gradient background.
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [kDarkSteel, kSteelBlue, kSilverGray],
          transform: GradientRotation(pi / 2),
          stops: [0, 0.6, 1],
        ),
      ),
      child: Scaffold(
        drawer: WeatherDrawer(),
        body: CustomScrollView(
          controller: context.watch<AnimationProvider>().scrollController,
          slivers: [
            Consumer<DataProvider>(
              builder: (context, dataProvider, child) {
                return WeatherSliverAppbar(
                  cityName: dataProvider.city ?? 'Unknown',
                  temp: dataProvider.tempCurrent,
                  tempMax: dataProvider.tempMax[0],
                  tempMin: dataProvider.tempMin[0],
                  description: dataProvider.description,
                );
              },
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Animated container indicating scroll position.
                  Align(
                    alignment: Alignment(context.watch<AnimationProvider>().updateScreenWidthAndGetAlignment(MediaQuery.of(context).size.width), -1),
                    child: DivideBox(),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width / 12),
                  // Animated weather description.
                  SizeTransition(
                    sizeFactor: context.watch<AnimationProvider>().textAnimationController,
                    child: FadeTransition(
                      opacity: context.watch<AnimationProvider>().textAnimationController,
                      child: Consumer<DataProvider>(
                        builder: (context, dataProvider, child) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dataProvider.tempCurrent,
                                style: getHighText(context).copyWith(height: 0.6),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dataProvider.description,
                                    style: getLowText(context),
                                  ),
                                  Text(
                                    '${dataProvider.tempMax[0]}/${dataProvider.tempMin[0]} Feels like ${dataProvider.feelsLike}',
                                    style: getLowText(context),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width / 16),
                  //Weather forecast for the next 4 days displayed in the first row.
                  Consumer<DataProvider>(
                    builder: (context, dataProvider, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width / 16),
                          ...List.generate(
                            4,
                                (index) => WeatherDataBox(
                              daysAhead: index,
                              tempMin: dataProvider.tempMin[index],
                              tempMax: dataProvider.tempMax[index],
                              weatherId: dataProvider.weatherId[index],
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width / 16),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width / 16),
                  // Weather forecast for the next 4 days displayed in the second row.
                  Consumer<DataProvider>(
                    builder: (context, dataProvider, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width / 16),
                          ...List.generate(
                            4,
                                (index) => WeatherDataBox(
                              daysAhead: index + 4,
                              tempMin: dataProvider.tempMin[index + 4],
                              tempMax: dataProvider.tempMax[index + 4],
                              weatherId: dataProvider.weatherId[index + 4],
                            ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width / 16),
                        ],
                      );
                    },
                  ),
                  // A dividing box
                  Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width / 8),
                    child: Center(child: DivideBox(shadow: true)),
                  ),
                  // Weather details in the first row.
                  Consumer<DataProvider>(
                    builder: (context, dataProvider, child) {
                      return Row(
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width / 8),
                          DataBox(
                            icon: Icons.water_drop,
                            title: 'Humidity',
                            iconColor: Colors.blue,
                            content: dataProvider.humidity,
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width / 16),
                          DataBox(
                            icon: Icons.compress,
                            title: 'Pressure',
                            iconColor: Colors.pink,
                            content: dataProvider.pressure,
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width / 8),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width / 16),
                  // Weather details in the second row.
                  Consumer<DataProvider>(
                    builder: (context, dataProvider, child) {
                      return Row(
                        children: [
                          SizedBox(width: MediaQuery.of(context).size.width / 8),
                          DataBox(
                            icon: Icons.air,
                            iconColor: Colors.white,
                            title: 'Wind',
                            content: dataProvider.wind,
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width / 16),
                          DataBox(
                            icon: Icons.visibility,
                            iconColor: Colors.greenAccent,
                            title: 'Visibility',
                            content: dataProvider.visibility,
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width / 8),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width / 8),
                  //Animated text field allowing users to search for weather forecast in specified city.
                  AnimatedBuilder(
                    animation: context.watch<AnimationProvider>().textFieldAnimationController,
                    builder: (context, child) {
                      double animatedWidth = Tween<double>(
                        begin: 0,
                        end: MediaQuery.of(context).size.width / 1.4,
                      ).evaluate(context.watch<AnimationProvider>().textFieldAnimationController);
                      return SearchBox(width: animatedWidth);
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.width / 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}