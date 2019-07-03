import 'package:chart_library/chart/chart_line.dart';
import 'package:chart_library/main.dart';

class LineChart {
  final List<ChartLine> lines;
  final Dates fromTo;
  double _minX;
  double _minY;
  double _maxX;
  double _maxY;

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
}