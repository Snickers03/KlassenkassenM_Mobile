import 'package:flutter/material.dart';
import 'package:klassenk_mobile/pages/home.dart';
import 'package:klassenk_mobile/pages/pay_table.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
        '/pay_table': (context) => PayTable(stud: null,),
      },
));