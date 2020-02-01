import 'package:firebase_auth/firebase_auth.dart';
import 'package:klassenk_mobile/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object
  User _createUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }
  
  Stream<User> get user {
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _createUser(user));   same thing
    .map(_createUser);
  }

  //anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _createUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}