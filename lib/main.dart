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

    List<ChartPoint> points = [
    ChartPoint(10.0, 30.0),
    ChartPoint(20.0, 40.0),
    ChartPoint(30.0, 50.0),
    ChartPoint(55.0, 40.4),
    ChartPoint(90.0, 32.0),
    ];
    CurvedChartLine curvedChartLine = CurvedChartLine(points);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Stack(
            children: [
              Positioned(
                top: 360,
                  left: 360,
                  child: Text('hatX')),
              Positioned(
                  child: Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width,
                      child: CustomChart(curvedChartLine, key: new GlobalKey<RefreshIndicatorState>()))),
              Positioned(
                  child: Text('hatY')
              )
            ]
        ),
      ),
    );
  }
}
