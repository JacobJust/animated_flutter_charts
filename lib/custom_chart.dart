import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChartPoint {
  final double x;
  final double y;

  ChartPoint(this.x, this.y);
}


class CurvedChartLine {
  final List<ChartPoint> points;

  double _minX;
  double _minY;
  double _maxX;
  double _maxY;

  CurvedChartLine(this.points) {
    if (points.length > 0) {
      _minX = points[0].x;
      _maxX = points[0].x;
      _minY = points[0].y;
      _maxY = points[0].y;
    }

    points.forEach((p) {
      if (p.x < _minX) {
        _minX = p.x;
      }
      if (p.x > _maxX) {
        _maxX = p.x;
      }
      if (p.y < _minY) {
        _minY = p.y;
      }
      if (p.y > _maxY) {
        _maxY = p.y;
      }
    });
  }

  double get width => _maxX - _minX;
  double get height => _maxY - _minY;
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

    Animation curve = CurvedAnimation(parent: _controller, curve: Curves.easeInOutExpo);

    animation = Tween(begin: 0.0, end: 1.0).animate(curve);

    _controller.forward();

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
      painter: ChartPainter(animation?.value, chartLine),
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
      ..strokeWidth = 1
      ..color = Colors.black12;

    canvas.drawRect(Rect.fromLTWH(0, 0, 200, 200), paint);

    paint.strokeWidth = 0.5;
    for(double c = 40; c < 200; c += 40) {
      canvas.drawLine(Offset(0, c), Offset(200, c), paint);
      canvas.drawLine(Offset(c, 0), Offset(c, 200), paint);
    }
    paint.strokeWidth = 2;

    paint.color = Colors.black87;

    Path path = Path();
    bool init = true;

    chartLine.points.forEach((p) {
      double xScale = 200.0/chartLine.width;
      double xOffset = chartLine._minX * xScale;
      double x = (p.x * xScale) - xOffset;

      double yScale = 180.0/chartLine.height;

      double adjustedY = (p.y * yScale) - (chartLine._minY * yScale);
      double y = 200  - (adjustedY * progress);

      if (init) {
        init = false;
        path.moveTo(x, y);
      }

      path.lineTo(x, y);
      canvas.drawCircle(Offset(x, y), 3, paint);
    });

    paint.color = Colors.green;
    canvas.drawPath(path, paint
    );

    TextSpan span = new TextSpan(style: new TextStyle(color: Colors.blue[800]), text: 'hat');
    TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, new Offset(5.0, 5.0));

    //canvas.drawRect(Rect.fromLTWH(10, 10, 200 * progress, 200 * progress), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}