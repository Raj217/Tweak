import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:tweak/overlays/add_edit_tasks.dart';
import 'package:tweak/utils/constants.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:tweak/overlays/alert_dialog_box.dart';
import 'package:tweak/widgets/circular_progress_bar.dart';
import 'package:tweak/widgets/logo_and_app_name.dart';
import 'package:tweak/widgets/rounded_button.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:provider/provider.dart';
import 'package:tweak/utils/time.dart';
import 'package:tweak/utils/tasks_data.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static String id = 'Home Screen';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isApproved = false;
  String? alertBoxTextTitle;
  String? alertBoxTextContent;
  bool optionsType = true;
  List<TextButton>? actions;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    isRunning = Provider.of<Time>(context, listen: false).getIsRunning;
  }

  void startEndButtonOnPressed() {
    isApproved = true;
    if (isApproved) {
      setState(() {
        isApproved = false;
        isRunning = !isRunning;
        isRunning
            ? Provider.of<Time>(context, listen: false).startWorkTimer()
            : Provider.of<Time>(context, listen: false).endTimer();
      });
    }
  }

  void getValuesForAlertBox() {
    bool isEndable = Provider.of<Time>(context, listen: false).getIsEndable;
    if (!isEndable && isRunning) {
      alertBoxTextTitle = 'Warning';
      alertBoxTextContent =
          'You have not finished your minimum day limit so you cannot end it.';
      optionsType = false;
      actions = [
        TextButton(
          child: Text(
            'Ok',
            style: kInfoTextStyle.copyWith(color: kLightBlue),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ];
    } else {
      alertBoxTextTitle = 'Confirm';
      alertBoxTextContent =
          'Do you want to ${isRunning ? 'End' : 'Begin'} your day?';
      optionsType = true;
      actions = [
        TextButton(
          child: Text(
            'No',
            style: kInfoTextStyle.copyWith(color: kRed),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            'Yes',
            style: kInfoTextStyle.copyWith(color: kLightBlue),
          ),
          onPressed: () {
            if (!isRunning) {
              Provider.of<Tasks>(context, listen: false).deleteAllTasks();
            }
            Navigator.of(context).pop();
            startEndButtonOnPressed();
          },
        ),
      ];
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
                    Provider.of<Time>(context).getCurrentUserState,
                    style: kInfoTextStyle.copyWith(
                        fontSize: 30,
                        color: Provider.of<Time>(context)
                            .getCurrentUserStateColor),
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
                  GlowText(
                    'time waste: ${Provider.of<Time>(context).getTimeWaste} ',
                    style: kInfoTextStyle.copyWith(
                        color: Provider.of<Time>(context).getTimeWasteColor),
                  ),
                  const SizedBox(height: 20),
                  RoundedButton(
                    text: isRunning ? 'End' : 'Begin',
                    onPressed: () {
                      getValuesForAlertBox();
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialogBox(
                                textTitle: alertBoxTextTitle!,
                                textContent: alertBoxTextContent!,
                                actions: actions!);
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
                        onTap: () {
                          print(categories.sleep.toString());
                          if (isRunning) {
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
                child: Column(
                    children: Provider.of<Tasks>(context).getTasksInverted),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
