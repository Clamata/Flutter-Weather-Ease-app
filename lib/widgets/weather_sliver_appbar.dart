import 'package:flutter/material.dart';
import 'package:weather_app/utils/day_utils.dart';
import '../utils/constants.dart';
///Custom SliverAppBar widget that displays weather information and city details.
class WeatherSliverAppbar extends StatelessWidget {
  const WeatherSliverAppbar({super.key, required this.cityName, required this.temp, required this.tempMin, required this.tempMax, required this.description,});
  final String cityName;
  final String temp;
  final String tempMin;
  final String tempMax;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      shadowColor: Colors.black,
      elevation: 10,
      forceElevated: true,
      backgroundColor: kDarkSteel,
      surfaceTintColor: Colors.transparent,
      ///Size of SliverAppBar depending on device width and image aspect ratio
      expandedHeight: MediaQuery.of(context).size.width / (213 / 167),
      pinned: true,
      title: Text(
        cityName,
        style: getMidText(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(DayUtils.getImage(),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.none,
                isAntiAlias: false),
            Align(
              alignment: Alignment(0.50, 0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width/2.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(temp,
                        style: getHighText(context).copyWith(height: MediaQuery.of(context).size.width/500)),
                    Text(description, style: getMidText(context)),
                    Divider(
                      thickness: MediaQuery.of(context).size.width/50,
                      color: Colors.white,
                    ),
                    Text('$tempMax/$tempMin', style: getMidText(context)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


