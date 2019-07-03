import 'package:chart_library/chart/chart_line.dart';
import 'package:chart_library/chart/chart_point.dart';
import 'package:chart_library/chart/highlight_point.dart';
import 'package:chart_library/main.dart';

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
  }

  double get heightStepSize => _heightStepSize;
  double get widthStepSize => _widthStepSize;

  double get yScale => _yScale;
  double get xOffset => _xOffset;
  double get xScale => _xScale;

  Map<int, List<HighlightPoint>> get seriesMap => _seriesMap;


}