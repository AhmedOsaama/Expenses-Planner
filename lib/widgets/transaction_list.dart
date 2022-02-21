import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/Transactions.dart';
import 'package:flutter_complete_guide/widgets/new_transaction.dart';
import 'package:intl/intl.dart';
import '../helpers/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ignore: must_be_immutable
class TransactionList extends StatefulWidget {
  List<Transactions> transactionsList;
  final Function deleteTxHandler;
  final Function updateTxHandler;

  TransactionList(
      this.transactionsList, this.deleteTxHandler, this.updateTxHandler);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  static final _kAdIndex = 4;
  late BannerAd _ad;

  bool _isAdLoaded = false;

  int _getDestinationItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex && _isAdLoaded) {
      print(rawIndex);
      return rawIndex - 1;
    }
    return rawIndex;
  }

  void _showUpdateTransactionModal(BuildContext context, String id,
      String title, double amount, DateTime date) {
    showModalBottomSheet(
        context: context,
        builder: (buildContext) {
          return NewTransaction(
            widget.updateTxHandler,
            isUpdate: true,
            existingAmount: amount,
            existingDate: date,
            existingTitle: title,
            existingId: id,
          );
        });
  }

  void _loadBannerAd(){
    _ad = BannerAd(
        size: AdSize.banner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        }),
        request: AdRequest());
    _ad.load();
  }

  @override
  void initState() {
    super.initState();
    // widget.transactionsList = widget.transactionsList.reversed.toList();
    _loadBannerAd();
  }

  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.transactionsList.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Text(
                  "No Transactions Yet!",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                    height: constraints.maxHeight * 0.5,
                    child: Image.asset("images/waiting.png")),
              ],
            );
          })
        : ListView.builder(
            itemCount: widget.transactionsList.length + (_isAdLoaded && widget.transactionsList.length >= 4 ? 1 : 0),
            itemBuilder: (context, index) {
              if (_isAdLoaded && index == _kAdIndex) {
                return Container(
                  child: AdWidget(
                    ad: _ad,
                  ),
                  width: _ad.size.width.toDouble(),
                  height: 72.0,
                  alignment: Alignment.center,
                );
              } else {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: FittedBox(
                          child: Text(
                            widget
                                .transactionsList[
                                    _getDestinationItemIndex(index)]
                                .amount
                                .toStringAsFixed(2),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      widget.transactionsList[_getDestinationItemIndex(index)]
                          .title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(DateFormat.yMMMd().format(widget
                        .transactionsList[_getDestinationItemIndex(index)]
                        .date)),
                    trailing: MediaQuery.of(context).size.width <= 460
                        ? Container(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                    tooltip: "Edit",
                                    icon: Icon(Icons.edit),
                                    color: Theme.of(context).accentColor,
                                    onPressed: () =>
                                        _showUpdateTransactionModal(
                                            context,
                                            widget
                                                .transactionsList[
                                                    _getDestinationItemIndex(
                                                        index)]
                                                .id,
                                            widget
                                                .transactionsList[
                                                    _getDestinationItemIndex(
                                                        index)]
                                                .title,
                                            widget
                                                .transactionsList[
                                                    _getDestinationItemIndex(
                                                        index)]
                                                .amount,
                                            widget
                                                .transactionsList[
                                                    _getDestinationItemIndex(
                                                        index)]
                                                .date)),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Theme.of(context).errorColor,
                                  onPressed: () => widget.deleteTxHandler(widget
                                      .transactionsList[
                                          _getDestinationItemIndex(index)]
                                      .id),
                                ),
                              ],
                            ),
                          )
                        : FlatButton.icon(
                            onPressed: () => widget.deleteTxHandler(widget
                                .transactionsList[
                                    _getDestinationItemIndex(index)]
                                .id),
                            color: Theme.of(context).errorColor,
                            icon: Icon(Icons.delete),
                            label: Text("Delete"),
                          ),
                  ),
                );
              }
            });
  }
}
