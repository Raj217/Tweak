/// The main screen of TWEAK

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intl/intl.dart';
import 'package:tweak/classes/categories.dart';
import 'package:tweak/classes/category.dart';
import 'package:tweak/overlays/add_edit_tasks.dart';
import 'package:tweak/utils/constants.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:tweak/overlays/alert_dialog_box.dart';
import 'package:tweak/widgets/circular_progress_bar.dart';
import 'package:tweak/widgets/custom_drop_down.dart';
import 'package:tweak/widgets/logo_and_app_name.dart';
import 'package:tweak/widgets/rounded_button.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:provider/provider.dart';
import 'package:tweak/classes/tasks_data.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static String id = 'Home Screen';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  /// Title of the alertBox overlay
  String? alertBoxTextTitle;

  /// Description of the alertBox overlay
  String? alertBoxTextDesc;

  /// The buttons on the alertBox overlay
  List<TextButton>? actions;

  /// Is work timer running?
  bool isRunning = false;

  /// The current task category which is shown below the circular progress bar
  String taskCategory = 'sleep prev night';

  /// Start or Ended date time at the top;
  String startEndDateTime = '';

  // ------------------------------- Overriding -------------------------------
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    initData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    // Provider.of<Categories>(context, listen: false).saveCategories();

    /// If inactive close the app
    /*
    if (state == AppLifecycleState.inactive) {
      Navigator.pop(context);
    }
     */
    if (state == AppLifecycleState.resumed) {
      await Provider.of<Categories>(context, listen: false).readCategories();
      initData();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  // ----------------------------- Helper functions -----------------------------

  // ------------------------------- Edit data -------------------------------

  void initData() {
    /// Initialize data and start appropriate timer
    isRunning = Provider.of<Categories>(context, listen: false)
        .getCategories['work']!
        .isRunning;

    String tempCat = 'work';
    if (!isRunning) {
      tempCat = 'sleep prev night';
    }

    /// Start work/sleep prev night timer, whichever one was running before closing the app
    Provider.of<Categories>(context, listen: false)
        .getCategories[tempCat]!
        .startTimerBool();
    Provider.of<Categories>(context, listen: false)
        .getCategories[tempCat]!
        .startTimer(func: () {
      setState(() {});
    });
    _getStartEndDateTime();
  }

  void continueDay() {
    /// If the time of sleeping is very less then you may continue the day
    setState(() {
      isRunning = !isRunning;
      Provider.of<Categories>(context, listen: false).readCategories();
      Provider.of<Tasks>(context, listen: false).readTasks();
      Provider.of<Categories>(context,
              listen:
                  false) //  the sleep time will be added to the current day sleep
          .getCategories['sleep current day']!
          .addTime(
              dt: Provider.of<Categories>(context, listen: false)
                  .getCategories['sleep prev night']!
                  .getTimePassed);
      Provider.of<Categories>(context, listen: false).toggleCategories(
          cat1: 'work',
          cat2: 'sleep prev night',
          resetTime2: true,
          startTimerFunc: () {
            setState(() {});
          });
    });
  }

  void startEndButtonOnPressed() {
    /// Handles the functionality of the start/end button

    isRunning = !isRunning;
    bool resetTime1 = false;
    bool resetTime2 = false;
    if (isRunning) {
      resetTime1 = true;
      Provider.of<Categories>(context, listen: false).resetAllTime();
    } else {
      resetTime2 = true;
    }
    Provider.of<Categories>(context, listen: false).toggleCategories(
        cat1: 'work',
        cat2: 'sleep prev night',
        startTimerFunc: () {
          setState(() {});
        },
        resetTime1: resetTime1,
        resetTime2: resetTime2);
  }

  void getValuesForAlertBox() {
    bool isEndable = Provider.of<Categories>(context, listen: false)
        .getCategories['work']!
        .didExceed(dirnUp: false);

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
          style: kInfoTextStyle.copyWith(color: kBaseColor),
        ),
        onPressed: () {
          if (!isRunning) {
            Provider.of<Tasks>(context, listen: false).deleteAllTasks();
          }
          Provider.of<Categories>(context, listen: false).saveBeginTimeData();
          Navigator.of(context).pop();
          startEndButtonOnPressed();
        },
      ),
    ];
    if (isEndable && isRunning) {
      alertBoxTextTitle = 'Warning';
      alertBoxTextDesc =
          'You have not finished your minimum day limit so you cannot end it.';
    } else if (!isRunning &&
        !Provider.of<Categories>(context, listen: false)
            .getCategories['sleep prev night']!
            .didExceed(dirnUp: false)) {
      alertBoxTextTitle = 'Note';
      alertBoxTextDesc =
          'Since you have slept very little so your day was continued';
    } else {
      alertBoxTextTitle = 'Confirm';
      alertBoxTextDesc =
          'Do you want to ${isRunning ? 'End' : 'Begin'} your day?';
    }
  }

  void _getStartEndDateTime() {
    /// Returns when the day was started / ended

    startEndDateTime = DateFormat('hh:mm:ss (MMM d, yy)')
        .format(
            Provider.of<Categories>(context, listen: false).getBeginDateTime)
        .toString();
  }

  // ------------------------------- Return data -------------------------------
  List<DropdownMenuItem<String>> getCategoriesData() {
    /// Gets the category data i.e. each category, their appropriate color and
    /// time invested on them

    List<DropdownMenuItem<String>> items = [];
    Map<String, Category> categories =
        Provider.of<Categories>(context).getCategories;

    for (int i = 1; i < categories.keys.length; i++) {
      String cat = categories.keys.elementAt(i);
      items.add(
        DropdownMenuItem(
          alignment: Alignment.center,
          child: Text(
            '$cat : ${categories[cat]!.getTimeFormatted()}',
            style: kInfoTextStyle.copyWith(
                color: categories[cat]!.getCategoryColor),
          ),
          value: cat,
          onTap: () {
            taskCategory = cat;
          },
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    /// Without this hero animation doesn't work
    timeDilation = 2;

    return Scaffold(
      backgroundColor: kDarkBackgroundColor,
      appBar: AppBar(
        backgroundColor: kDarkBackgroundColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Hero(tag: 'Logo&AppName', child: logoAndAppName(fontSize: 23)),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GlowText(
                    isRunning
                        ? 'Started: ' + startEndDateTime
                        : 'Ended: ' + startEndDateTime,
                    style: kInfoTextStyle.copyWith(
                        color: Provider.of<Categories>(context)
                            .getCurrentUserStateColor),
                  ),
                  const SizedBox(height: 20),
                  CircularProgressBar(radius: 220),
                  const SizedBox(height: 20),
                  GlowText(
                    /// What are you doing now?
                    Provider.of<Categories>(context).getCurrentUserState,
                    style: kInfoTextStyle.copyWith(
                        fontSize: 30,
                        color: Provider.of<Categories>(context)
                            .getCategories[Provider.of<Categories>(context)
                                .getCurrentUserState]!
                            .getCategoryColor),
                  ),
                  Row(
                    /// Select the category to see how much you invested on each
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomDropDown(
                        onChanged: (val) {
                          taskCategory = val as String;
                          setState(() {});
                        },
                        items: getCategoriesData(),
                        val: taskCategory,
                      ),
                    ],
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

                                /// The confirmation and notice overlay
                                textTitle: alertBoxTextTitle!,
                                textContent: alertBoxTextDesc!,
                                actions: actions!);
                          }).then((_) {
                        setState(() {
                          _getStartEndDateTime();
                        });
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
              /// Tracked List
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
                padding: const EdgeInsets.all(20.0),
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
