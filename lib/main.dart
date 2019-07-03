import 'package:chart_library/chart/chart_line.dart';
import 'package:chart_library/chart/chart_point.dart';
import 'package:chart_library/chart/line_chart.dart';
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
    LineChart lineChart = LineChart([createLine(), createLine2()]);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              SizedBox(width: 200, height: 250, child: Text('hat')),
               Expanded(child: CustomChart(lineChart)),
                   SizedBox(width: 200, height: 200, child: Text('hat')),
                   ]
          ),
        ),
      );
  }

  ChartLine createLine() {
    List<ChartPoint> points = [
    ChartPoint(10.0, 30.0),
    ChartPoint(20.0, 40.0),
    ChartPoint(30.0, 50.0),
    ChartPoint(55.0, 40.4),
    ChartPoint(90.0, 32.0),
    ];
    ChartLine line1 = ChartLine(points, Colors.green, 'W');
    return line1;
  }


  ChartLine createLine2() {
    List<ChartPoint> points = [
      ChartPoint(15.0, 14.0),
      ChartPoint(25.0, 50.0),
      ChartPoint(35.0, 30.344444),
      ChartPoint(60.0, 54.4),
      ChartPoint(95.0, 16.0),
      ChartPoint(115.0, 32.0),
    ];
    ChartLine line1 = ChartLine(points, Colors.blue, 'W');
    return line1;
  }
}
