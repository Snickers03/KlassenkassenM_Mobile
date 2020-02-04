import 'package:flutter/material.dart';
import 'package:klassenk_mobile/services/authenticate.dart';
import 'package:klassenk_mobile/pages/home.dart';
import 'package:klassenk_mobile/pages/pay_table.dart';
import 'package:klassenk_mobile/pages/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:klassenk_mobile/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        initialRoute: '/wrapper',
        routes: {
          '/home': (context) => Home(),
          '/pay_table': (context) => PayTable(
                stud: null,
              ),
          '/wrapper': (context) => Wrapper(),
        },
      ),
    );
  }
}
