import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
///Displays a box containing an icon, a title, and some content.
class DataBox extends StatelessWidget {
  const DataBox(
      {super.key,
        required this.icon,
        required this.title,
        required this.content,
        required this.iconColor});
  final IconData icon;
  final String title;
  final String content;
  final Color iconColor;
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.width / 3,
        decoration: BoxDecoration(
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
            ],
            borderRadius: BorderRadius.all(
                Radius.circular(MediaQuery.of(context).size.width / 15))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon,
                    color: iconColor,
                    size: MediaQuery.of(context).size.width / 15),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 70,
                ),
                Text(
                  title,
                  style: getUltraLowText(context),
                ),
              ],
            ),
            Text(
              content,
              style: getUltraLowText(context),
            )
          ],
        ),
      ),
    );
  }
}