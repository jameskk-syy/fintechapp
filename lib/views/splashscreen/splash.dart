import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/views/homescreen/home_screen.dart';
import 'package:saccoapp/views/login/login.dart';
import 'package:saccoapp/views/splashscreen/bloc/spash_screen_bloc.dart';

class SplashScreen extends StatefulWidget {
 SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
final SpashScreenBloc splashScreenBloc = SpashScreenBloc();

   @override
  void initState() {
    splashScreenBloc.add(SpashScreenInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: BlocConsumer<SpashScreenBloc, SpashScreenState >(
       bloc: splashScreenBloc,
        buildWhen: (previous, current) => current is! SplashScreenActionState,
        listenWhen: (previous, current) => current is SplashScreenActionState,
        listener: (context, state) {
          if (state is SplashScreenLoaded) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          } else if (state is SplashScreenError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                SizedBox(height: 50),
                Flexible(
                  flex: 2,
                  child: Center(
                    child: Image.asset(
                      'assets/image_onboarding.png',
                      width: 355,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  flex: 3,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: greenColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Manage Your Finance Easily!',
                                  textStyle: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  speed: Duration(milliseconds: 40),
                                ),
                              ],
                              totalRepeatCount: 1,
                              isRepeatingAnimation: false,
                              displayFullTextOnTap: true,
                              stopPauseOnTap: true,
                            ),
                            SizedBox(height: 10),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            //   child: Text(
                            //     'Manage your savings and loans easily with our simple and secure mobile app.',
                            //     style: TextStyle(
                            //       fontSize: 16,
                            //       color: Colors.white70,
                            //     ),
                            //     textAlign: TextAlign.center,
                            //   ),
                            // ),
                            AnimatedTextKit(
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  'Manage your savings and loans easily with our simple and secure mobile app.',
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70,
                                  ),
                                  speed: Duration(milliseconds: 40),
                                ),
                              ],
                              totalRepeatCount: 1,
                              isRepeatingAnimation: false,
                              displayFullTextOnTap: true,
                              stopPauseOnTap: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
