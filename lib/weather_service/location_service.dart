import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/constants.dart';
///Responsible for determining the device's current location and managing location services and permissions.
///The Location class uses the Geolocator package to handle location services.
class Location {
  Position? _position;
  String? latitude;
  String? longitude;
  bool? serviceEnabled;
  LocationPermission? permission;
  ///Determines the device's position.
  Future<void> determinePosition() async {
    bool execute = true;
    ///Retrieves last known position of the device if available.
    try  {
      _position = await Geolocator.getLastKnownPosition();
    }
    catch(e){
      _position = null;
    }
    if (_position == null) {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      /// Checks if location services are enabled.
      if (!serviceEnabled!) {
        execute = false;
      }
      ///Handles permission requests and checks if location services are enabled.
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          execute = false;
        }
      }
      ///Checks if location services are denied forever.
      if (permission == LocationPermission.deniedForever) {
        execute = false;
      }
    }
    if (execute) {
      _position = await Geolocator.getCurrentPosition();
    }
    latitude = _position?.latitude.toString();
    longitude = _position?.longitude.toString();
  }
  ///Displays error dialog with a custom message.
  void _showErrorDialog(BuildContext context, String titleText, String contentText) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              titleText,
              style: getMidText(context),
            ),
            content: Text(
              contentText,
              style: getLowText(context),
            ),
          );
        },
      );
    }
  }
  ///Decides which error dialog to display based on the current location service and permission status.
  void showProperDialog(BuildContext context) {
    if (_position == null) {
      if (serviceEnabled == false) {
        _showErrorDialog(context, "Can't access location", "Location services are disabled.");
      }
      else if (permission == LocationPermission.deniedForever) {
        _showErrorDialog(context, "Can't access location", "Location permissions are permanently denied, we cannot request permissions.");
      }
    }
  }
}
