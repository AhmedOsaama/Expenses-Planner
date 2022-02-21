import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/Transactions.dart';
import '../widgets/transaction_list.dart';

class CustomScreen extends StatefulWidget {
  List<Transactions> transactions;
  final Function deleteTxHandler;
  final Function updateTxHandler;

  CustomScreen(this.transactions, this.deleteTxHandler, this.updateTxHandler);

  @override
  _CustomScreenState createState() => _CustomScreenState();
}

class _CustomScreenState extends State<CustomScreen> {
  DateTime? selectedDate;
  DateTimeRange? selectedRange;
  TextEditingController monthController = TextEditingController();
  TextEditingController yearController = TextEditingController();

  double _total = 0;

  int monthNumber = 0;
  int yearNumber = 0;

  @override
  void dispose() {
    monthController.dispose();
    yearController.dispose();
    super.dispose();
  }

  void _showDateRangePicker() {
    showDateRangePicker(
            context: context,
            firstDate: DateTime(2015),
            lastDate: DateTime.now())
        .then((pickedRange) {
      if (pickedRange == null) {
        return;
      }
      print(selectedRange);

      setState(() {
        selectedRange = pickedRange;
        selectedDate = null;
        monthController.text = "";
        yearController.text = "";
        monthNumber = 0;
        yearNumber = 0;
        getTotal();
      });
    });
  }

  void _showDatePicker() {
    showDatePicker(
            initialDatePickerMode: DatePickerMode.day,
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2015),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      print(pickedDate);
      setState(() {
        selectedDate = pickedDate;
        selectedRange = null;
        monthController.text = "";
        yearController.text = "";
        monthNumber = 0;
        yearNumber = 0;
        getTotal();
      });
    });
  }

  List<Transactions> get _chosenTransactions {
    return widget.transactions.where((transaction) {
      if (selectedRange != null) {
        return transaction.date                                                   //subtracting and addition is for making the range inclusive which by default is not
                .isAfter(selectedRange!.start.subtract(Duration(days: 1))) &&
            transaction.date
                .isBefore(selectedRange!.end.add(Duration(days: 1)));
      }
      if (selectedDate != null) {
        return (transaction.date.day == selectedDate!.day &&
            transaction.date.month == selectedDate!.month &&
            transaction.date.year == selectedDate!.year);
      } else if (monthNumber >= 1 && yearNumber >= 1) {
        return (transaction.date.month == monthNumber &&
            transaction.date.year == yearNumber);
      } else {
        return transaction.date.month == monthNumber ||
            transaction.date.year == yearNumber;
      }
    }).toList();
  }

  void getTotal() {
    _total = 0;
    _chosenTransactions.forEach((tx) {
      _total += tx.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Want to view recorded transactions of a specific date ?",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          softWrap: true,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: yearController,
                  decoration: InputDecoration(
                      hintText: "ex. 2018",
                      hintStyle: TextStyle(color: Colors.grey)),
                )),
            RaisedButton(
                onPressed: yearController.text.isEmpty
                    ? null
                    : () {
                        setState(() {
                          yearNumber = int.parse(yearController.text);
                          if (monthController.text.isEmpty) monthNumber = 0;
                          selectedDate = null;
                          selectedRange = null;
                          getTotal();
                        });
                      },
                child: Text("Show Year")),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 100,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: monthController,
                  decoration: InputDecoration(
                      hintText: "ex. 1,5,12",
                      hintStyle: TextStyle(color: Colors.grey)),
                )),
            RaisedButton(
                onPressed: monthController.text.isEmpty
                    ? null
                    : () {
                        setState(() {
                          monthNumber = int.parse(monthController.text);
                          if (yearController.text.isEmpty) yearNumber = 0;
                          selectedDate = null;
                          selectedRange = null;
                          getTotal();
                        });
                      },
                child: Text("Show Month")),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
                onPressed: _showDatePicker, child: Text("Choose a Day")),
            SizedBox(
              width: 10,
            ),
            RaisedButton(
                onPressed: _showDateRangePicker,
                child: Text("Choose a Range")),
          ],
        ),
          SizedBox(height: 10),
        Text(
          "Total: ${_total.toStringAsFixed(2)}",
          style: TextStyle(fontFamily: "OpenSans", fontSize: 17),
        ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TransactionList(_chosenTransactions.reversed.toList(),
                  widget.deleteTxHandler, widget.updateTxHandler),
            ),
          )
      ],
    );
  }
}
