import 'package:flutter/material.dart';
/// A collection of constants and helper functions used for styling and managing units in the app.
const kSteelBlue = Color(0xFF25556E);
const kDarkSteel = Color(0xFF1A3C4D);
const kSilverGray = Color(0xFF5F737D);
const kBrown = Color(0xFF663443);
const kUltraDark = Color(0xFF14161F);

enum Units {
  celsius('Celsius', 'metric'),
  fahrenheit('Fahrenheit','imperial');

  final String key;
  final String value;
  const Units(this.key,this.value);
}

TextStyle getHighText(BuildContext context, {Color color = Colors.white}) {
  double size = (MediaQuery.of(context).size.width) * 0.15;
  return TextStyle(fontSize: size, fontFamily: 'Minecraft', color: color);
}

TextStyle getMidText(BuildContext context, {Color color = Colors.white}) {
  double size = (MediaQuery.of(context).size.width) * 0.07;
  return TextStyle(fontSize: size, fontFamily: 'Minecraft', color: color);
}

TextStyle getLowText(BuildContext context, {Color color = Colors.white}) {
  double size = (MediaQuery.of(context).size.width) * 0.05;
  return TextStyle(fontSize: size, fontFamily: 'Minecraft', color: color);
}

TextStyle getUltraLowText(BuildContext context, {Color color = Colors.white}) {
  double size = (MediaQuery.of(context).size.width) * 0.045;
  return TextStyle(fontSize: size, fontFamily: 'Minecraft', color: color);
}