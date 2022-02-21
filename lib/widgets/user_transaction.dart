// import 'package:flutter/material.dart';
// import 'package:flutter_complete_guide/models/Transactions.dart';
// import 'package:flutter_complete_guide/widgets/new_transaction.dart';
// import 'package:flutter_complete_guide/widgets/transaction_list.dart';
//
// class UserTransaction extends StatefulWidget {
//   @override
//   _UserTransactionState createState() => _UserTransactionState();
// }
//
// class _UserTransactionState extends State<UserTransaction> {
//   final List<Transactions> transactions = [
//     Transactions(
//         id: "t1", date: DateTime.now(), amount: 69.99, title: "New Shoes"),
//     Transactions(
//         id: "t2",
//         date: DateTime.now(),
//         amount: 16.99,
//         title: "Weekly Groceries"),
//   ];
//
//   void _addNewTransaction(String newTitle,double newAmount){
//
//     final newTransaction = Transactions(
//       amount: newAmount,
//       title: newTitle,
//       id: DateTime.now().toString(),
//       date: DateTime.now()
//     );
//
//     setState(() {
//       transactions.add(newTransaction);
//     });
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         NewTransaction(_addNewTransaction),
//         TransactionList(transactions),
//       ],
//     );
//   }
// }
