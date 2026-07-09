part of '../home_screen.dart';

class _PeriodicReportScreen extends StatelessWidget {
  final HomeController controller;

  const _PeriodicReportScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.periodicReport.value;
      final summary = bundle.summary;
      final notifications = bundle.notifications.items;

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            eyebrow: 'Báo cáo',
            title: 'Báo cáo định kỳ',
            badge: 'Kỳ 2',
            actionLabel: 'Làm mới',
            onAction: controller.fetchPeriodicReport,
          ),
          if (controller.isPeriodicReportLoading.value)
            const LinearProgressIndicator(),
          if (controller.periodicReportError.value != null)
            _InlineError(
              message: controller.periodicReportError.value!,
              onRetry: controller.fetchPeriodicReport,
            ),
          SmartStatGrid(
            compact: true,
            stats: [
              SmartStatData(
                value: summary.totalCurProcess.toString(),
                label: 'Công việc kỳ này',
                tone: SmartTone.accent,
              ),
              SmartStatData(
                value: summary.totalCurDocument.toString(),
                label: 'Văn bản kỳ này',
                tone: SmartTone.success,
              ),
            ],
          ),
          SmartStatGrid(
            compact: true,
            stats: [
              SmartStatData(
                value: summary.totalCurBooking.toString(),
                label: 'Lịch họp kỳ này',
                tone: SmartTone.warning,
              ),
              SmartStatData(
                value: _formatPercent(summary.totalPercKpi),
                label: 'KPI hiện tại',
                tone: SmartTone.danger,
              ),
            ],
          ),
          SmartCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SmartSectionHeader(title: 'So sánh với kỳ trước'),
                const SizedBox(height: 10),
                _PeriodCompareRow(
                  title: 'Công việc',
                  current: summary.totalCurProcess.toString(),
                  previous: summary.totalPrevProcess.toString(),
                  percent: summary.percentProcess,
                  tone: SmartTone.accent,
                ),
                const SizedBox(height: 10),
                _PeriodCompareRow(
                  title: 'Văn bản',
                  current: summary.totalCurDocument.toString(),
                  previous: summary.totalPrevDocument.toString(),
                  percent: summary.percentDocument,
                  tone: SmartTone.success,
                ),
                const SizedBox(height: 10),
                _PeriodCompareRow(
                  title: 'Lịch họp',
                  current: summary.totalCurBooking.toString(),
                  previous: summary.totalPrevBooking.toString(),
                  percent: summary.percentBooking,
                  tone: SmartTone.warning,
                ),
                const SizedBox(height: 10),
                _PeriodCompareRow(
                  title: 'KPI',
                  current: _formatPercent(summary.totalPercKpi),
                  previous: _formatPercent(summary.prevPercKpi),
                  percent: summary.totalPercKpi - summary.prevPercKpi,
                  tone: SmartTone.danger,
                  currentSuffix: '%',
                  previousSuffix: '%',
                ),
              ],
            ),
          ),
          SmartSectionHeader(
            title: 'Diễn biến trong kỳ',
            actionLabel: '${summary.items.length}',
          ),
          if (summary.items.isEmpty)
            const _EmptyState(
              title: 'Chưa có dữ liệu kỳ này',
              note: 'Dữ liệu báo cáo sẽ hiển thị khi API trả về danh sách.',
            )
          else
            ...summary.items
                .take(
                  controller.visibleCount('period_items', summary.items.length),
                )
                .map((item) => _PeriodItemCard(item: item)),
          if (summary.items.length > 5)
            _LoadMoreRow(
              isExpanded: controller.isExpanded(
                'period_items',
                summary.items.length,
              ),
              onTap: () => controller.toggleLoadMore(
                'period_items',
                summary.items.length,
              ),
            ),
          SmartSectionHeader(
            title: 'Xu hướng KPI',
            actionLabel: '${bundle.trends.length}',
          ),
          if (bundle.trends.isEmpty)
            const _EmptyState(
              title: 'Chưa có xu hướng',
              note: 'Biểu đồ xu hướng sẽ xuất hiện khi có dữ liệu trả về.',
            )
          else
            ...bundle.trends
                .take(
                  controller.visibleCount(
                    'period_trends',
                    bundle.trends.length,
                  ),
                )
                .map((point) => _PeriodTrendRow(point: point)),
          if (bundle.trends.length > 4)
            _LoadMoreRow(
              isExpanded: controller.isExpanded(
                'period_trends',
                bundle.trends.length,
              ),
              onTap: () => controller.toggleLoadMore(
                'period_trends',
                bundle.trends.length,
              ),
            ),
          SmartSectionHeader(
            title: 'Thông báo gần đây',
            actionLabel: '${bundle.notifications.totals}',
          ),
          if (notifications.isEmpty)
            const _EmptyState(
              title: 'Chưa có thông báo',
              note: 'Hệ thống sẽ hiển thị thông báo khi có phát sinh mới.',
            )
          else
            ...notifications
                .take(
                  controller.visibleCount(
                    'period_notifications',
                    notifications.length,
                  ),
                )
                .map((item) => _NotificationCard(item: item)),
          if (notifications.length > 5)
            _LoadMoreRow(
              isExpanded: controller.isExpanded(
                'period_notifications',
                notifications.length,
              ),
              onTap: () => controller.toggleLoadMore(
                'period_notifications',
                notifications.length,
              ),
            ),
        ],
      );
    });
  }
}
