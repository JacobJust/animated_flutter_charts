import 'dart:ui';

import 'package:chart_library/chart/chart_point.dart';

class ChartLine {
  final List<ChartPoint> points;
  final Color color;
  final String unit;

  double _minX;
  double _minY;
  double _maxX;
  double _maxY;

  ChartLine(this.points, this.color, this.unit) {
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

  double get minX => _minX;
  double get minY => _minY;
  double get maxX => _maxX;
  double get maxY => _maxY;
}
