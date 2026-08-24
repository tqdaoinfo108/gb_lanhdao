part of '../home_screen.dart';

class _PeriodicReportScreen extends StatelessWidget {
  final HomeController controller;

  const _PeriodicReportScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.periodicReport.value;
      final summary = bundle.summary;
      final selectedPeriod = controller.selectedReportPeriod.value;

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            eyebrow: 'Báo cáo',
            title: 'Báo cáo tổng hợp',
            badge: selectedPeriod.label,
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
          _ReportPeriodSelector(
            selected: selectedPeriod,
            onSelected: controller.selectReportPeriod,
          ),
          SmartStatGrid(
            compact: true,
            stats: [
              SmartStatData(
                value: summary.totalCurProcess.toString(),
                label: 'Công việc ${selectedPeriod.label.toLowerCase()}',
                tone: SmartTone.accent,
              ),
              SmartStatData(
                value: summary.totalCurDocument.toString(),
                label: 'Văn bản ${selectedPeriod.label.toLowerCase()}',
                tone: SmartTone.success,
              ),
            ],
          ),
          SmartStatGrid(
            compact: true,
            stats: [
              SmartStatData(
                value: summary.totalCurBooking.toString(),
                label: 'Lịch họp ${selectedPeriod.label.toLowerCase()}',
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
        ],
      );
    });
  }
}

class _ReportPeriodSelector extends StatelessWidget {
  final ReportPeriod selected;
  final ValueChanged<ReportPeriod> onSelected;

  const _ReportPeriodSelector({
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      padding: const EdgeInsets.all(6),
      child: Row(
        children: ReportPeriod.values
            .map(
              (period) => Expanded(
                child: _ReportPeriodOption(
                  label: period.label,
                  selected: period == selected,
                  onTap: () => onSelected(period),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ReportPeriodOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ReportPeriodOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? SmartColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: selected ? Colors.white : AppColors.textSecondary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
