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
      ChartPoint(55.0, 50.0),
      ChartPoint(90.0, 32.0),
      ChartPoint(100.0, 32.0),
      ChartPoint(110.0, 36.0),
    ];
    CurvedChartLine curvedChartLine = CurvedChartLine(points);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Container(
          child: Stack(children: [
            Positioned(top: 300, right: 20, child: Container(child: Text('hatX'))),
            Positioned(
              child: SizedBox(
                height: 350,
                width: MediaQuery.of(context).size.width,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    RenderBox box = context.findRenderObject();
                    checkMapValues();
                  },
                  child: CustomChart(
                    curvedChartLine,
                    key: new GlobalKey<RefreshIndicatorState>(),
                  ),
                ),
              ),
            ),
            Positioned(left: 20, child: Container(child: Text('hatY')))
          ]),
        ),
      ),
    );
  }

  void checkMapValues() {
    mapOfCoordinates.forEach((key, value) {
      print(key + ', '+ value);
    });
  }
}
