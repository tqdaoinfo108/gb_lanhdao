part of '../home_screen.dart';

class _PeriodCompareRow extends StatelessWidget {
  final String title;
  final String current;
  final String previous;
  final double percent;
  final SmartTone tone;
  final String currentSuffix;
  final String previousSuffix;

  const _PeriodCompareRow({
    required this.title,
    required this.current,
    required this.previous,
    required this.percent,
    required this.tone,
    this.currentSuffix = '',
    this.previousSuffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      radius: 18,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SmartPill(
                label: '${_formatSignedDouble(percent)}%',
                tone: percent >= 0 ? SmartTone.success : SmartTone.danger,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PeriodMiniMetric(
                  label: 'Kỳ này',
                  value: '$current$currentSuffix',
                  tone: tone,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PeriodMiniMetric(
                  label: 'Kỳ trước',
                  value: '$previous$previousSuffix',
                  tone: SmartTone.neutral,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodMiniMetric extends StatelessWidget {
  final String label;
  final String value;
  final SmartTone tone;

  const _PeriodMiniMetric({
    required this.label,
    required this.value,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _periodToneColors(tone);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.foreground.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodItemCard extends StatelessWidget {
  final PeriodReportItem item;

  const _PeriodItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PeriodMiniMetric(
                  label: 'Công việc',
                  value: item.sumProcessDetail.toString(),
                  tone: SmartTone.accent,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PeriodMiniMetric(
                  label: 'Văn bản',
                  value: item.sumDocumentDetail.toString(),
                  tone: SmartTone.success,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PeriodMiniMetric(
                  label: 'Lịch họp',
                  value: _formatPercent(item.sumBookingDetail),
                  tone: SmartTone.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodTrendRow extends StatelessWidget {
  final PeriodTrendPoint point;

  const _PeriodTrendRow({required this.point});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: SmartColors.accentSoft,
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              point.title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: SmartColors.accent,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'KPI ${_formatPercent(point.percKpi)}%',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SmartPill(
                      label: 'Quá hạn ${point.totalProcessExpired}',
                      tone: SmartTone.danger,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Văn bản: ${point.totalDocument}',
                  style: AppTextStyles.caption,
                ),
                const SizedBox(height: 8),
                SmartProgressBar(
                  value: point.percKpi / 100,
                  tone: SmartTone.accent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final DashboardNotificationItem item;

  const _NotificationCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isUnread = item.statusId == 1;
    return SmartCard(
      borderColor: isUnread
          ? SmartColors.warning.withValues(alpha: 0.22)
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isUnread ? SmartColors.warningSoft : SmartColors.soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isUnread
                  ? Icons.notifications_active_rounded
                  : Icons.notifications_none_rounded,
              color: isUnread ? SmartColors.warning : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.plainTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SmartPill(
                      label: item.timeAgo.isNotEmpty
                          ? item.timeAgo
                          : (isUnread ? 'Mới' : 'Đã đọc'),
                      tone: isUnread ? SmartTone.warning : SmartTone.neutral,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  item.message.isNotEmpty
                      ? item.message
                      : 'Không có nội dung chi tiết.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
