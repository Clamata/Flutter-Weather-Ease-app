import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/utils/constants.dart';
import '../providers/data_provider.dart';

class WeatherDrawer extends StatelessWidget {
  const WeatherDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [kDarkSteel, kSteelBlue],
              transform: GradientRotation(pi / 4))),
      child: Drawer(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          child: ListView(children: [
            DrawerHeader(
                child: Icon(
                  Icons.cloud,
                  size: MediaQuery.of(context).size.width / 5,
                )),
            DropdownMenu<Units>(
              dropdownMenuEntries: Units.values
                  .map((unit) => DropdownMenuEntry<Units>(
                  value: unit,
                  label: unit.key,
                  style: MenuItemButton.styleFrom(textStyle: getLowText(context))))
                  .toList(),
              leadingIcon: Icon(
                Icons.thermostat,
              ),
              textStyle: getLowText(context),
              hintText: 'Unit',
              inputDecorationTheme: InputDecorationTheme(
                  hintStyle: getLowText(context),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent))),
              onSelected: (value) async {
                await context.read<DataProvider>().setUnit(value!.value);
              },
            ),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text(
                'About',
                style: getLowText(context),
              ),
              onTap: () {
                showDialog(context: context, builder: (context) {
                  return AboutDialog(
                    applicationIcon: Image.asset('images/icon.png', scale: 12,),
                    applicationVersion: '1.0.0+1',
                    applicationName: 'WeatherEase',
                    applicationLegalese: 'Licensed under MIT License.',
                  );
                },);
              },
            )
          ])),
    );
  }
}

