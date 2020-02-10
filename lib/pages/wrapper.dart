import 'package:flutter/material.dart';
import 'package:klassenk_mobile/pages/authenticate/auth_screen.dart';
import 'package:klassenk_mobile/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:klassenk_mobile/models/user.dart';
import 'package:klassenk_mobile/models/student.dart';
import 'package:klassenk_mobile/services/database.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user != null) {
      print("hello: ${user.uid}");
    }

    return user == null ? AuthScreen() : StreamProvider<List<Student>>.value(
      value: DatabaseService().students,
      child: Home(user: user)); //display authenticate or home
  }
}
