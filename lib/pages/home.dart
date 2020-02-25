import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klassenk_mobile/services/authenticate.dart';
import 'package:klassenk_mobile/pages/pay_table.dart';
import 'package:klassenk_mobile/models/payment.dart';
import 'package:klassenk_mobile/models/student.dart';
import 'package:klassenk_mobile/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:klassenk_mobile/services/database.dart';
import 'package:klassenk_mobile/models/user.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  Home({Key key, this.user}) : super(key: key);
  final User user;
  //final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Student> selection = [];

  /*DataRow tableRow(stud) {
    return DataRow(
        selected: selection.contains(stud),
        onSelectChanged: (sel) {
          print(stud.name);
          //onSelectedRow(sel, stud);
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
          }, showEditIcon: true),
        ]);
  }*/

  void rowTapped(Student stud) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StreamProvider<List<Payment>>.value(
                value: DatabaseService(student: stud).payments,
                child: PayTable(stud: stud))));
  }

  onSelectedRow(Student stud) async {
    setState(() {
      if (!selection.contains(stud)) {
        selection.add(stud);
      } else {
        selection.remove(stud);
        if (selection.length == 0) {
          //end selectionMode if no student selected anymore
          selectionMode = false;
        }
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
    date = null;
    return AlertDialog(
      title: Text("Zahlung erfassen"),
      content: StatefulBuilder(builder: (context, StateSetter setState) {
        return Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                child: Text(date == null
                    ? "Datum: " +
                        DateFormat('dd.MM.yyyy').format(DateTime.now())
                    : "Datum: " + DateFormat('dd.MM.yyyy').format(date)),
                onPressed: () {
                  showDatePicker(
                          context: context,
                          initialDate: date == null ? DateTime.now() : date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2200))
                      .then((newdate) {
                    setState(() {
                      date = newdate;
                    });
                  });
                },
                /*decoration: InputDecoration(
                    hintText: "Datum",
                  ),
                  validator: (input) =>
                      input.length == 0 ? "Name erforderlich" : null,*/
                //onSaved: (input) => date = input,
              ),
              TextFormField(
                //initialValue: "eifach",
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
              ),
            ],
          ),
        );
      }),
    );
  }

  void submitStud() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Navigator.pop(context);
      DatabaseService()
          .updateStudentData(null, name, vorname, balance, widget.user.uid);
      /*setState(() {
        students.add(Student(name: name, vorname: vorname, balance: balance));
      });*/
    }
  }

  void submitPay() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      List<String> idList = [];
      date = date == null
          ? DateTime.now()
          : date; //current date when date equals null
      Navigator.pop(context);
      //setState(() {
      for (int i = 0; i < selection.length; i++) {
        //selection[i].payments.add(
        // Payment(date: DateFormat("dd.MM.yy").format(DateTime.now()), reason: reason, amount: amount));  //https://stackoverflow.com/questions/51696478/datetime-flutter
        idList.add(selection[i].studID);
        DatabaseService().updateStudentData(
            selection[i].studID,
            selection[i].name,
            selection[i].vorname,
            selection[i].balance + amount,
            widget.user.uid);
        //selection[i].balance += amount;
      }
      DatabaseService().updatePaymentData(date, reason, amount, idList);
      selectionMode = false;
      //});
    }
  }

  final formKey = GlobalKey<FormState>();
  String name;
  String vorname;
  double balance;

  DateTime date;
  String reason;
  double amount;

  final AuthService _auth = AuthService();

  AppBar bar() {
    return AppBar(
      title: Text("Übersicht"),
      backgroundColor: Colors.green,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () async {
            //await _auth.signOut();
            setState(() {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return addDialog();
                  });
            });
          },
        ),
        /*IconButton(
          icon: Icon(Icons.attach_money),
          onPressed: () {
            if (selection.length == 0 || selection == null) {
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
        ),*/
        PopupMenuButton(
          //onSelected: (result) { setState(() { _selection = result; }); },
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              value: 1,
              child: Text("Test"),
            ),
            PopupMenuDivider(
              height: 5,
            ),
            PopupMenuItem(
              value: 2,
              child: Text("Abmelden"),
            ),
          ],
          onSelected: (value) async {
            print(value);
            switch (value) {
              case 1:
                print("test");
                break;
              case 2:
                await _auth.signOut();
                break;
              default:
                print("error");
                break;
            }
          },
        )
      ],
    );
  }

  AppBar selectionBar() {
    return AppBar(
      title: Text("${selection.length} ausgewählt"),
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          setState(() {
            selectionMode = false; //leave selection mode
            selection.clear();
          });
        },
      ),
      backgroundColor: Colors.green,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.select_all),
          onPressed: () {
            setState(() {
              if (selection.length != students.length) {
                selection.clear();
                for (int i = 0; i < students.length; i++) {
                  selection.add(students[i]);
                }
              } else {
                selection.clear();
              }                    
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.attach_money),
          onPressed: () {
            if (selection.length == 0 || selection == null) {
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
          itemBuilder: (BuildContext context) => <PopupMenuEntry>[
            PopupMenuItem(
              value: 1,
              child: Text("Löschen"),
            ),
            PopupMenuDivider(
              height: 5,
            ),
            PopupMenuItem(
              value: 2,
              child: Text("Abmelden"),
            ),
          ],
          onSelected: (value) async {
            print(value);
            switch (value) {
              case 1:
                DatabaseService().deleteStudents(selection);
                break;
              case 2:
                await _auth.signOut();
                break;
              default:
                print("error");
                break;
            }
          },
        )
      ],
    );
  }

  bool selectionMode = false;
  List students;

  @override
  Widget build(BuildContext context) {
    students = Provider.of<List<Student>>(context) ?? [];
    students.sort((a, b) => a.name.compareTo(b
        .name)); //https://stackoverflow.com/questions/53547997/sort-a-list-of-objects-in-flutter-dart-by-property-value
    return Scaffold(
      appBar: selectionMode ? selectionBar() : bar(),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          height: 1, //remove padding
          color: Colors.grey[270],
        ),
        itemCount: students == null ? 1 : students.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return ListTile(
                title: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text("Name"),
                  //width: ,
                  //color: Colors.blue,
                ),
                Expanded(
                  flex: 2,
                  child: Text("Vorname"),
                ),
                //SizedBox(width: 10,),
                Expanded(
                    flex: 1,
                    child: Text(
                      "Guthaben",
                      textAlign: TextAlign.right,
                    )),
              ],
            ));
          }
          index--;
          return Container(
            color: selection.contains(students[index])
                ? Colors.blue[500]
                : Colors.transparent,
            child: ListTileTheme(
              selectedColor: Colors.white,
              child: ListTile(
                selected: selection.contains(students[index]),
                contentPadding: null,
                dense: true,
                onTap: () {
                  if (selectionMode) {
                    onSelectedRow(students[index]); //toggle selection
                  } else {
                    rowTapped(students[index]); //show payments
                  }
                },
                onLongPress: () {
                  if (!selectionMode) {
                    setState(() {
                      selectionMode = true;
                      selection.add(students[index]);
                    });
                  }
                },
                title: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(students[index].name),
                      //width: ,
                      //color: Colors.blue,
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(students[index].vorname),
                    ),
                    //SizedBox(width: 10,),
                    Expanded(
                        flex: 1,
                        child: Text(
                          students[index].balance.toStringAsFixed(2),
                          textAlign: TextAlign.right,
                        )),
                  ],
                ),
                //color: Colors.green,
                /*height: 30,
                decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(color: Colors.black)
                ),*/
              ),
            ),
          );
        },
        /*children: <Widget>[
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
          //StudentList(selection: selection, rowTapped: rowTapped, onSelectedRow: onSelectedRow, isSelected: isSelected,),
        ],*/
      ),
      /*floatingActionButton: FloatingActionButton(
    onPressed: () {
      setState(() {
        showDialog(
            context: context,S
            builder: (BuildContext context) {
              return addDialog();
            });
      });
    },
    child: Icon(Icons.add),
        ),*/
    );
  }
}
