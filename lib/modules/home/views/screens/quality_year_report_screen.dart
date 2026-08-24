part of '../home_screen.dart';

class _QualityYearReportScreen extends StatelessWidget {
  final HomeController controller;

  const _QualityYearReportScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.qualityYearReport.value;
      final reports = bundle.report.items;
      final average = _qualityYearAverage(reports);
      final excellent = reports
          .where(
            (item) => item.classification.toLowerCase().contains('xuất sắc'),
          )
          .length;

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Đánh giá cán bộ',
            title: 'Báo cáo chất lượng theo năm',
            badge: 'Năm ${controller.selectedQualityYear.value}',
            actionLabel: 'Làm mới',
            onAction: controller.fetchQualityYearReport,
          ),
          if (controller.isQualityYearReportLoading.value)
            const LinearProgressIndicator(),
          if (controller.qualityYearReportError.value != null)
            _InlineError(
              message: controller.qualityYearReportError.value!,
              onRetry: controller.fetchQualityYearReport,
            ),
          _QualityYearFilters(controller: controller, bundle: bundle),
          SmartStatGrid(
            compact: true,
            stats: [
              SmartStatData(
                value: '${bundle.report.total}',
                label: 'Báo cáo năm',
                tone: SmartTone.accent,
              ),
              SmartStatData(
                value: '${_qualityScore(average)}đ',
                label: 'Điểm TB năm',
                tone: SmartTone.warning,
              ),
              SmartStatData(
                value: '$excellent',
                label: 'Xếp loại xuất sắc',
                tone: SmartTone.success,
              ),
            ],
          ),
          SmartSectionHeader(
            title: 'Chi tiết chất lượng cả năm',
            actionLabel: '${reports.length}/${bundle.report.total}',
          ),
          if (reports.isEmpty)
            const _EmptyState(
              title: 'Chưa có báo cáo năm phù hợp',
              note: 'Thay đổi bộ lọc hoặc làm mới để cập nhật dữ liệu.',
            )
          else
            ...reports.map((item) => _QualityYearReportCard(item: item)),
        ],
      );
    });
  }
}

class _QualityYearFilters extends StatefulWidget {
  final HomeController controller;
  final QualityYearReportBundle bundle;

  const _QualityYearFilters({required this.controller, required this.bundle});

  @override
  State<_QualityYearFilters> createState() => _QualityYearFiltersState();
}

class _QualityYearFiltersState extends State<_QualityYearFilters> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final bundle = widget.bundle;
    final currentYear = DateTime.now().year;
    return SmartCard(
      radius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  const Icon(
                    Icons.tune_rounded,
                    size: 19,
                    color: SmartColors.accent,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Bộ lọc báo cáo chất lượng năm',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    _isExpanded ? 'Thu gọn' : 'Mở bộ lọc',
                    style: AppTextStyles.caption.copyWith(
                      color: SmartColors.accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: SmartColors.accent,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const SizedBox(height: 12),
            _QualityDropdown<int>(
              label: 'Năm báo cáo',
              value: controller.selectedQualityYear.value,
              items: List.generate(7, (index) {
                final year = currentYear - 3 + index;
                return DropdownMenuItem(value: year, child: Text('Năm $year'));
              }),
              onChanged: (value) =>
                  controller.setQualityYear(value ?? currentYear),
            ),
            const SizedBox(height: 12),
            _QualityDropdown<int>(
              label: 'Chọn cán bộ',
              value: controller.selectedQualityYearUserId.value,
              items: [
                const DropdownMenuItem(
                  value: 0,
                  child: Text('-- Tất cả cán bộ --'),
                ),
                ...bundle.staff.map(
                  (item) => DropdownMenuItem(
                    value: item.id,
                    child: Text(
                      item.displayName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              onChanged: (value) => controller.setQualityYearUser(value ?? 0),
            ),
            const SizedBox(height: 12),
            _QualityDropdown<int>(
              label: 'Trạng thái',
              value: controller.selectedQualityYearStatusId.value,
              items: const [
                DropdownMenuItem(value: -100, child: Text('Tất cả trạng thái')),
                DropdownMenuItem(value: 0, child: Text('Mới nộp')),
                DropdownMenuItem(value: 1, child: Text('Chờ đánh giá')),
                DropdownMenuItem(value: 2, child: Text('Hoàn tất')),
              ],
              onChanged: (value) =>
                  controller.setQualityYearStatus(value ?? -100),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: controller.fetchQualityYearReport,
                icon: const Icon(Icons.filter_alt_rounded, size: 18),
                label: const Text('Áp dụng bộ lọc'),
                style: FilledButton.styleFrom(
                  backgroundColor: SmartColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QualityYearReportCard extends StatelessWidget {
  final QualityYearReportItem item;

  const _QualityYearReportCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final tone = _qualityStatusTone(item.statusName);
    return SmartCard(
      radius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: _periodToneColors(tone).background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.workspace_premium_outlined,
                  color: _periodToneColors(tone).foreground,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.fullName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      '@${item.userName}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SmartPill(
                label: item.statusName.isEmpty ? 'Chưa rõ' : item.statusName,
                tone: tone,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            item.departmentName,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (item.positionName.isNotEmpty) ...[
            const SizedBox(height: 3),
            Text(
              item.positionName,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              _QualityYearMetric(
                label: 'Tổng kỳ',
                value: '${item.totalPeriods}',
                tone: SmartTone.accent,
              ),
              const SizedBox(width: 8),
              _QualityYearMetric(
                label: 'Điểm TB năm',
                value: '${_qualityScore(item.averageYear)}đ',
                tone: SmartTone.warning,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _QualityYearDistribution(item: item),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 9),
          _QualityDetailRow(label: 'Xếp loại', value: item.classification),
          _QualityDetailRow(
            label: 'Phê duyệt',
            value: _formatDateLabel(item.dateApproved),
          ),
          if (item.approver.isNotEmpty)
            _QualityDetailRow(label: 'Người duyệt', value: item.approver),
        ],
      ),
    );
  }
}

class _QualityYearMetric extends StatelessWidget {
  final String label;
  final String value;
  final SmartTone tone;

  const _QualityYearMetric({
    required this.label,
    required this.value,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _periodToneColors(tone);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: AppTextStyles.h4.copyWith(
                color: colors.foreground,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QualityYearDistribution extends StatelessWidget {
  final QualityYearReportItem item;

  const _QualityYearDistribution({required this.item});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      _QualityYearCount(
        label: 'Xuất sắc',
        value: item.excellentMonths,
        tone: SmartTone.success,
      ),
      _QualityYearCount(
        label: 'Tốt',
        value: item.goodMonths,
        tone: SmartTone.accent,
      ),
      _QualityYearCount(
        label: 'Hoàn thành',
        value: item.completedMonths,
        tone: SmartTone.neutral,
      ),
      _QualityYearCount(
        label: 'Không HT',
        value: item.incompleteMonths,
        tone: SmartTone.warning,
      ),
    ],
  );
}

class _QualityYearCount extends StatelessWidget {
  final String label;
  final int value;
  final SmartTone tone;

  const _QualityYearCount({
    required this.label,
    required this.value,
    required this.tone,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _periodToneColors(tone);
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: AppTextStyles.h4.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              fontSize: 9,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

double _qualityYearAverage(List<QualityYearReportItem> items) => items.isEmpty
    ? 0
    : items.map((item) => item.averageYear).reduce((a, b) => a + b) /
          items.length;
