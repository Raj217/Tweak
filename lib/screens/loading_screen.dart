import 'package:flutter/material.dart';
import 'package:tweak/utils/constants.dart';
import 'package:tweak/widgets/logo_and_app_name.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'package:tweak/utils/time.dart';
import 'package:tweak/utils/tasks_data.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);
  static String id = 'Loading Screen';

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    Provider.of<Time>(context, listen: false).readTime();
    Provider.of<Tasks>(context, listen: false).readTasks();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..addListener(() {
        setState(() {});
      });

    controller.forward().then((value) => Navigator.pushNamed(context, Home.id));
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDarkBlue,
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
              SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: kLightBlue,
                  value: controller.value,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
