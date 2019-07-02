import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChartPoint {
  final double x;
  final double y;

  ChartPoint(this.x, this.y);
}


class CurvedChartLine {
  final List<ChartPoint> points;

  CurvedChartLine(this.points);
}


class CustomChart extends StatefulWidget {

  final CurvedChartLine chartLine;

  const CustomChart(this.chartLine, {Key key, }) : super(key: key);

  @override
  _CustomChartState createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 600));

    Animation curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    animation = Tween(begin: 0.0, end: 1).animate(curve);


    _controller.forward();
    _controller.repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 250,
      child: _AnimatedChart(widget.chartLine, 250, 250, animation: animation),
    );
  }
}

class _AnimatedChart extends AnimatedWidget {
  final double height;
  final double width;
  final CurvedChartLine chartLine;

  _AnimatedChart(this.chartLine, this.width, this.height, {Key key, Animation animation}) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable as Animation;

    return CustomPaint(
      painter: ChartPainter(animation.value, chartLine),
    );
  }
}

class ChartPainter extends CustomPainter {

  final double progress;
  final CurvedChartLine chartLine;

  ChartPainter(this.progress, this.chartLine);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.yellow;

    double maxWidth;

    List<ChartPoint> sorted = List.of(chartLine.points);

    sorted.sort((a, b) => b.x.compareTo(a.x));
    maxWidth = sorted.first.x;

    canvas.drawRect(Rect.fromLTWH(0, 0, maxWidth, 200), paint);

    paint.color = Colors.black87;

    Path path = Path();
    path.moveTo(0, 200);

    chartLine.points.forEach((p) {
      double y = maxWidth - (p.y * progress);

      path.lineTo(p.x, y);
      canvas.drawCircle(Offset(p.x, y), 3, paint);
    });

    paint.color = Colors.green;
    canvas.drawPath(path, paint
    );

    //canvas.drawRect(Rect.fromLTWH(10, 10, 200 * progress, 200 * progress), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}