import 'package:flutter/material.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../../../core/values/app_constants.dart';
import '../../../../data/models/dashboard_models.dart';

/// Biểu đồ đường hiệu suất tuần — vẽ bằng CustomPainter, không cần thêm lib.
class WeeklyPerformanceChart extends StatelessWidget {
  final List<ChartDataPoint> data;

  const WeeklyPerformanceChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
        boxShadow: [AppColors.lightShadow],
      ),
      child: Column(
        children: [
          // Chart area
          SizedBox(
            height: 120,
            child: CustomPaint(
              size: const Size(double.infinity, 120),
              painter: _ChartPainter(data),
            ),
          ),
          const SizedBox(height: 8),

          // X-axis labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: data
                .map((point) => Text(
                      point.label,
                      style: AppTextStyles.caption.copyWith(fontSize: 11),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// Custom painter cho biểu đồ đường.
class _ChartPainter extends CustomPainter {
  final List<ChartDataPoint> data;

  _ChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxValue = data.map((e) => e.value).reduce((a, b) => a > b ? a : b);
    final minValue = data.map((e) => e.value).reduce((a, b) => a < b ? a : b);
    final range = (maxValue - minValue).clamp(1.0, double.infinity);

    final paddingTop = 10.0;
    final paddingBottom = 5.0;
    final chartHeight = size.height - paddingTop - paddingBottom;

    // Calculate points
    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final normalized = (data[i].value - minValue) / range;
      final y = paddingTop + chartHeight * (1 - normalized);
      points.add(Offset(x, y));
    }

    // Draw gradient area under curve
    final gradientPath = Path()..moveTo(points.first.dx, size.height);
    for (final p in points) {
      gradientPath.lineTo(p.dx, p.dy);
    }
    gradientPath.lineTo(points.last.dx, size.height);
    gradientPath.close();

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primaryBlue.withValues(alpha: 0.15),
          AppColors.primaryBlue.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(gradientPath, gradientPaint);

    // Draw smooth curve
    final linePaint = Paint()
      ..color = AppColors.primaryBlue
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final controlX = (prev.dx + curr.dx) / 2;
      linePath.cubicTo(controlX, prev.dy, controlX, curr.dy, curr.dx, curr.dy);
    }
    canvas.drawPath(linePath, linePaint);

    // Draw dots
    final dotPaint = Paint()..color = AppColors.primaryBlue;
    final dotBorderPaint = Paint()
      ..color = AppColors.cardWhite
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    for (final p in points) {
      canvas.drawCircle(p, 4, dotPaint);
      canvas.drawCircle(p, 4, dotBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
