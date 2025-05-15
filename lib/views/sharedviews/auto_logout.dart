import 'dart:async';
import 'package:flutter/material.dart';
import 'package:saccoapp/views/login/login.dart';

class AutoLogoutWrapper extends StatefulWidget {
  final Widget child;

  const AutoLogoutWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _AutoLogoutWrapperState createState() => _AutoLogoutWrapperState();
}

class _AutoLogoutWrapperState extends State<AutoLogoutWrapper> with WidgetsBindingObserver {
  Timer? _inactivityTimer;
  final Duration _timeout = Duration(minutes: 5);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _resetInactivityTimer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(_timeout, _showLogoutDialog);
  }

  void _showLogoutDialog() {
    if (!mounted || Localizations.of<MaterialLocalizations>(context, MaterialLocalizations) == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Inactive'),
        content: Text('You have been inactive. Do you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetInactivityTimer();
            },
            child: Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _logoutUser();
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _logoutUser() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _inactivityTimer?.cancel();
      _inactivityTimer = Timer(_timeout, () {
        if (mounted) _logoutUser();
      });
    } else if (state == AppLifecycleState.resumed) {
      _resetInactivityTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _resetInactivityTimer(),
      behavior: HitTestBehavior.translucent,
      child: widget.child,
    );
  }
}
