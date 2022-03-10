/// This is the first screen on opening the app.
/// Just shows a simple loading screen and a basic animation.
///
/// NOTE: The duration is constant as for this version

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tweak/classes/categories.dart';
import 'package:tweak/utils/constants.dart';
import 'package:tweak/widgets/logo_and_app_name.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'package:tweak/classes/tasks_data.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({Key? key}) : super(key: key);
  static String id = 'Loading Screen';

  // Constant values
  final int loadingScreenWaitTime = 2100; // In microseconds

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    // Read the previous task and time spent which were stored before closing
    Provider.of<Categories>(context, listen: false).readCategories();
    Provider.of<Tasks>(context, listen: false).readTasks();

    controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.loadingScreenWaitTime))
      ..addListener(() {
        setState(() {});
      });

    controller
        .forward()
        .then((value) => Navigator.pushNamed(context, Home.id).then((value) {
              exit(0); // Exit the app
            }));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: "Logo&AppName",
                child: logoAndAppName(
                  iconSize: 38,
                  spaceBetween: 10,
                  fontSize: 40,
                ),
              ),
              const SizedBox(height: 30),
              const SizedBox(
                height: 30,
                width: 30,
                child: SpinKitPouringHourGlass(
                  color: kBaseColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
