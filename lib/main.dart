/// TWEAK
/// v: 0.0.0
///
/// Made by: Rajdristant Ghose
///
/// This app helps in tracking your day to day activities and helping you analyze
/// where you used your time, to manage your time in a better manner

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tweak/utils/constants.dart';
import 'screens/home.dart';
import 'screens/loading_screen.dart';
import 'package:provider/provider.dart';
import 'classes/tasks_data.dart';
import 'classes/categories.dart';

void main() {
  runApp(const Tweak());
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: kDarkBackgroundColor,
      systemNavigationBarColor: kDarkBackgroundColor,
    ),
  );
}

class Tweak extends StatelessWidget {
  const Tweak({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => Tasks()),
        ChangeNotifierProvider(create: (BuildContext context) => Categories())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        initialRoute: LoadingScreen.id,
        routes: {
          LoadingScreen.id: (context) => LoadingScreen(),
          Home.id: (context) => const Home(),
        },
      ),
    );
  }
}
