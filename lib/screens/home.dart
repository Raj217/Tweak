import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:tweak/utils/constants.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:tweak/widgets/circular_progress_bar.dart';
import 'package:tweak/widgets/logo_and_app_name.dart';
import 'package:tweak/widgets/rounded_button.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:provider/provider.dart';
import 'package:tweak/utils/time.dart';
import 'package:tweak/utils/tasks_data.dart';

class Home extends StatefulWidget {
  Home({Key? key, required this.isRunning}) : super(key: key);
  static String id = 'Home Screen';
  bool isRunning;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    timeDilation = 2;

    return Scaffold(
      backgroundColor: kDarkBlue,
      appBar: AppBar(
        backgroundColor: kDarkBlue,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Hero(tag: 'Logo&AppName', child: logoAndAppName(fontSize: 23)),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const CircularProgressBar(radius: 220),
                  const SizedBox(height: 20),
                  GlowText(
                    Provider.of<Time>(context, listen: false)
                        .getCurrentUserState, // TODO: Add dynamicity to task-working/resting/sleeping
                    style: kInfoTextStyle.copyWith(fontSize: 30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GlowText(
                        'sleep: ${Provider.of<Time>(context, listen: false).getTimeSleep} ', // TODO: Add dynamicity to time
                        style: kInfoTextStyle.copyWith(color: kGreen),
                      ),
                      GlowText(
                        'rest: ${Provider.of<Time>(context, listen: false).getTimeRest}', // TODO: Add dynamicity to time
                        style: kInfoTextStyle.copyWith(color: kGreen),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RoundedButton(
                    text: widget.isRunning ? 'End' : 'Begin',
                    onPressed: () {
                      setState(() {
                        widget.isRunning = !widget.isRunning;
                        widget.isRunning
                            ? Provider.of<Time>(context, listen: false)
                                .startTimer()
                            : Provider.of<Time>(context, listen: false)
                                .endTimer();
                      });
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width -
                            75), //75 = fontSize+right padding
                    child: GestureDetector(
                        child: GlowText('+',
                            textAlign: TextAlign.end,
                            style: kInfoTextStyle.copyWith(
                                fontSize: 55, height: 1.1)),
                        onTap: () {}),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kGrayTranslucentBG,
                border: Border.all(color: kGrayTranslucentText),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                    children:
                        Provider.of<Tasks>(context, listen: false).getTasks),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
