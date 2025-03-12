import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/screens/main_screen.dart';
import 'package:weather_app/providers/data_provider.dart';
import 'package:weather_app/providers/location_provider.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // While position isn't determined.
      while (context.mounted && await context.read<LocationProvider>().determinePosition(context) == false) {
        // Determine position.
        if(context.mounted) await context.read<LocationProvider>().determinePosition(context);
        // If there's more than 3 attempts to determine position, break.
        if(context.mounted && context.read<LocationProvider>().attempts >= 3){
          break;
        }
      }
      if (context.mounted) {
        String? latitude = context.read<LocationProvider>().latitude;
        String? longitude = context.read<LocationProvider>().longitude;
        await context
            .read<DataProvider>()
            .fetchData(latitude: latitude, longitude: longitude);
        if (context.mounted) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
        }
      }
    });

    return Scaffold(
      backgroundColor: kSteelBlue,
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 6.0,
          valueColor: AlwaysStoppedAnimation(Colors.white),
          backgroundColor: kDarkSteel,
        ),
      ),
    );
  }
}
