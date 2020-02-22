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

  Future updateStudentData(String uid, String name, String vorname, double balance, String userID) async {
    //print(this.uid);
    return await studentCollection.document(uid).setData({
      "name": name,
      "vorname": vorname,
      "balance": balance,
      "from": userID,
    });
  }

  Future updatePaymentData(DateTime date, String reason, double amount, List<String> selectedStudents) async {
    return await paymentCollection.document(uid).setData({
      //"date": FieldValue.serverTimestamp(),
      "date": date,
      "reason": reason,
      "amount": amount,
      "from": FieldValue.arrayUnion(selectedStudents),
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
        date: DateTime.parse(doc.data["date"].toDate().toString()),   //needs default value
        reason: doc.data["reason"] ?? "",
        amount: (doc.data["amount"] ?? 0).toDouble(),
        );
    }).toList();
  }

  Future deleteStudents() {
    
  }

  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  Stream<List<Student>> get students {
    return studentCollection
    .where("from", isEqualTo: user.uid)
    .snapshots()
    .map(_studentListFromSnapshot);
  }

  Stream<List<Payment>> get payments {
    //print("studID: ${student.studID}");
    return paymentCollection
    .where("from", arrayContains: student.studID)   //law and order
    .snapshots()
    .map(_paymentListFromSnapshot);
  }
}