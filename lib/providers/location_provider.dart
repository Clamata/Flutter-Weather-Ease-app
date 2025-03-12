import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/utils/constants.dart';
/// Responsible for determining the device's current location and managing location utils and permissions.
/// The Location class uses the Geolocator package to handle location utils.
class LocationProvider extends ChangeNotifier  {
  Position? _position;
  bool _isDialogOpen = false;
  String? latitude;
  String? longitude;
  bool serviceEnabled = false;
  bool requested = false;
  LocationPermission? permission;
  int attempts = 0;
  // Determines the device's position.
  Future<bool> determinePosition(BuildContext context) async {
    // Retrieves last known position of the device if available.
    try  {
      _position = await Geolocator.getLastKnownPosition();
    }
    catch(e){
      _position = null;
    }
    if (_position == null) {
      // Checks if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled == false && context.mounted) {
        await _showErrorDialog(context, "Can't access location", "Location services are disabled.", settings: false);
        return false;
      }
      // Handles permission requests and checks if location utils are enabled.
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied){
        if(requested == false) {
          permission = await Geolocator.requestPermission();
          requested = true;
        }
        if (permission == LocationPermission.denied && context.mounted) {
          await _showErrorDialog(context, "Can't access location", "Location permissions are denied.");
          return false;
        }
      }
      if (permission == LocationPermission.deniedForever && context.mounted) {
        await _showErrorDialog(context, "Can't access location", "Location permissions are permanently denied, we cannot request permissions.");
        return false;
      }
      _position = await Geolocator.getCurrentPosition();
    }
    latitude = _position?.latitude.toString();
    longitude = _position?.longitude.toString();
    notifyListeners();
    return true;
  }

  // Displays error dialog with a custom message.
  Future<void> _showErrorDialog(BuildContext context, String titleText, String contentText,{bool settings = true}) async {
    if(_isDialogOpen) return;
    _isDialogOpen = true;
    if (context.mounted) {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text(
              titleText,
              style: getMidText(context),
            ),
            content: Text(
              contentText,
              style: getLowText(context),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.pop(dialogContext);
                    _isDialogOpen = false;
                    attempts++;
                    notifyListeners();
                  },
                  child: Icon(Icons.thumb_up)
              ),
              if(settings)
                TextButton(
                    onPressed: () async {
                      Geolocator.openAppSettings();
                    },
                    child: Icon(Icons.settings)
                )
            ],
          );
        },
      );
      _isDialogOpen = false;
    }
  }
}
