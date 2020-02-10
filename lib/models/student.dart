import 'package:klassenk_mobile/models/payment.dart';

class Student {
  //int id;  maybe usefull
  String studID;
  String name;
  String vorname;
  double balance;
  //bool selected = false;

  Student( {this.name, this.vorname, this.balance, this.studID} );

  List<Payment> payments = [
    //Payment(date: DateTime.utc(2018, 5, 3), reason: "Beispiel", amount: 50),
  ];
}