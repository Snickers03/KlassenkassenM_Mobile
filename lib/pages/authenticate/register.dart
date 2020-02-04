import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:klassenk_mobile/services/authenticate.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register( {this.toggleView} );

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final formKey = GlobalKey<FormState>();

  String email;
  String password;
  String repeatPassword;
  String error = "";

  void submit() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      //print("email: $email");
      //print("password: $password");
      if (password != repeatPassword) {
        setState(() {
          error = "Passwörter stimmen nicht überein";   
        });
        return;
      }
      dynamic result = await _auth.registerEmail(email, password);
      if (result == null) {
        setState(() {
          error = "Ungültige E-Mail";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrieren"),
        backgroundColor: Colors.green,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Anmelden"),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child:
              /*RaisedButton(
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
        ),*/
              Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                        //onChanged: (val) {},
                        decoration: InputDecoration(
                          hintText: "E-Mail",
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (input) =>
                            input.length == 0 || !input.contains("@")
                                ? "Ungültige E-Mail"
                                : null,
                        onSaved: (input) => email = input,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        obscureText: true,
                        //onChanged: (val) {},
                        decoration: InputDecoration(
                          hintText: "Passwort",
                        ),
                        validator: (input) =>
                            input.length < 6 ? "Passwort muss mindestens 6 Zeichen haben" : null,
                        onSaved: (input) => password = input,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        obscureText: true,
                        //onChanged: (val) {},
                        decoration: InputDecoration(
                          hintText: "Passwort wiederholen",
                        ),
                        onSaved: (input) => repeatPassword = input,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                        child: Text("Registrieren"),
                        onPressed: () {
                          submit();
                        },
                      ),
                      SizedBox(height: 20,),
                      Text(error),
                    ],
                  ))),
    );
  }
}
