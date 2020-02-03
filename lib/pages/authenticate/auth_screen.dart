import 'package:flutter/material.dart';
import 'package:klassenk_mobile/pages/authenticate/register.dart';
import 'package:klassenk_mobile/pages/authenticate/sign_in.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn == true ? SignIn(toggleView: toggleView) : Register(toggleView: toggleView);
  }
}