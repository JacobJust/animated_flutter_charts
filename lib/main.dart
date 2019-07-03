import 'package:chart_library/chart/chart_line.dart';
import 'package:chart_library/chart/datetime_chart_point.dart';
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

class Dates {
  final DateTime min;
  final DateTime max;

  Dates(this.min, this.max);
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Map<DateTime, double> line1 = createLineData();
    Map<DateTime, double> line2 = createLine2();

    Dates minMax = findMinMax([line1, line2]);

    LineChart lineChart = LineChart([convert(line1, minMax, Colors.green), convert(line2, minMax, Colors.blue)], minMax);

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

  Map<DateTime, double> createLineData() {
    Map<DateTime, double> data = {};
    data[DateTime.now().subtract(Duration(minutes: 30))] = 30.0;
    data[DateTime.now().subtract(Duration(minutes: 25))] = 40.0;
    data[DateTime.now().subtract(Duration(minutes: 20))] = 33.0;
    data[DateTime.now().subtract(Duration(minutes: 15))] = 22.0;
    data[DateTime.now().subtract(Duration(minutes: 10))] = 13.0;
    data[DateTime.now().subtract(Duration(minutes: 5))] = 57.0;

    return data;
  }


  Map<DateTime, double> createLine2() {
    Map<DateTime, double> data = {};
    data[DateTime.now().subtract(Duration(minutes: 40))] = 11.0;
    data[DateTime.now().subtract(Duration(minutes: 30))] = 22.0;
    data[DateTime.now().subtract(Duration(minutes: 25))] = 37.0;
    data[DateTime.now().subtract(Duration(minutes: 20))] = 31.0;
    data[DateTime.now().subtract(Duration(minutes: 15))] = 29.0;
    data[DateTime.now().subtract(Duration(minutes: 10))] = 11.0;
    data[DateTime.now().subtract(Duration(minutes: 5))] = 37.0;

    return data;
  }

  Dates findMinMax(List<Map<DateTime, double>> list) {
    DateTime min;
    DateTime max;

    list.forEach((map) {
      map.keys.forEach((dateTime) {
        if (min == null) {
          min = dateTime;
          max = dateTime;
        } else {
          if (dateTime.isBefore(min)) {
            min = dateTime;
          }
          if (dateTime.isAfter(max)) {
            max = dateTime;
          }
        }
      });
    });

    return Dates(min, max);
  }

  ChartLine convert(Map<DateTime, double> input, Dates minMax, Color color) {
    DateTime from = minMax.min;

    List<DateTimeChartPoint> result = [];

    input.forEach((dateTime, value) {
      double x = dateTime.difference(from).inSeconds.toDouble();
      double y = value;
      result.add(DateTimeChartPoint(x, y, dateTime));
    });

    return ChartLine(result, color, 'W');
  }
}
