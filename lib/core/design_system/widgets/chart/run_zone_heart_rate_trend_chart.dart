import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app_color_scheme.dart';
import '../../app_sizing.dart';
import '../../../../features/heart_rate/domain/heart_rate_zone.dart';
import '../../../../features/heart_rate/domain/heart_rate_zone_range.dart';

const _lineStrokeWidth = 2.0;
const _lastPointRadius = 3.0;
const _zoneBandOpacity = 0.1;
const _targetZoneBandOpacity = 0.2;
const _targetZoneBorderOpacity = 0.5;
const _targetZoneBorderStrokeWidth = 1.0;

final class RunZoneHeartRateTrendChart extends StatelessWidget {
  const RunZoneHeartRateTrendChart({
    required this.heartRates,
    required this.heartRateZoneTable,
    required this.targetHeartRateZone,
    super.key,
  });

  final List<int?> heartRates;
  final HeartRateZoneTable heartRateZoneTable;
  final HeartRateZone targetHeartRateZone;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      height: AppSizing.heartRateTrendChartHeight,
      child: CustomPaint(
        painter: _RunZoneHeartRateTrendChartPainter(
          heartRates: heartRates,
          heartRateZoneTable: heartRateZoneTable,
          targetHeartRateZone: targetHeartRateZone,
          colorScheme: colorScheme,
        ),
      ),
    );
  }
}

final class _RunZoneHeartRateTrendChartPainter extends CustomPainter {
  const _RunZoneHeartRateTrendChartPainter({
    required this.heartRates,
    required this.heartRateZoneTable,
    required this.targetHeartRateZone,
    required this.colorScheme,
  });

  final List<int?> heartRates;
  final HeartRateZoneTable heartRateZoneTable;
  final HeartRateZone targetHeartRateZone;
  final ColorScheme colorScheme;

  List<_RunZoneHeartRateZoneBand> get _zoneBands {
    return [
      _zoneBand(HeartRateZone.zone1, heartRateZoneTable.zone1, colorScheme.zoneOne),
      _zoneBand(HeartRateZone.zone2, heartRateZoneTable.zone2, colorScheme.zoneTwo),
      _zoneBand(HeartRateZone.zone3, heartRateZoneTable.zone3, colorScheme.zoneThree),
      _zoneBand(HeartRateZone.zone4, heartRateZoneTable.zone4, colorScheme.zoneFour),
      _zoneBand(HeartRateZone.zone5, heartRateZoneTable.zone5, colorScheme.zoneFive),
    ];
  }

  @override
  void paint(Canvas canvas, Size size) {
    _drawZoneBands(canvas, size);

    final lastHeartRateIndex = heartRates.lastIndexWhere((heartRate) => heartRate != null);
    if (lastHeartRateIndex == -1) {
      return;
    }

    final path = Path();
    var hasActivePath = false;
    for (var index = 0; index < heartRates.length; index++) {
      final heartRate = heartRates[index];
      if (heartRate == null) {
        hasActivePath = false;
        continue;
      }

      final point = _pointFor(index, heartRate, size);
      if (!hasActivePath) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
      hasActivePath = true;
    }

    final lastHeartRate = heartRates[lastHeartRateIndex]!;
    final linePaint = Paint()
      ..color = _heartRateColor(lastHeartRate)
      ..style = PaintingStyle.stroke
      ..strokeWidth = _lineStrokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    _drawLastPoint(canvas, _pointFor(lastHeartRateIndex, lastHeartRate, size), _heartRateColor(lastHeartRate));
  }

  void _drawZoneBands(Canvas canvas, Size size) {
    final zoneBands = _zoneBands;
    for (var index = 0; index < zoneBands.length; index++) {
      final zoneBand = zoneBands[index];
      final rect = _rectForZone(index, zoneBands.length, size);
      final top = rect.top;
      final bottom = rect.bottom;
      final fillPaint = Paint()
        ..color = zoneBand.color.withValues(alpha: zoneBand.isTarget ? _targetZoneBandOpacity : _zoneBandOpacity)
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, fillPaint);

      if (zoneBand.isTarget) {
        final borderPaint = Paint()
          ..color = zoneBand.color.withValues(alpha: _targetZoneBorderOpacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = _targetZoneBorderStrokeWidth;
        canvas.drawLine(Offset(0, top), Offset(size.width, top), borderPaint);
        canvas.drawLine(Offset(0, bottom), Offset(size.width, bottom), borderPaint);
      }
    }
  }

  void _drawLastPoint(Canvas canvas, Offset point, Color color) {
    final pointPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(point, _lastPointRadius, pointPaint);
  }

  Offset _pointFor(int index, int heartRate, Size size) {
    final progress = heartRates.length == 1 ? 1.0 : index / (heartRates.length - 1);
    final x = progress * size.width;
    final y = _yFor(heartRate, size);
    return Offset(x, y);
  }

  double _yFor(int heartRate, Size size) {
    final zoneBands = _zoneBands;
    final zoneIndex = _zoneIndexFor(heartRate, zoneBands);
    final zoneBand = zoneBands[zoneIndex];
    final zoneRect = _rectForZone(zoneIndex, zoneBands.length, size);
    final progress = ((heartRate - zoneBand.lowerHeartRate) / (zoneBand.upperHeartRate - zoneBand.lowerHeartRate))
        .clamp(0.0, 1.0);
    return zoneRect.bottom - progress * zoneRect.height;
  }

  Color _heartRateColor(int heartRate) {
    final zoneBands = _zoneBands;
    return zoneBands[_zoneIndexFor(heartRate, zoneBands)].color;
  }

  Rect _rectForZone(int zoneIndex, int zoneCount, Size size) {
    final zoneHeight = size.height / zoneCount;
    final visualIndex = zoneCount - zoneIndex - 1;
    final top = visualIndex * zoneHeight;
    return Rect.fromLTWH(0, top, size.width, zoneHeight);
  }

  int _zoneIndexFor(int heartRate, List<_RunZoneHeartRateZoneBand> zoneBands) {
    for (var index = 0; index < zoneBands.length; index++) {
      final zoneBand = zoneBands[index];
      if (heartRate <= zoneBand.upperHeartRate) {
        return index;
      }
    }

    return zoneBands.length - 1;
  }

  _RunZoneHeartRateZoneBand _zoneBand(HeartRateZone heartRateZone, HeartRateZoneRange range, Color color) {
    return _RunZoneHeartRateZoneBand(
      lowerHeartRate: range.lower,
      upperHeartRate: range.upper,
      color: color,
      isTarget: heartRateZone == targetHeartRateZone,
    );
  }

  @override
  bool shouldRepaint(covariant _RunZoneHeartRateTrendChartPainter oldDelegate) {
    return !listEquals(heartRates, oldDelegate.heartRates) ||
        heartRateZoneTable != oldDelegate.heartRateZoneTable ||
        targetHeartRateZone != oldDelegate.targetHeartRateZone ||
        colorScheme != oldDelegate.colorScheme;
  }
}

final class _RunZoneHeartRateZoneBand {
  const _RunZoneHeartRateZoneBand({
    required this.lowerHeartRate,
    required this.upperHeartRate,
    required this.color,
    required this.isTarget,
  });

  final int lowerHeartRate;
  final int upperHeartRate;
  final Color color;
  final bool isTarget;
}
