import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/Transactions.dart';
import 'package:flutter_complete_guide/widgets/transaction_list.dart';

class RecentlyAddedScreen extends StatelessWidget {
  final List<Transactions> transactions;
  final Function deleteTxHandler;
  final Function updateTxHandler;

  RecentlyAddedScreen(this.transactions, this.deleteTxHandler, this.updateTxHandler);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TransactionList(transactions.reversed.toList(), deleteTxHandler, updateTxHandler),
    );
  }
}
