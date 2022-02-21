import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helpers/ad_helper.dart';
import 'package:flutter_complete_guide/models/Transactions.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function txHandler;
  final existingId;
  final String? existingTitle;
  final double? existingAmount;
  final DateTime? existingDate;
  final isUpdate;

  NewTransaction(this.txHandler,
      {this.isUpdate = false,
      this.existingTitle,
      this.existingAmount,
      this.existingDate,
      this.existingId});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  DateTime? selectedDate = DateTime.now();

  InterstitialAd? _interstitialAd;

  bool _isInterstitialAdReady = false;

  void _loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          this._interstitialAd = ad;
          ad.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            Navigator.of(context).pop();
          });
          _isInterstitialAdReady = true;
        }, onAdFailedToLoad: (error) {
          print("Failed to load an interstitial ad: ${error.message}");
          _isInterstitialAdReady = false;
        }));
  }

  void submitData() {
    var enteredAmount = double.parse(amountController.text);

    if (titleController.text.isEmpty ||
        enteredAmount <= 0 ||
        selectedDate == null) {
      return;
    }
    if (widget.isUpdate) {
      widget.txHandler(widget.existingId, titleController.text, enteredAmount,
          selectedDate); //updating a transaction
    } else {
      widget.txHandler(titleController.text, enteredAmount,
          selectedDate); //adding  a transaction
    }

    if(_isInterstitialAdReady)
      _interstitialAd!.show();
    else
      Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2015),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  @override
  void initState() {
    if (widget.isUpdate) {
      titleController.text = widget.existingTitle!;
      amountController.text = widget.existingAmount!.toStringAsFixed(2);
      selectedDate = widget.existingDate;
    }
    if (!_isInterstitialAdReady) {
      _loadInterstitialAd();
    }
    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        // margin: EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                controller: titleController,
                onSubmitted: (_) => submitData(),
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
              ),
              Container(
                height: 60,
                child: Row(
                  children: [
                    Text(selectedDate == null
                        ? "No Chosen Date!"
                        : DateFormat.yMMMEd().format(selectedDate as DateTime)),
                    FlatButton(
                        onPressed: _showDatePicker,
                        child: Text("Choose Another Date"))
                  ],
                ),
              ),
              RaisedButton(
                child: widget.isUpdate
                    ? Text("Update Transaction")
                    : Text("Add Transaction"),
                onPressed: selectedDate != null ? submitData : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
