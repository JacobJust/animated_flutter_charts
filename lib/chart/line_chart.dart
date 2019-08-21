import 'package:chart_library/chart/chart_line.dart';
import 'package:chart_library/chart/chart_point.dart';
import 'package:chart_library/chart/highlight_point.dart';
import 'package:chart_library/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class LineChart {
  static final double axisOffsetPX = 50.0;
  static final double stepCount = 5;

  final List<ChartLine> lines;
  final Dates fromTo;
  double _minX;
  double _minY;
  double _maxX;
  double _maxY;

  double _widthStepSize;
  double _heightStepSize;
  double _xScale;
  double _xOffset;
  double _yScale;
  Map<int, List<HighlightPoint>> _seriesMap;
  Map<int, Path> _pathMap;
  double _yTick;
  double _axisOffSetWithPadding;
  List<TextPainter> _axisTexts;
  List<TextPainter> _yAxisTexts;

  LineChart(this.lines, this.fromTo) {
      if (lines.length > 0) {
        _minX = lines[0].minX;
        _maxX = lines[0].maxX;
        _minY = lines[0].minY;
        _maxY = lines[0].maxY;
      }

      lines.forEach((p) {
        if (p.minX < _minX) {
          _minX = p.minX;
        }
        if (p.maxX > _maxX) {
          _maxX = p.maxX;
        }
        if (p.minY < _minY) {
          _minY = p.minY;
        }
        if (p.maxY > _maxY) {
          _maxY = p.maxY;
        }
      });
  }

  double get width => _maxX - _minX;
  double get height => _maxY - _minY;

  double get minX => _minX;
  double get minY => _minY;
  double get maxX => _maxX;
  double get maxY => _maxY;

  //Calculate ui pixels values
  void initialize(double widthPX, double heightPX) {
    _widthStepSize = (widthPX-axisOffsetPX) / (stepCount+1);
    _heightStepSize = (heightPX-axisOffsetPX) / (stepCount+1);

    _xScale = (widthPX - axisOffsetPX)/width;
    _xOffset = minX * _xScale;
    _yScale = (heightPX - axisOffsetPX - 20)/height;

    _seriesMap = Map();
    _pathMap = Map();

    int index = 0;
    lines.forEach((chartLine) {
      chartLine.points.forEach((p) {
        double x = (p.x * xScale) - xOffset;

        double adjustedY = (p.y * yScale) - (minY * yScale);
        double y = (heightPX - axisOffsetPX) - adjustedY;

        //adjust to make room for axis values:
        x += axisOffsetPX;
        if (_seriesMap[index] == null) {
          _seriesMap[index] = List();
        }

        _seriesMap[index].add(HighlightPoint(ChartPoint(x, y), p.y));
      });

      index++;
    });

    _yTick = height / 5;

    _axisOffSetWithPadding = axisOffsetPX - 5.0;

    _axisTexts = [];

    for (int c = 0; c <= (stepCount + 1); c++) {
      TextSpan span = new TextSpan(style: new TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w200, fontSize: 10), text: '${(minY + yTick * c).round()}');
      TextPainter tp = new TextPainter(text: span, textAlign: TextAlign.right, textDirection: TextDirection.ltr);
      tp.layout();

      _axisTexts.add(tp);
    }

    _yAxisTexts = [];

    double chartDuration = fromTo.max.difference(fromTo.min).inSeconds.toDouble();
    double stepInSeconds = chartDuration / (stepCount + 1);


    for (int c = 0; c <= (stepCount + 1); c++) {
      //drawText(canvas, '02/07/2019', 45.0 + (c * widthStepSize), size.height - 45, (pi / 2) + pi);
      DateTime tick = fromTo.min.add(Duration(seconds: (stepInSeconds * c).round()));

      TextSpan span = new TextSpan(
          style: new TextStyle(color: Colors.grey[800], fontSize: 11.0, fontWeight: FontWeight.w200), text: '${tick.hour}:${tick.minute}');
      TextPainter tp = new TextPainter(
          text: span, textAlign: TextAlign.right,
          textDirection: TextDirection.ltr);
      tp.layout();

      _yAxisTexts.add(tp);
    }
  }

  double get heightStepSize => _heightStepSize;
  double get widthStepSize => _widthStepSize;

  double get yScale => _yScale;
  double get xOffset => _xOffset;
  double get xScale => _xScale;

  Map<int, List<HighlightPoint>> get seriesMap => _seriesMap;

  double get yTick => _yTick;

  double get axisOffSetWithPadding => _axisOffSetWithPadding;

  List<TextPainter> get axisTexts => _axisTexts;

  List<TextPainter> get yAxisTexts => _yAxisTexts;

  List<HighlightPoint> getClosetHighlightPoints(double horizontalDragPosition) {
    List<HighlightPoint> highlights = List();

    seriesMap.forEach((key, list) {
      HighlightPoint closest = _findClosest(list, horizontalDragPosition);
      highlights.add(closest);
    });

    HighlightPoint last;
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

    return highlights;
  }

  HighlightPoint _findClosest(List<HighlightPoint> list, double horizontalDragPosition) {
    HighlightPoint candidate = list[0];

    double candidateDist = ((candidate.chartPoint.x) - horizontalDragPosition).abs();
    list.forEach((alternative) {
      double alternativeDist = ((alternative.chartPoint.x) - horizontalDragPosition).abs();

      if (alternativeDist < candidateDist) {
        candidate = alternative;
        candidateDist = ((candidate.chartPoint.x) - horizontalDragPosition).abs();
      }
      if (alternativeDist > candidateDist) {
        return candidate;
      }
    });

    return candidate;
  }

  Path getPathCache(int index) {
    if (_pathMap.containsKey(index)) {
      return _pathMap[index];
    } else {
      Path path = Path();

      bool init = true;

      this.seriesMap[index].forEach((p) {
        if (init) {
          init = false;
          path.moveTo(p.chartPoint.x, p.chartPoint.y);
        }

        path.lineTo(p.chartPoint.x, p.chartPoint.y);
      });

      _pathMap[index] = path;

      return path;
    }
  }
}