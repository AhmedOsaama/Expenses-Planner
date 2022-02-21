import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/Transactions.dart';
import '../widgets/chart.dart';

class LastWeekScreen extends StatefulWidget {
   List<Transactions> transactions;
  final isLandscape;
  final AppBar appBar;
  final Widget txListWidget;
  final Function updateTotal;

  LastWeekScreen(this.transactions, this.isLandscape, this.appBar, this.txListWidget, this.updateTotal);

  @override
  _LastWeekScreenState createState() => _LastWeekScreenState();
}

class _LastWeekScreenState extends State<LastWeekScreen> {
  bool _showChart = false;

  // double _total = 0;
  List<Transactions> get _recentTransactions {
    return widget.transactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  double getTotal(){
    double total = 0;
    _recentTransactions.forEach((tx) {
      total += tx.amount;
    });
    return total;
  }



  @override
  Widget build(BuildContext context) {
  // widget.updateTotal(_total);
    return Column(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("Week's Total: ${getTotal().toStringAsFixed(2)}",style: TextStyle(fontFamily: "OpenSans",fontSize: 17),),
        if(widget.isLandscape) Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Show Chart"),
            Switch.adaptive(value: _showChart, onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            }),
          ],
        ),
        if(!widget.isLandscape) Container(
          height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              widget.appBar.preferredSize.height) *
              0.3,
          width: double.infinity,
          child: Chart(_recentTransactions),
        ),
        if(!widget.isLandscape) Expanded(child: widget.txListWidget),
        if(widget.isLandscape)
          _showChart ? Container(
            height: (MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                widget.appBar.preferredSize.height) *
                0.7,
            width: double.infinity,
            child: Chart(_recentTransactions),
          ) :
          widget.txListWidget,
      ],
    );
  }
}
