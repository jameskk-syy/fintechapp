import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:saccoapp/core/constants/theme.dart';
import 'package:saccoapp/core/httpInterceptor/shared_data.dart';
import 'package:saccoapp/views/homescreen/pages/account_screen.dart';
import 'package:saccoapp/views/homescreen/pages/dashboard.dart';
import 'package:saccoapp/views/homescreen/pages/profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String username = "James Maina"; 
  String greetings = "Good morning";// Replace with actual user name
  int _page = 0;
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [
    DashboardPage(),
    ProfilePage(),
    AccountScreen(),
  ];
  
 @override
 void initState() {
   super.initState();
   _initializeData();
 }
  Future<void> _initializeData() async {
    final now = DateTime.now();
    String timeGreeting;

    if (now.hour < 12) {
      timeGreeting = "Good morning";
    } else if (now.hour < 17) {
      timeGreeting = "Good afternoon";
    } else {
      timeGreeting = "Good evening";
    }

    final userData = await UserData.getUserData();
    final usernames = userData['name']!;
    print(usernames);
    setState(() {
      username = usernames;
      greetings = timeGreeting;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: _pages[_page],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        height: 60.0,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.person_outline, size: 30, color: Colors.white),
          Icon(Icons.settings, size: 30,color: Colors.white),
        ],
        color: greenColor,
        buttonBackgroundColor: Colors.amber[700],
        backgroundColor: whiteColor,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 300),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
    );
  }
}
