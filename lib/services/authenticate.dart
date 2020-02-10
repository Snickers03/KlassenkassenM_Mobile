import 'package:firebase_auth/firebase_auth.dart';
import 'package:klassenk_mobile/models/user.dart';
import 'package:klassenk_mobile/services/database.dart';
import 'package:klassenk_mobile/models/student.dart';

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
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _createUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future registerEmail(String email, String password) async {
    try {
      //List<Map> students = [{name: "test", vorname: "vortest", balance: 40 }];
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid).updateUserData(email);
      return _createUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
