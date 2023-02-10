import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../app_theme.dart';
import 'component/time.dart';
import 'component/wire_draw.dart';

import '../constants/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Offset initialPosition = const Offset(250, 0);
  Offset switchPosition = const Offset(350, 350);
  Offset containerPosition = const Offset(350, 350);
  Offset finalPosition = const Offset(350, 350);

  @override
  void didChangeDependencies() {
    final Size size = MediaQuery.of(context).size;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    initialPosition = Offset(size.width * .9, 0);
    containerPosition = Offset(size.width * .9, size.height * .4);
    finalPosition = Offset(size.width * .9, size.height * .5 - size.width * .1);

    switchPosition =
        themeProvider.isLightTheme ? containerPosition : finalPosition;

    super.didChangeDependencies();
  }

  String hours = '';
  String minutes = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        hours = DateFormat('HH').format(DateTime.now());
        minutes = DateFormat('mm').format(DateTime.now());
      });
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.8, -0.3),
            radius: 1,
            colors: themeProvider.themeMode().gradientColors!,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            leftPart(context, size, themeProvider),
            Positioned(
              top: containerPosition.dy - size.width * .1 / 2 - 5,
              left: containerPosition.dx - size.width * .1 / 2 - 5,
              child: Container(
                width: size.width * .1 + 10,
                height: size.height * .1 + 10,
                decoration: BoxDecoration(
                  color: themeProvider.themeMode().switchBgColor!,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Wire(
              initialPosition: initialPosition,
              toOffset: switchPosition,
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 0),
              top: switchPosition.dy - size.width * 0.1 / 2,
              left: switchPosition.dx - size.width * 0.1 / 2,
              child: Draggable(
                feedback: Container(
                  width: size.width * .1,
                  height: size.width * .1,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
                onDragEnd: (details) {
                  if (themeProvider.isLightTheme) {
                    setState(() {
                      switchPosition = containerPosition;
                    });
                  } else {
                    setState(() {
                      switchPosition = finalPosition;
                    });
                  }
                  themeProvider.toggleThemeData();
                },
                onDragUpdate: (details) {
                  setState(() {
                    switchPosition = details.localPosition;
                  });
                },
                child: Container(
                  width: size.width * .1,
                  height: size.width * .1,
                  decoration: BoxDecoration(
                    color: themeProvider.themeMode().thumbColor,
                    border: Border.all(
                        width: 5,
                        color: themeProvider.themeMode().switchColor!),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  SafeArea leftPart(
      BuildContext context, Size size, ThemeProvider themeProvider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hours,
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(
              width: size.width * .2,
              child: const Divider(
                height: 0,
                thickness: 1,
                color: AppColors.white,
              ),
            ),
            Text(
              minutes,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color: AppColors.white,
                  ),
            ),
            const Spacer(),
            const Text(
              "Light Dark\nPersonal\nSwitch",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Container(
              width: size.width * .2,
              height: size.width * .2,
              decoration: BoxDecoration(
                color: themeProvider.themeMode().switchColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.nights_stay_outlined,
                size: 50,
                color: AppColors.white,
              ),
            ),
            SizedBox(
              width: size.width * .2,
              child: const Divider(
                // height: 0,
                thickness: 1,
                color: AppColors.white,
              ),
            ),
            Text(
              "30\u00B0C",
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: AppColors.white,
                  ),
            ),
            Text(
              "Clear",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              DateFormat('EEEE').format(DateTime.now()),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              DateFormat('MMMM d').format(DateTime.now()),
              style: Theme.of(context).textTheme.titleLarge,
            )
          ],
        ),
      ),
    );
  }
}
