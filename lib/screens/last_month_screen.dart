import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/Transactions.dart';
import 'package:flutter_complete_guide/widgets/transaction_list.dart';

class LastMonthScreen extends StatefulWidget {
  List<Transactions> transactions;
  final Function deleteTxHandler;
  final Function updateTxHandler;


  LastMonthScreen(this.transactions, this.deleteTxHandler, this.updateTxHandler);

  @override
  _LastMonthScreenState createState() => _LastMonthScreenState();
}

class _LastMonthScreenState extends State<LastMonthScreen> {
  double _total = 0;

  List<Transactions> get _monthTransactions {
    return widget.transactions.where((transaction) {
      return transaction.date.month == DateTime.now().month && transaction.date.year == DateTime.now().year;
    }).toList();
  }

  void getTotal(){
    _total = 0;
    widget.transactions.forEach((tx) {
      _total += tx.amount;
    });
  }

  @override
  void initState() {
    widget.transactions = _monthTransactions;
    getTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text("Month's Total: ${_total.toStringAsFixed(2)}",style: TextStyle(fontFamily: "OpenSans",fontSize: 17),),
          Expanded(child: TransactionList(_monthTransactions.reversed.toList(), widget.deleteTxHandler,widget.updateTxHandler))
        ],
      ),
    );
  }
}
