import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String dayLabel;
  final double spendingAmount;
  final double percentOfTotalSpentAmount;

  ChartBar(this.dayLabel,this.percentOfTotalSpentAmount,this.spendingAmount);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context,constraints){
      return Column(
        children: [
          FittedBox(child: Text("\$${spendingAmount.toStringAsFixed(0)}")),
          SizedBox(height: constraints.maxHeight * 0.10,),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                FractionallySizedBox(heightFactor: percentOfTotalSpentAmount,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(height: constraints.maxHeight * 0.15 ,child: Text(dayLabel)),
        ],
      );
    },

    );
  }
}
