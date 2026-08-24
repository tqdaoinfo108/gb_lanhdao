part of '../home_screen.dart';

class _QualityReportScreen extends StatelessWidget {
  final HomeController controller;

  const _QualityReportScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.qualityReport.value;
      final reports = bundle.report.items;
      final selfAverage = _qualityAverage(reports, (item) => item.selfScore);
      final leaderAverage = _qualityAverage(
        reports,
        (item) => item.leaderScore,
      );

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Đánh giá cán bộ',
            title: 'Báo cáo chất lượng theo kỳ',
            badge: '${bundle.report.total} lượt',
            actionLabel: 'Làm mới',
            onAction: controller.fetchQualityReport,
          ),
          if (controller.isQualityReportLoading.value)
            const LinearProgressIndicator(),
          if (controller.qualityReportError.value != null)
            _InlineError(
              message: controller.qualityReportError.value!,
              onRetry: controller.fetchQualityReport,
            ),
          _QualityReportFilters(controller: controller, bundle: bundle),
          SmartStatGrid(
            compact: true,
            stats: [
              SmartStatData(
                value: '${bundle.report.total}',
                label: 'Lượt báo cáo',
                tone: SmartTone.accent,
              ),
              SmartStatData(
                value: '${_qualityScore(selfAverage)}đ',
                label: 'Tự đánh giá TB',
                tone: SmartTone.warning,
              ),
              SmartStatData(
                value: '${_qualityScore(leaderAverage)}đ',
                label: 'Lãnh đạo duyệt TB',
                tone: SmartTone.success,
              ),
            ],
          ),
          SmartSectionHeader(
            title: 'Danh sách báo cáo',
            actionLabel: '${reports.length}/${bundle.report.total}',
          ),
          if (reports.isEmpty)
            const _EmptyState(
              title: 'Chưa có báo cáo phù hợp',
              note: 'Thay đổi bộ lọc hoặc làm mới để cập nhật dữ liệu.',
            )
          else
            ...reports.map((item) => _QualityReportCard(item: item)),
        ],
      );
    });
  }
}

class _QualityReportFilters extends StatefulWidget {
  final HomeController controller;
  final QualityReportBundle bundle;

  const _QualityReportFilters({required this.controller, required this.bundle});

  @override
  State<_QualityReportFilters> createState() => _QualityReportFiltersState();
}

class _QualityReportFiltersState extends State<_QualityReportFilters> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final bundle = widget.bundle;
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
                      'Bộ lọc báo cáo',
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
            Row(
              children: [
                Expanded(
                  child: _QualityMonthField(
                    label: 'Từ tháng / năm',
                    value: controller.qualityStartMonth.value,
                    onPick: controller.setQualityStartMonth,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _QualityMonthField(
                    label: 'Đến tháng / năm',
                    value: controller.qualityEndMonth.value,
                    onPick: controller.setQualityEndMonth,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _QualityDropdown<int?>(
              label: 'Mẫu đợt đánh giá',
              value: controller.selectedQualityTemplateId.value,
              hint: 'Tất cả mẫu đợt đánh giá',
              items: bundle.templates
                  .map(
                    (item) => DropdownMenuItem<int?>(
                      value: item.id,
                      child: Text(item.name, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
              onChanged: controller.setQualityTemplate,
            ),
            const SizedBox(height: 12),
            _QualityDropdown<int>(
              label: 'Chọn cán bộ',
              value: controller.selectedQualityUserId.value,
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
              onChanged: (value) => controller.setQualityUser(value ?? 0),
            ),
            const SizedBox(height: 12),
            _QualityDropdown<int>(
              label: 'Trạng thái',
              value: controller.selectedQualityStatusId.value,
              items: const [
                DropdownMenuItem(value: -100, child: Text('Tất cả trạng thái')),
                DropdownMenuItem(value: 0, child: Text('Mới nộp')),
                DropdownMenuItem(value: 1, child: Text('Chờ đánh giá')),
                DropdownMenuItem(value: 2, child: Text('Hoàn tất')),
              ],
              onChanged: (value) => controller.setQualityStatus(value ?? -100),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: controller.fetchQualityReport,
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

class _QualityMonthField extends StatelessWidget {
  final String label;
  final DateTime value;
  final ValueChanged<DateTime> onPick;

  const _QualityMonthField({
    required this.label,
    required this.value,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _qualityFieldLabel),
        const SizedBox(height: 5),
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: value,
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
              helpText: label,
            );
            if (picked != null) {
              onPick(picked);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: SmartColors.soft,
              border: Border.all(color: SmartColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  size: 16,
                  color: SmartColors.accent,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Tháng ${value.month}/${value.year}',
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QualityDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final String? hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _QualityDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _qualityFieldLabel),
        const SizedBox(height: 5),
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          hint: hint == null
              ? null
              : Text(hint!, overflow: TextOverflow.ellipsis),
          items: items,
          onChanged: onChanged,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: SmartColors.soft,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: SmartColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: SmartColors.border),
            ),
          ),
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _QualityReportCard extends StatelessWidget {
  final QualityReportItem item;

  const _QualityReportCard({required this.item});

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
                  Icons.person_outline_rounded,
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
          const SizedBox(height: 12),
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
              _QualityScore(
                label: 'Tự chấm',
                value: item.selfScore,
                tone: SmartTone.warning,
              ),
              const SizedBox(width: 8),
              _QualityScore(
                label: 'Lãnh đạo duyệt',
                value: item.leaderScore,
                tone: SmartTone.success,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 10),
          _QualityDetailRow(label: 'Xếp loại', value: item.classification),
          _QualityDetailRow(
            label: 'Tự chấm',
            value: _formatDateLabel(item.dateScoring),
          ),
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

class _QualityScore extends StatelessWidget {
  final String label;
  final double value;
  final SmartTone tone;

  const _QualityScore({
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
              '${_qualityScore(value)}đ',
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

class _QualityDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _QualityDetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 5),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 82,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? '—' : value,
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}

final TextStyle _qualityFieldLabel = AppTextStyles.caption.copyWith(
  color: AppColors.textSecondary,
  fontWeight: FontWeight.w800,
);

double _qualityAverage(
  List<QualityReportItem> items,
  double Function(QualityReportItem) value,
) =>
    items.isEmpty ? 0 : items.map(value).reduce((a, b) => a + b) / items.length;

String _qualityScore(double value) =>
    value % 1 == 0 ? value.toStringAsFixed(0) : value.toStringAsFixed(1);

SmartTone _qualityStatusTone(String status) {
  final normalized = status.toLowerCase();
  if (normalized.contains('duyệt') || normalized.contains('hoàn')) {
    return SmartTone.success;
  }
  if (normalized.contains('chờ')) {
    return SmartTone.warning;
  }
  return SmartTone.neutral;
}
