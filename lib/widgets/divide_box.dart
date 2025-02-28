import 'package:flutter/material.dart';

class DivideBox extends StatelessWidget {
  const DivideBox({super.key, this.shadow = false});
  final bool shadow;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.width / 20,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.width / 15)),
          boxShadow: shadow ? [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 1,
                offset: Offset(0, 3))
          ] : []),
    );
  }
}