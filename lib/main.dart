import 'package:flutter/material.dart';
import 'package:saccoapp/views/sharedviews/auto_logout.dart';
import 'package:saccoapp/views/splashscreen/splash.dart';

void main() {
  runApp(
    AutoLogoutWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    ),
  );
}
