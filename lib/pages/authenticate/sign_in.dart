import 'package:flutter/material.dart';
import 'package:klassenk_mobile/authenticate/authenticate.dart';
import 'package:klassenk_mobile/pages/home.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anmelden"),
        backgroundColor: Colors.green,
      ),
      body: Center( 
        child: RaisedButton(
          child: Text("Als Gast anmelden"),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if (result == null) {
              print("errör beim anmöldön");
            }
            else {
              print("angemeldet");
              print("User: ${result.uid}");
            }
          },
        ),
      ),
    );
  }
}