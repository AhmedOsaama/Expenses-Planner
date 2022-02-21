import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/helpers/db_helper.dart';
import 'package:flutter_complete_guide/screens/custom_screen.dart';
import 'package:flutter_complete_guide/screens/last_month_screen.dart';
import 'package:flutter_complete_guide/screens/last_week_screen.dart';
import 'package:flutter_complete_guide/screens/last_year_screen.dart';
import 'package:flutter_complete_guide/screens/recently_added_screen.dart';
import 'package:flutter_complete_guide/screens/today_screen.dart';
import 'package:flutter_complete_guide/screens/yesterday_screen.dart';
import 'package:flutter_complete_guide/widgets/chart.dart';
import 'package:flutter_complete_guide/widgets/new_transaction.dart';
import 'package:flutter_complete_guide/widgets/slider.dart';
import 'package:flutter_complete_guide/widgets/transaction_list.dart';
import 'package:flutter_complete_guide/widgets/user_transaction.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'models/Transactions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ['07FCFD9C5879E2B8F001BC873EEBAD24']));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.amber,
          buttonTheme: ButtonThemeData(
              // buttonColor: Theme.of(context).primaryColor,
              textTheme: ButtonTextTheme.primary),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans'),
                  )),
          textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'QuickSand'))),
      title: 'Flutter App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transactions> transactions = [];
  String _selectedWidget = "Default";
  double widgetTotal = 0;

  void updateTotal(double total){
    setState(() {
      widgetTotal = total;
    });
  }

  Future<void> fetchTransactions() async {
    try {
      List<Map<String, dynamic>> dataList =
          await DBhelper.getData('transactions');
      setState(() {
        transactions = dataList
            .map((transaction) => Transactions(
                  id: transaction['id'],
                  title: transaction['title'],
                  amount: transaction['amount'],
                  date: DateTime.parse(transaction['date']),
                ))
            .toList();
      });
    } catch (error) {
      print(error);
      return;
    }
  }


  void _addNewTransaction(
      String newTitle, double newAmount, DateTime selectedDate) {
    final id = DateTime.now().toString();

    final newTransaction = Transactions(
        amount: newAmount, title: newTitle, id: id, date: selectedDate);
    DBhelper.insert("transactions", {
      'id': id,
      'amount': newAmount,
      'title': newTitle,
      'date': selectedDate.toString()
    }).catchError((error) {
      print("ERROR:" + error);
      return;
    });

    setState(() {
      transactions.add(newTransaction);
    });
  }

  void _showAddNewTransactionModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (buildContext) {
          return NewTransaction(_addNewTransaction);
        });
  }

  List<Transactions> get _recentTransactions {
    return transactions.where((transaction) {
      return transaction.date
          .isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _updateTransaction(String id, String newTitle, double newAmount, DateTime selectedDate){
    DBhelper.update('transactions', id, {
    'id': id,
    'amount': newAmount,
    'title': newTitle,
    'date': selectedDate.toString()
    }).catchError((error){
      print(error);
      return;
    });
    setState(() {
      int ind = transactions.indexWhere((tx) => tx.id == id);
      transactions[ind] = Transactions(id: id, date: selectedDate, amount: newAmount, title: newTitle);
    });
  }

  void _deleteTransaction(String id) {
    DBhelper.delete('transactions', id);
    setState(() {
      transactions.removeWhere((transaction) => transaction.id == id);
    });
  }
  void _updateWidget(String widget){
    setState(() {
      _selectedWidget = widget;
    });
  }


  @override
  void initState() {
    fetchTransactions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(_selectedWidget);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: const Center(child: Text("Expenses Visualizer")),
      bottom: TabBar(
        tabs: [
          Tab(
            child: Text("Last Week",textAlign: TextAlign.center),
            icon: Icon(Icons.view_week),
          ),
          Tab(
            child: Text("Today"),
            icon: Icon(Icons.today),
          ),
          Tab(
            child: Text(
              "Recently Added",
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            icon: Icon(Icons.fiber_new),
          ),
          Tab(
            child: Text(
              "Custom",
              textAlign: TextAlign.center,
            ),
            icon: Icon(Icons.more),
          ),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () => _showAddNewTransactionModal(context),
            icon: Icon(Icons.add))
      ],
    );
    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                appBar.preferredSize.height) *
            0.7,
        child: TransactionList(_recentTransactions.reversed.toList(), _deleteTransaction,_updateTransaction));

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: appBar,
        body: Column(
          children: [
            SliderWidget(_updateWidget),
            if(_selectedWidget == "Default") Expanded(
              child: TabBarView(
                children: [
                  LastWeekScreen(transactions, isLandscape, appBar, txListWidget,updateTotal),
                  TodayScreen(transactions,_deleteTransaction,_updateTransaction),
                  RecentlyAddedScreen(transactions, _deleteTransaction,_updateTransaction),
                  CustomScreen(transactions,_deleteTransaction,_updateTransaction),
                ],
              ),
            ),
            if(_selectedWidget == "Today") Expanded(child: TodayScreen(transactions, _deleteTransaction,_updateTransaction)),
            if(_selectedWidget == "Yesterday") Expanded(child: YesterdayScreen(transactions, _deleteTransaction,_updateTransaction)),
            if(_selectedWidget == "Last Week") Expanded(child: LastWeekScreen(transactions, isLandscape, appBar, txListWidget,updateTotal)),
            if(_selectedWidget == "Last Month") Expanded(child: LastMonthScreen(transactions, _deleteTransaction,_updateTransaction)),
            if(_selectedWidget == "Last Year") Expanded(child: LastYearScreen(transactions, _deleteTransaction,_updateTransaction)),

          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _showAddNewTransactionModal(context)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
