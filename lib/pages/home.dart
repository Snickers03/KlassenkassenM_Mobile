import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klassenk_mobile/authenticate/authenticate.dart';
import 'package:klassenk_mobile/pages/pay_table.dart';
import 'package:klassenk_mobile/payment.dart';
import 'package:klassenk_mobile/student.dart';

class Home extends StatefulWidget {
  /*Home({Key key, this.title}) : super(key: key);

  final String title;*/

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Student> students = [
    Student(name: "Schellenbaum", vorname: "Nic", balance: 50),
    Student(name: "Maurer", vorname: "Ueli", balance: 50),
    Student(name: "DeVito", vorname: "Danny", balance: 50),
  ];

  List<Student> selection = [];

  DataRow tableRow(stud) {
    return DataRow(
        selected: selection.contains(stud),
        onSelectChanged: (sel) {
          print(stud.name);
          onSelectedRow(sel, stud);
        },
        //selected: true,
        cells: [
          DataCell(
            Text(
              stud.name,
              style: TextStyle(
                  //fontSize: 14,
                  ),
            ),
            onTap: () {
              rowTapped(stud);
            },
          ),
          DataCell(Text(stud.vorname), onTap: () {
            rowTapped(stud);
          }),
          DataCell(Text(stud.balance.toString()), onTap: () {
            rowTapped(stud);
          }),
        ]);
  }

  void rowTapped(stud) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PayTable(stud: stud)));
  }

  onSelectedRow(bool sel, Student stud) async {
    setState(() {
      if (sel == true) {
        selection.add(stud);
      } else {
        selection.remove(stud);
      }
    });
  }

  Widget addDialog() {
    return AlertDialog(
      title: Text("Schüler hinzufügen"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: "Nachname",
              ),
              validator: (input) =>
                  input.length == 0 ? "Name erforderlich" : null,
              onSaved: (input) => name = input,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Vorname",
              ),
              validator: (input) =>
                  input.length == 0 ? "Vorname erforderlich" : null,
              onSaved: (input) => vorname = input,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Guthaben",
              ),
              keyboardType: TextInputType.number,
              /*inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],*/
              onSaved: (input) => balance = double.parse(input),
            ),
            RaisedButton(
              onPressed: () {
                submitStud();
              },
              child: Text("Speichern"),
            )
          ],
        ),
      ),
    );
  }

  Widget payDialog() {
    return AlertDialog(
      title: Text("Zahlung erfassen"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /*TextFormField(
              decoration: InputDecoration(
                hintText: "Datum",
              ),
              validator: (input) =>
                  input.length == 0 ? "Name erforderlich" : null,
              onSaved: (input) => datum = input,
            ),*/
            TextFormField(
              decoration: InputDecoration(
                hintText: "Zahlungsgrund",
              ),
              validator: (input) =>
                  input.length == 0 ? "Grund erforderlich" : null,
              onSaved: (input) => reason = input,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Betrag",
              ),
              keyboardType: TextInputType.number,
              /*inputFormatters: <DecimalTextInputFormatter()*/
              onSaved: (input) => amount = double.parse(input),
            ),
            RaisedButton(
              onPressed: () {
                submitPay();
              },
              child: Text("Speichern"),
            )
          ],
        ),
      ),
    );
  }

  void submitStud() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Navigator.pop(context);
      setState(() {
        students.add(Student(name: name, vorname: vorname, balance: balance));
      });
    }
  }

  void submitPay() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Navigator.pop(context);
      setState(() {
        for (int i = 0; i < selection.length; i++) {
          selection[i].payments.add(
              Payment(date: DateTime.now(), reason: reason, amount: amount));

          selection[i].balance += amount;
        }
      });
    }
  }

  final formKey = GlobalKey<FormState>();
  String name;
  String vorname;
  double balance;

  String date;
  String reason;
  double amount;

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Übersicht"),
        backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () async {
              await _auth.signOut();
              //Future.delayed(Duration(seconds: 3), () {}
              //PayTable(stud: students[0]);
              //test, remove later
            },
          ),
          IconButton(
            icon: Icon(Icons.attach_money),
            onPressed: () {
              if (selection.length <= 0) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Kein Schüler ausgewählt"),
                      );
                    });
              } else {
                setState(() {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return payDialog();
                      });
                });
              }
            },
          ),
          PopupMenuButton(
            //onSelected: (result) { setState(() { _selection = result; }); },
            itemBuilder: (BuildContext context) => <PopupMenuEntry> [
              PopupMenuItem(
                child: FlatButton(
                  child: Text("Test"),
                  onPressed: () {print("test");},
                  ),
              ),
              PopupMenuItem(
                child: Text("Abmelden"),
              ),
            ]
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          DataTable(
            horizontalMargin: 15,
            //columnSpacing: 10,
            columns: [
              DataColumn(label: Text("Name")),
              DataColumn(label: Text("Vorname")),
              DataColumn(label: Text("Guthaben"), numeric: true),
            ],
            rows: students.map((student) => tableRow(student)).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return addDialog();
                });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
