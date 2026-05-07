import 'package:flutter/material.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../../../core/values/app_constants.dart';
import '../../../../data/models/dashboard_models.dart';

/// Grid 2x2 hiển thị 4 KPI cards.
class KpiSummaryGrid extends StatelessWidget {
  final List<KpiSummary> items;
  final ValueChanged<KpiSummary>? onItemTap;

  const KpiSummaryGrid({
    super.key,
    required this.items,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.92,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _KpiCard(
        kpi: items[index],
        onTap: onItemTap == null ? null : () => onItemTap!(items[index]),
      ),
    );
  }
}

/// Card KPI đơn lẻ.
class _KpiCard extends StatelessWidget {
  final KpiSummary kpi;
  final VoidCallback? onTap;

  const _KpiCard({
    required this.kpi,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
          boxShadow: [AppColors.lightShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            _buildIcon(),
            const SizedBox(height: 10),

            // Title
            Text(
              kpi.title,
              style: AppTextStyles.label.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 4),

            // Value + unit
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  kpi.value,
                  style: AppTextStyles.h2.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 26,
                  ),
                ),
                Text(
                  kpi.unit,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            // Description
            Flexible(
              child: Text(
                kpi.description,
                style: AppTextStyles.caption.copyWith(fontSize: 11),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 6),

            // Trend
            if (kpi.trend != null) _buildTrend(),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData icon;
    Color bgColor;
    Color iconColor;

    switch (kpi.iconType) {
      case KpiIconType.project:
        icon = Icons.trending_up_rounded;
        bgColor = AppColors.primaryBlue.withValues(alpha: 0.1);
        iconColor = AppColors.primaryBlue;
        break;
      case KpiIconType.staff:
        icon = Icons.people_outline_rounded;
        bgColor = AppColors.successGreen.withValues(alpha: 0.1);
        iconColor = AppColors.successGreen;
        break;
      case KpiIconType.meeting:
        icon = Icons.event_note_rounded;
        bgColor = AppColors.warningYellow.withValues(alpha: 0.15);
        iconColor = const Color(0xFFE6A817);
        break;
      case KpiIconType.resident:
        icon = Icons.folder_open_rounded;
        bgColor = AppColors.alertRed.withValues(alpha: 0.1);
        iconColor = AppColors.alertRed;
        break;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 20, color: iconColor),
    );
  }

  Widget _buildTrend() {
    final color =
        kpi.isTrendPositive ? AppColors.successGreen : AppColors.alertRed;
    final prefix = kpi.isTrendPositive ? '↑' : '↓';

    return Row(
      children: [
        Text(
          prefix,
          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 2),
        Flexible(
          child: Text(
            kpi.trend!,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
