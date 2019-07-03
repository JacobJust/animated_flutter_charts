import 'package:chart_library/chart/chart_point.dart';

class HighlightPoint {
  final ChartPoint chartPoint;
  final double yValue;
  double _deltaY = 0;

  HighlightPoint(this.chartPoint, this.yValue);

  void adjustTextY(double delta) {
    _deltaY = delta;
  }

  double get YTextPosition => chartPoint.y + _deltaY;
}