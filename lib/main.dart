import 'package:flutter/material.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/screens/loading_screen.dart';
import 'package:weather_app/screens/main_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

///The root widget of the application.
void main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.transparent,
            dividerTheme: DividerThemeData(color: kSilverGray, thickness: 3),
            drawerTheme: DrawerThemeData(),
            textSelectionTheme: TextSelectionThemeData(
                cursorColor: kDarkSteel,
                selectionHandleColor: kDarkSteel,
                selectionColor: kDarkSteel), dialogTheme: DialogTheme(backgroundColor: kUltraDark,)),
        initialRoute: MainScreen.pageKey,
        routes: {
          MainScreen.pageKey: (context) => LoadingScreen(),
        });
  }
}
