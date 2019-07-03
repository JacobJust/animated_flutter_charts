import 'dart:math';

import 'package:chart_library/chart/chart_point.dart';
import 'package:chart_library/chart/highlight_point.dart';
import 'package:chart_library/chart/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomChart extends StatefulWidget {

  final LineChart chart;

  const CustomChart(this.chart, {Key key, }) : super(key: key);

  @override
  _CustomChartState createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation animation;

  bool horizontalDragActive = false;
  double horizontalDragPosition = 0.0;

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
    return Padding(
      padding: EdgeInsets.only(right: ChartPainter.axisOffset),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
              return GestureDetector(
                  child: _AnimatedChart(widget.chart, constraints.maxWidth, constraints.maxHeight, horizontalDragActive, horizontalDragPosition, animation: animation,),
                  onHorizontalDragStart: (dragStartDetails) {
                    horizontalDragActive = true;
                    horizontalDragPosition = dragStartDetails.globalPosition.dx;
                    setState(() {
                    });
                  },
                onHorizontalDragUpdate: (dragUpdateDetails) {
                  horizontalDragPosition += dragUpdateDetails.primaryDelta;
                    setState(() {
                    });
                },
                onHorizontalDragEnd: (dragEndDetails) {
                  horizontalDragActive = false;
                  horizontalDragPosition = 0.0;
                  setState(() {
                  });
                },
              );
          }
      ),
    );
  }
}

class _AnimatedChart extends AnimatedWidget {
  final double height;
  final double width;
  final LineChart chart;
  final bool horizontalDragActive;
  final double horizontalDragPosition;

  _AnimatedChart(this.chart, this.width, this.height, this.horizontalDragActive, this.horizontalDragPosition, {Key key, Animation animation}) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable as Animation;

    return CustomPaint(
      painter: ChartPainter(animation?.value, chart, horizontalDragActive, horizontalDragPosition),
    );
  }
}

class ChartPainter extends CustomPainter {

  static final double axisOffset = 50.0;
  static final double stepCount = 5;

  final double progress;
  final LineChart chart;
  final bool horizontalDragActive;
  final double horizontalDragPosition;

  Map<int, List<HighlightPoint>> seriesMap = Map();

  ChartPainter(this.progress, this.chart, this.horizontalDragActive, this.horizontalDragPosition);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();

    paint..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.black26;

    canvas.drawRect(Rect.fromLTWH(axisOffset, 0, size.width - axisOffset, size.height - axisOffset), paint);

    paint.strokeWidth = 0.5;

    double widthStepSize = (size.width-axisOffset) / (stepCount+1);
    double heightStepSize = (size.height-axisOffset) / (stepCount+1);

    for(double c = 1; c <= stepCount; c ++) {
      canvas.drawLine(Offset(axisOffset, c*heightStepSize), Offset(size.width, c*heightStepSize), paint);
      canvas.drawLine(Offset(c*widthStepSize + axisOffset, 0), Offset(c*widthStepSize + axisOffset, size.height-axisOffset), paint);
    }

    paint.strokeWidth = 2;

    double xScale = (size.width - axisOffset)/chart.width;
    double xOffset = chart.minX * xScale;
    double yScale = (size.height - axisOffset - 20)/chart.height;

    bool addToMap = seriesMap.length == 0;
    int index = 0;

    chart.lines.forEach((chartLine) {
      paint.color = chartLine.color;
      Path path = Path();
      bool init = true;

      chartLine.points.forEach((p) {
        double x = (p.x * xScale) - xOffset;

        double adjustedY = (p.y * yScale) - (chart.minY * yScale);
        double y = (size.height - axisOffset) - (adjustedY * progress);

        //adjust to make room for axis values:
        x += axisOffset;

        if (init) {
          init = false;
          path.moveTo(x, y);
        }

        path.lineTo(x, y);
        canvas.drawCircle(Offset(x, y), 2, paint);

        if (addToMap) {
          if (seriesMap[index] == null) {
            seriesMap[index] = List();
          }

          seriesMap[index].add(HighlightPoint(ChartPoint(x, y), p.y));
        }
      });

      canvas.drawPath(path, paint);
      index++;
    });

    //TODO: move to constructor
    double yTick = chart.height / 5;

    double axisOffSetWithPadding = axisOffset - 5.0;

    for (int c = 0; c <= (stepCount + 1); c++) {
      TextSpan span = new TextSpan(style: new TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w200, fontSize: 10), text: '${(chart.minY + yTick * c).round()}');
      TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.right, textDirection: TextDirection.ltr);
      tp.layout();
      tp.paint(canvas, new Offset(axisOffSetWithPadding - tp.width, (size.height - 6)- (c * heightStepSize) - axisOffset));
    }

    for (int c = 0; c <= (stepCount + 1); c++) {
      //drawText(canvas, '02/07/2019', 45.0 + (c * widthStepSize), size.height - 45, (pi / 2) + pi);
      drawText(canvas, 'val $c', axisOffSetWithPadding + (c * widthStepSize), size.height - axisOffSetWithPadding, pi * 1.5);
    }

    if (horizontalDragActive) {
      paint.color = Colors.teal.shade100;

      if (horizontalDragPosition > axisOffset && horizontalDragPosition < size.width) {
        canvas.drawLine(Offset(horizontalDragPosition, 0), Offset(horizontalDragPosition, size.height - axisOffset), paint);
      }

      List<HighlightPoint> highlights = List();

      seriesMap.forEach((key, list) {
        HighlightPoint closest = findClosest(list);
        highlights.add(closest);
      });

      HighlightPoint last = null;
      highlights.forEach((highlight) {
        if (last == null) {
          last = highlight;
        } else if ((last.YTextPosition.abs() - highlight.YTextPosition).abs() < 15) {
          if ((last.chartPoint.x - highlight.chartPoint.x).abs() < 30) {
            if (last.YTextPosition < highlight.YTextPosition) {
              highlight.adjustTextY(15);
            } else {
              highlight.adjustTextY(-15);
            }
          }
          last = highlight;
        }
      });


      index = 0;
      highlights.forEach((highlight) {
        canvas.drawCircle(Offset(highlight.chartPoint.x, highlight.chartPoint.y), 5, paint);

        TextSpan span = new TextSpan(style: new TextStyle(color: chart.lines[index].color, fontWeight: FontWeight.w200, fontSize: 12), text: '${highlight.yValue.toStringAsFixed(1)}');
        TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.right, textDirection: TextDirection.ltr);
        tp.layout();
        tp.paint(canvas, new Offset(highlight.chartPoint.x + 7, highlight.YTextPosition-10));

        index++;
      });
    }
  }

  void drawText(Canvas canvas, String name, double x, double y, double angleRotationInRadians) {
    TextSpan span = new TextSpan(
        style: new TextStyle(color: Colors.grey[800], fontSize: 11.0, fontWeight: FontWeight.w200), text: name);
    TextPainter tp = new TextPainter(
        text: span, textAlign: TextAlign.right,
        textDirection: TextDirection.ltr);
    tp.layout();

    canvas.save();
    canvas.translate(x, y + tp.width);
    canvas.rotate(angleRotationInRadians);
    tp.paint(canvas, new Offset(0.0,0.0));
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  HighlightPoint findClosest(List<HighlightPoint> list) {
    HighlightPoint candidate = list[0];

    list.forEach((alternative) {
      double candidateDist = (candidate.chartPoint.x - horizontalDragPosition).abs();
      double alternativeDist = (alternative.chartPoint.x - horizontalDragPosition).abs();

      if (alternativeDist < candidateDist) {
        candidate = alternative;
      }
    });

    return candidate;
  }

}