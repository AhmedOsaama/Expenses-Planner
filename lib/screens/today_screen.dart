import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/Transactions.dart';
import 'package:flutter_complete_guide/widgets/transaction_list.dart';

class TodayScreen extends StatefulWidget {
  List<Transactions> transactions;
  final Function deleteTxHandler;
  final Function updateTxHandler;


  TodayScreen(this.transactions, this.deleteTxHandler, this.updateTxHandler);

  @override
  _TodayScreenState createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {

  List<Transactions> get _todayTransactions{
    return widget.transactions.where((transaction) => transaction.date.day == DateTime.now().day).toList();
  }

  double getTotal(){
    double _total = 0;
    _todayTransactions.forEach((tx) {
     _total += tx.amount;
    });
    return _total;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Today's Total: ${getTotal().toStringAsFixed(2)}",style: TextStyle(fontFamily: "OpenSans",fontSize: 17),),
        Expanded(child: TransactionList(_todayTransactions.reversed.toList(), widget.deleteTxHandler,widget.updateTxHandler))
      ],
    );
  }
}
