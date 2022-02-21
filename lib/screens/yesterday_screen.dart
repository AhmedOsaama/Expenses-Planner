import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/Transactions.dart';
import 'package:flutter_complete_guide/widgets/transaction_list.dart';

class YesterdayScreen extends StatefulWidget {
  List<Transactions> transactions;
  final Function deleteTxHandler;
  final Function updateTxHandler;


  YesterdayScreen(this.transactions, this.deleteTxHandler, this.updateTxHandler);

  @override
  _YesterdayScreenState createState() => _YesterdayScreenState();
}

class _YesterdayScreenState extends State<YesterdayScreen> {
  double _total = 0;

  List<Transactions> get _yesterdayTransactions {
    return widget.transactions.where((transaction) {
      return transaction.date.day == DateTime.now().day-1 && transaction.date.month == DateTime.now().month;
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
    widget.transactions = _yesterdayTransactions;
    getTotal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text("Yesterday's Total: ${_total.toStringAsFixed(2)}",style: TextStyle(fontFamily: "OpenSans",fontSize: 17),),
          Expanded(child: TransactionList(_yesterdayTransactions.reversed.toList(), widget.deleteTxHandler,widget.updateTxHandler))
        ],
      ),
    );
  }
}
