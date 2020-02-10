import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:klassenk_mobile/models/student.dart';
import 'package:klassenk_mobile/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService( {this.uid} );

  //collection reference
  final CollectionReference userCollection = Firestore.instance.collection("users");
  final CollectionReference studentCollection = Firestore.instance.collection("students");
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

  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  Stream<List<Student>> get students {
    return studentCollection.snapshots()
      .map(_studentListFromSnapshot);
  }
}