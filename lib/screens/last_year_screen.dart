import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/Transactions.dart';
import 'package:flutter_complete_guide/widgets/card.dart';
import 'package:flutter_complete_guide/widgets/transaction_list.dart';

class LastYearScreen extends StatefulWidget {
  List<Transactions> transactions;
  final Function deleteTxHandler;
  final Function updateTxHandler;


  LastYearScreen(this.transactions, this.deleteTxHandler, this.updateTxHandler);

  @override
  _LastYearScreenState createState() => _LastYearScreenState();
}

class _LastYearScreenState extends State<LastYearScreen> {
  double _total = 0;

  List<Transactions> get _yearTransactions {
    return widget.transactions.where((transaction) {
      return transaction.date.year == DateTime.now().year;
    }).toList();
  }

  void getTotal() {
    _total = 0;
    widget.transactions.forEach((tx) {
      _total += tx.amount;
    });
  }

  @override
  void initState() {
    widget.transactions = _yearTransactions;
    getTotal();
    super.initState();
  }

  String text = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text(
            text == "??????????????" ? "Year's total: ???" :
            "Year's Total: ${_total.toStringAsFixed(2)}",
            style: TextStyle(fontFamily: "OpenSans", fontSize: 17),
          ),
          text == "??????????????" ? ListView(children: [
            MyCard("YOU"),
            MyCard("ARE"),
            MyCard("NOT"),
            MyCard("SUPPOSED"),
            MyCard("TO"),
            MyCard("SEE"),
            MyCard("THIS"),
            MyCard("PRESS"),
            MyCard("HERE"),
          ],) :
          Expanded(child: TransactionList(_yearTransactions.reversed.toList(), widget.deleteTxHandler,widget.updateTxHandler))
          // SizedBox(
          //   height: 10,
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     FlatButton(
          //       onPressed: () {
          //         setState(() {
          //           text = "??????????????";
          //         });
          //       },
          //       child: Text(text),
          //       textColor: text == "??????????????"
          //           ? Colors.black
          //           : Theme.of(context).canvasColor,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
