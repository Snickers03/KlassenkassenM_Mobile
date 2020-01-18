import 'package:flutter/material.dart';
import 'package:klassenk_mobile/student.dart';

class PayTable extends StatefulWidget {
  final Student stud;
  PayTable({Key key, @required this.stud}) : super(key: key);

  @override
  _PayTableState createState() => _PayTableState();
}

class _PayTableState extends State<PayTable> {
  
  DataRow payRow(payment) {
    return DataRow(cells: [
      DataCell(Text(payment.date)),
      DataCell(Text(payment.reason)),
      DataCell(Text(payment.amount.toString())),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text("${widget.stud.name} ${widget.stud.vorname}"),
        ),
        body: //Text(widget.stud.name),
            ListView(
          children: <Widget>[
            DataTable(horizontalMargin: 15, columns: [
              DataColumn(label: Text("Datum")),
              DataColumn(label: Text("Grund")),
              DataColumn(label: Text("Betrag"), numeric: true),
            ], rows:
              widget.stud.payments.map((payment) => payRow(payment)).toList(),
            )
          ],
        ));
  }
}
