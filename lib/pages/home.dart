import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klassenk_mobile/student.dart';

class Home extends StatefulWidget {
  /*Home({Key key, this.title}) : super(key: key);

  final String title;*/

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Student> students = [
    Student(name: "Schellenbaum", vorname: "Nic", balance: 500),
    Student(name: "Maurer", vorname: "Ueli", balance: 4539054),
    Student(name: "DeVito", vorname: "Danny", balance: 900),
  ];

  DataRow tableRow(stud) {
    return DataRow(cells: [
      DataCell(
        Text(stud.name),
        //onTap: ,
      ),
      DataCell(Text(stud.vorname)),
      DataCell(Text((stud.balance).toString())),
    ]);
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
              validator: (input) => input.length == 0 ? "Name erforderlich" : null,
              onSaved: (input) => name = input,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Vorname",
              ),
              validator: (input) => input.length == 0 ? "Vorname erforderlich" : null,
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
                submit();
                },
              child: Text("Speichern"),
            )
          ],
        ),
      ),
    );
  }
  
  void submit() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Navigator.pop(context);
      setState(() {
        students.add(Student(name: name, vorname: vorname, balance: balance));
      });
    }
  }

  final formKey = GlobalKey<FormState>();
  String name;
  String vorname;
  double balance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Übersicht"),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        children: <Widget>[
          DataTable(
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