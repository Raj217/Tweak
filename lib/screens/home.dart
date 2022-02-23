import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:tweak/screens/add_edit_tasks.dart';
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
  bool isApproved = false;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void button() {
    if (widget.isApproved) {
      setState(() {
        widget.isApproved = false;
        widget.isRunning = !widget.isRunning;
        widget.isRunning
            ? Provider.of<Time>(context, listen: false).startTimer()
            : Provider.of<Time>(context, listen: false).endTimer();
      });
    }
  }

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
                        .getCurrentUserState,
                    style: kInfoTextStyle.copyWith(fontSize: 30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GlowText(
                        'sleep: ${Provider.of<Time>(context).getTimeSleep} ',
                        style: kInfoTextStyle.copyWith(
                            color: Provider.of<Time>(context).getSleepColor),
                      ),
                      GlowText(
                        'rest: ${Provider.of<Time>(context).getTimeRest}',
                        style: kInfoTextStyle.copyWith(
                            color: Provider.of<Time>(context).getRestColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  RoundedButton(
                    text: widget.isRunning ? 'End' : 'Begin',
                    onPressed: () {
                      showDialog(
                          builder: (BuildContext context) {
                            return AlertDialog(
                                backgroundColor: kGrayBG,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                ),
                                title: Text('Confirm',
                                    style:
                                        kInfoTextStyle.copyWith(color: kWhite)),
                                content: Text(
                                    'Do you want to ${widget.isRunning ? 'End' : 'Begin'} your day?',
                                    style:
                                        kInfoTextStyle.copyWith(color: kWhite)),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text(
                                      'No',
                                      style:
                                          kInfoTextStyle.copyWith(color: kRed),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Yes',
                                      style: kInfoTextStyle.copyWith(
                                          color: kLightBlue),
                                    ),
                                    onPressed: () {
                                      widget.isApproved = true;
                                      if (!widget.isRunning) {
                                        Provider.of<Tasks>(context,
                                                listen: false)
                                            .deleteAllTasks();
                                      }
                                      Navigator.of(context).pop();
                                      button();
                                    },
                                  ),
                                ]);
                          },
                          context: context);
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
                        onTap: () {
                          if (widget.isRunning) {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) => AddEditTask(),
                            ).then((value) => {setState(() {})});
                          }
                        }),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Provider.of<Tasks>(context).nTasks > 0
                    ? kGrayTranslucentBG
                    : Colors.transparent,
                border: Border.all(
                  color: Provider.of<Tasks>(context).nTasks > 0
                      ? kGrayTranslucentText
                      : Colors.transparent,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(children: Provider.of<Tasks>(context).getTasks),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
