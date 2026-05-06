import 'package:flutter/material.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_text_styles.dart';
import '../../../../data/models/digital_map_models.dart';

/// Tab thống kê dữ liệu bản đồ.
class MapStatisticsTab extends StatelessWidget {
  final List<MapStatistic> statistics;
  final List<AdminZone> adminZones;

  const MapStatisticsTab({
    super.key,
    required this.statistics,
    required this.adminZones,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Stat cards
        GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: statistics.map((s) => _StatCard(stat: s)).toList(),
        ),

        const SizedBox(height: 24),

        // Admin zones header
        Row(
          children: [
            const Icon(Icons.map_rounded,
                color: AppColors.primaryBlue, size: 18),
            const SizedBox(width: 8),
            Text('Đơn vị hành chính', style: AppTextStyles.h4),
          ],
        ),
        const SizedBox(height: 12),

        // Admin zone list
        ...adminZones.map((z) => _AdminZoneTile(zone: z)),

        const SizedBox(height: 40),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final MapStatistic stat;

  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    final trendColor = stat.trend == MapStatisticTrend.up
        ? AppColors.successGreen
        : stat.trend == MapStatisticTrend.down
            ? AppColors.alertRed
            : AppColors.textSecondary;

    final trendIcon = stat.trend == MapStatisticTrend.up
        ? Icons.trending_up_rounded
        : stat.trend == MapStatisticTrend.down
            ? Icons.trending_down_rounded
            : Icons.trending_flat_rounded;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [AppColors.lightShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            stat.label,
            style: AppTextStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: stat.value,
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    TextSpan(
                      text: ' ${stat.unit}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(trendIcon, size: 12, color: trendColor),
                  const SizedBox(width: 3),
                  Text(
                    stat.trendText,
                    style:
                        AppTextStyles.label.copyWith(color: trendColor),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdminZoneTile extends StatelessWidget {
  final AdminZone zone;

  const _AdminZoneTile({required this.zone});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [AppColors.lightShadow],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primaryBlueLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.location_city_rounded,
                color: AppColors.primaryBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(zone.name, style: AppTextStyles.bodyMedium),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlueLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        zone.type,
                        style: AppTextStyles.label.copyWith(
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _InfoTag(
                        icon: Icons.people_outline,
                        text: _formatNum(zone.population)),
                    const SizedBox(width: 12),
                    _InfoTag(
                        icon: Icons.straighten_rounded,
                        text: '${zone.area} km²'),
                    const SizedBox(width: 12),
                    _InfoTag(
                        icon: Icons.construction_rounded,
                        text: '${zone.projectCount} CT'),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.textSecondary, size: 18),
        ],
      ),
    );
  }

  String _formatNum(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(1)}K';
    }
    return n.toString();
  }
}

class _InfoTag extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoTag({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: AppColors.textSecondary),
        const SizedBox(width: 3),
        Text(text, style: AppTextStyles.label),
      ],
    );
  }
}
