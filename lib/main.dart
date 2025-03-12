import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/screens/loading_screen.dart';
import 'package:weather_app/screens/main_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/providers/data_provider.dart';
import 'package:weather_app/providers/location_provider.dart';
import 'package:weather_app/providers/animation_provider.dart';

///The root widget of the application.
void main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DataProvider()),
        ChangeNotifierProvider(create: (context) => LocationProvider()),
        ChangeNotifierProvider(create: (context) => AnimationProvider(this))
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.transparent,
              dividerTheme: DividerThemeData(color: kSilverGray, thickness: 3),
              drawerTheme: DrawerThemeData(),
              textSelectionTheme: TextSelectionThemeData(
                  cursorColor: kDarkSteel,
                  selectionHandleColor: kDarkSteel,
                  selectionColor: kDarkSteel),
              dialogTheme: DialogTheme(
                backgroundColor: kUltraDark,
              )),
          initialRoute: MainScreen.pageKey,
          routes: {
            MainScreen.pageKey: (context) => LoadingScreen(),
          }),
    );
  }
}
