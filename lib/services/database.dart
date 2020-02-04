import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService( {this.uid} );

  //collection reference
  final CollectionReference users = Firestore.instance.collection("users");
  //final CollectionReference students = Firestore.instance.collection("students");

  Future updateUserData(String name, String vorname, double balance) async {
    return await users.document(uid).setData( {
      "name": name,
      "vorname": vorname,
      "balance": balance,
      //"students": students,
    });
  }
}