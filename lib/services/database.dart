import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:klassenk_mobile/models/student.dart';
import 'package:klassenk_mobile/models/user.dart';
import 'package:klassenk_mobile/models/payment.dart';
import 'package:provider/provider.dart';

class DatabaseService {

  final String uid;
  DatabaseService( {this.uid, this.user, this.student} );
  final User user;
  final Student student;
  //final List<Student> selectedStudents;     possible solution

  //collection reference
  final CollectionReference userCollection = Firestore.instance.collection("users");
  final CollectionReference studentCollection = Firestore.instance.collection("students");
  final CollectionReference paymentCollection = Firestore.instance.collection("payments");
  //final CollectionReference students = Firestore.instance.collection("students");

  Future updateUserData(String email) async {
    return await userCollection.document(uid).setData( {
      "email": email,
      //"students": students,
    });
  }

  Future updateStudentData(String name, String vorname, double balance, String userID) async {
    //print(this.uid);
    return await studentCollection.document(uid).setData({
      "name": name,
      "vorname": vorname,
      "balance": balance,
      "from": userID,
    });
  }

  // studentlist from snapshot
  List<Student> _studentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //print(doc.documentID);
      return Student(
        name: doc.data["name"] ?? "",
        vorname: doc.data["vorname"] ?? "",
        balance: (doc.data["balance"] ?? 0.0).toDouble(),
        studID: doc.documentID,
      );
    }).toList();
  }

  List<Payment> _paymentListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Payment(
        date: (doc.data["date"] ?? ""),
        reason: doc.data["reason"] ?? "",
        amount: (doc.data["amount"] ?? 0).toDouble(),
        );
    }).toList();
  }

  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  Stream<List<Student>> get students {
    //final user = Provider.of<User>(context);
    //print("why tho? $uid");
    //print(user.)
    return studentCollection
    .where("from", isEqualTo: user.uid)
    //.orderBy("name")
    .snapshots()
    .map(_studentListFromSnapshot);
  }

  Stream<List<Payment>> get payments {
    return paymentCollection
    //.where("from", isEqualTo: student.studID)   //law and order
    //.orderBy(field)
    .snapshots()
    .map(_paymentListFromSnapshot);
  }
}