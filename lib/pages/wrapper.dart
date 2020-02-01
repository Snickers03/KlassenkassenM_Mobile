import 'package:flutter/material.dart';
import 'package:klassenk_mobile/pages/authenticate/auth_screen.dart';
import 'package:klassenk_mobile/pages/home.dart';
import 'package:provider/provider.dart';
import 'package:klassenk_mobile/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final user = Provider.of<User>(context);
    print("hello: $user");

    return user == null ? AuthScreen() : Home(); 
    
    //return Home();

  }
}