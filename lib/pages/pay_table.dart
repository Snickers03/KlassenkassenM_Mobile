import 'package:flutter/material.dart';
import 'package:klassenk_mobile/models/student.dart';
import 'package:klassenk_mobile/models/payment.dart';
import 'package:intl/intl.dart';
import 'package:klassenk_mobile/services/database.dart';
import 'package:provider/provider.dart';
import 'package:klassenk_mobile/models/user.dart';

class PayTable extends StatefulWidget {
  final Student stud;
  final User user;
  PayTable({Key key, @required this.stud, @required this.user})
      : super(key: key);

  @override
  _PayTableState createState() => _PayTableState();
}

class _PayTableState extends State<PayTable> {
  var form = DateFormat('dd.MM.yy');
  List<Payment> paySelection = [];
  bool selectionMode = false;

  AppBar selectionBar() {
    return AppBar(
      title: Text("${paySelection.length} ausgewählt"),
      backgroundColor: Colors.green,
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          setState(() {
            selectionMode = false; //leave selection mode
            paySelection.clear();
          });
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.delete), 
          onPressed: () {
            DatabaseService().deletePaymentsForSingle(paySelection, widget.stud.studID);
            setState(() {
              selectionMode = false;
              paySelection.clear();
            });
            }
        )],
    );
  }

  DataRow payRow(payment) {
    return DataRow(cells: [
      //DataCell(Text(payment.date)),
      DataCell(Text(form.format(payment.date)), showEditIcon: true),
      DataCell(Text(payment.reason)),
      DataCell(Text(payment.amount.toStringAsFixed(2))),
    ]);
  }

  Widget payRowNew(int index, List<Payment> payments) {
    return Container(
      color: paySelection.contains(payments[index])
          ? Colors.grey[300]
          : Colors.transparent,
      child: ListTileTheme(
        selectedColor: Colors.black,
        //contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: ListTile(
          selected: paySelection.contains(payments[index]),
          contentPadding: null,
          dense: true,
          onTap: () {
            if (selectionMode) {
              onSelectedRow(payments[index]); //toggle selection
            } else {
              rowTapped(payments[index]); //show payments
            }
          },
          onLongPress: () {
            if (!selectionMode) {
              setState(() {
                selectionMode = true;
                paySelection.add(payments[index]);
              });
            }
          },
          title: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Text(
                  form.format(payments[index].date),
                  style: TextStyle(fontSize: 13),
                ),
                //width: ,
                //color: Colors.blue,
              ),
              Expanded(
                flex: 2,
                child: Text(
                  payments[index].reason,
                  style: TextStyle(fontSize: 13),
                ),
              ),
              //SizedBox(width: 10,),
              Expanded(
                  flex: 1,
                  child: Text(
                    payments[index].amount.toStringAsFixed(2),
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 13),
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
  }

  void rowTapped(Payment pay) {
    /*Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StreamProvider<List<Payment>>.value(
                value: DatabaseService(student: stud).payments,
                child: PayTable(stud: stud))));*/
  }

  onSelectedRow(Payment pay) async {
    setState(() {
      if (!paySelection.contains(pay)) {
        paySelection.add(pay);
      } else {
        paySelection.remove(pay);
        if (paySelection.length == 0) {
          //end selectionMode if no student selected anymore
          selectionMode = false;
        }
      }
    });
  }

  final formKey = GlobalKey<FormState>();

  Widget editDialog() {
    return AlertDialog(
      title: Text("Schüler bearbeiten"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                hintText: "Nachname",
              ),
              initialValue: widget.stud.name,
              validator: (input) =>
                  input.length == 0 ? "Name erforderlich" : null,
              onSaved: (input) => widget.stud.name = input,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: "Vorname",
              ),
              initialValue: widget.stud.vorname,
              validator: (input) =>
                  input.length == 0 ? "Vorname erforderlich" : null,
              onSaved: (input) => widget.stud.vorname = input,
            ),
            /*TextFormField(
              decoration: InputDecoration(
                hintText: "Guthaben",
              ),
              keyboardType: TextInputType.number,
              /*inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],*/
              onSaved: (input) => widget.stubalance = double.parse(input),
            ),*/
            RaisedButton(
              onPressed: () {
                submitStudEdit();
              },
              child: Text("Speichern"),
            )
          ],
        ),
      ),
    );
  }

  void submitStudEdit() {
    if (formKey.currentState.validate()) {
      setState(() {
        formKey.currentState.save();
      });
      Navigator.pop(context);
      //widget.stud.studID;
      DatabaseService().updateStudentData(widget.stud.studID, widget.stud.name,
          widget.stud.vorname, widget.stud.balance, widget.user.uid);
    }
  }

  /*void submitStud() {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      Navigator.pop(context);
      DatabaseService()
          .updateStudentData(null, name, vorname, balance, widget.user.uid);
      /*setState(() {
        students.add(Student(name: name, vorname: vorname, balance: balance));
      });*/
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final payments = Provider.of<List<Payment>>(context) ?? [];
    payments.sort((a, b) => a.date.compareTo(b.date));
    return Scaffold(
      appBar: selectionMode
          ? selectionBar()
          : AppBar(
              backgroundColor: Colors.green,
              title: Text("${widget.stud.name} ${widget.stud.vorname}"),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      print("edit");

                      setState(() {
                        //widget.stud.name = "dürum";
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return editDialog();
                            });
                      });
                    })
              ],
            ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          height: 2, //remove padding
          color: Colors.grey[400],
          //indent: 0,
        ),
        itemCount: payments == null ? 1 : payments.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return ListTile(
                //table header
                title: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Text("Datum"),
                  //width: ,
                  //color: Colors.blue,
                ),
                Expanded(
                  flex: 2,
                  child: Text("Grund"),
                ),
                //SizedBox(width: 10,),
                Expanded(
                    flex: 1,
                    child: Text(
                      "Betrag",
                      textAlign: TextAlign.right,
                    )),
              ],
            ));
          }
          index--;
          return payRowNew(index, payments); //display students
        },
      ),
    );
  }
}
