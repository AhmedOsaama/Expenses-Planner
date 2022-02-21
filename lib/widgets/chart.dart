import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/chartBar.dart';
import 'package:intl/intl.dart';
import '../models/Transactions.dart';

class Chart extends StatelessWidget {
  final List<Transactions> recentTransactions;
  double totalAmount = 0;                           //total amount spent across all the recent transactions


  Chart(this.recentTransactions);

  List<Map<String,Object>> get groupedTransactions{
      return List.generate(7, (index) {
        final weekDay = DateTime.now().subtract(Duration(days: index));
        double totalSum = 0;
        for (var i=0; i<recentTransactions.length; i++) {
          if(recentTransactions[i].date.day == weekDay.day
          && recentTransactions[i].date.month == weekDay.month
          && recentTransactions[i].date.year == weekDay.year)
            {
                totalSum += recentTransactions[i].amount;       //total money spent in a day
            }
          }
        totalAmount += totalSum;
        // print(DateFormat.E().format(weekDay));
        // print(totalSum);
        return {'day': DateFormat.E().format(weekDay).substring(0,3),'amount': totalSum};
      });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: groupedTransactions.map((tx) {
             // return Text("${tx['day']}: ${tx['amount']}\$ total: \$$totalAmount");
             return ChartBar(tx['day'] as String,totalAmount == 0.0 ? 0.0 : (tx['amount'] as double)/ totalAmount , tx['amount'] as double);
            }).toList()
      ),
    );
  }
}
