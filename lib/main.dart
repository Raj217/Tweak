import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tweak/utils/constants.dart';
import 'screens/home.dart';
import 'screens/loading_screen.dart';
import 'package:provider/provider.dart';
import 'utils/time.dart';
import 'utils/tasks_data.dart';

void main() {
  runApp(const Tweak());
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: kDarkBlue,
      systemNavigationBarColor: kDarkBlue,
    ),
  );
}

class Tweak extends StatelessWidget {
  const Tweak({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => Time()),
        ChangeNotifierProvider(create: (BuildContext context) => Tasks()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        initialRoute: LoadingScreen.id,
        routes: {
          LoadingScreen.id: (context) => const LoadingScreen(),
          Home.id: (context) => const Home(),
        },
      ),
    );
  }
}
