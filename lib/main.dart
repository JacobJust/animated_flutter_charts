import 'package:chart_library/custom_chart.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    CurvedChartLine curvedChartLine = CurvedChartLine([ChartPoint(0.0, 3.0),
    ChartPoint(10.0, 30.0),
    ChartPoint(20.0, 40.0),
    ChartPoint(30.0, 50.0),
    ChartPoint(40.0, 40.4),
    ChartPoint(50.0, 35.9),
    ChartPoint(60.0, 30.0),
    ChartPoint(70.0, 32.0),
    ChartPoint(80.0, 29.0),
    ChartPoint(90.0, 32.0),
    ChartPoint(100.0, 35.0),
    ChartPoint(110.0, 43.0),
    ChartPoint(120.0, 48.0),
    ChartPoint(140.0, 70.0),
    ChartPoint(150.0, 60.0),
    ChartPoint(180.0, 32.0),
    ChartPoint(190.0, 50.0),

    ]);


    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: CustomChart(curvedChartLine)
      ),
    );
  }
}
