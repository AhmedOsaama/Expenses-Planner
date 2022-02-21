import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/last_week_screen.dart';

class SliderWidget extends StatefulWidget {
  final Function updateWidget;

  SliderWidget(this.updateWidget);

  @override
  _SliderWidgetState createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  String selectedWidget = "";
  double _currentSliderValue = 0;


  final options = ["Default","Today","Yesterday","Last Week","Last Month","Last Year"];

  void updateValue(double value){
    setState(() {
      selectedWidget = options[value.toInt()];
      _currentSliderValue = value;
    });
    widget.updateWidget(selectedWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Slider(value: _currentSliderValue, min: 0,max: 5,label: selectedWidget, divisions: 5, onChanged: updateValue);
  }
}
