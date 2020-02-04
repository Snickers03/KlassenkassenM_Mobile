import 'package:flutter/material.dart';
import 'package:klassenk_mobile/services/authenticate.dart';
import 'package:klassenk_mobile/pages/home.dart';
import 'package:klassenk_mobile/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final formKey = GlobalKey<FormState>();

  String email;
  String password;
  String error = "";
  bool loading = false;

  void submit() async {
    if (formKey.currentState.validate()) {
      setState(() => loading = true);
      formKey.currentState.save();
      print("email: $email");
      print("password: $password");
      dynamic result = await _auth.signInEmail(email, password);
      if (result == null) {
        setState(() {
          loading = false;
          error = "E-Mail oder Passwort falsch";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text("Anmelden"),
        backgroundColor: Colors.green,
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Registrieren"),
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
                            input.length == 0 ? "Passwort benötigt" : null,
                        onSaved: (input) => password = input,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton(
                        child: Text("Anmelden"),
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
