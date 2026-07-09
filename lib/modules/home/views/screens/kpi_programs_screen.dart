part of '../home_screen.dart';

class _KpiProgramsScreen extends StatelessWidget {
  final HomeController controller;

  const _KpiProgramsScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.kpiBundle.value;
      final items = _filteredKpiItems(
        bundle.viewItems,
        controller.kpiQuery.value,
        controller.kpiStatusFilter.value,
      );

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Nghiệp vụ',
            title: 'Chương trình & KPI',
            actionLabel: 'Làm mới',
            onAction: controller.fetchKpiPrograms,
          ),
          if (controller.isKpiLoading.value) const LinearProgressIndicator(),
          if (controller.kpiError.value != null)
            _InlineError(
              message: controller.kpiError.value!,
              onRetry: controller.fetchKpiPrograms,
            ),
          SmartStatGrid(
            stats: [
              SmartStatData(
                value: bundle.totalPrograms.toString(),
                label: 'Tổng chương trình',
              ),
              SmartStatData(
                value: bundle.totalOnTrack.toString(),
                label: 'Đúng tiến độ',
                tone: SmartTone.success,
              ),
              SmartStatData(
                value: bundle.totalCompleted.toString(),
                label: 'Hoàn thành',
                tone: SmartTone.accent,
              ),
              SmartStatData(
                value: bundle.totalDelayed.toString(),
                label: 'Chậm tiến độ',
                tone: SmartTone.danger,
              ),
            ],
          ),
          _KpiChartCard(points: bundle.chart),
          SmartCard(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                TextField(
                  controller: controller.kpiSearchController,
                  onChanged: controller.searchKpis,
                  decoration: const InputDecoration(
                    hintText: 'Tìm kiếm chương trình...',
                    prefixIcon: Icon(Icons.search_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 9),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _KpiFilterChip(
                        label: 'Tất cả',
                        selected: controller.kpiStatusFilter.value == -100,
                        onTap: () => controller.setKpiStatusFilter(-100),
                      ),
                      _KpiFilterChip(
                        label: 'Đúng tiến độ',
                        selected: controller.kpiStatusFilter.value == 1,
                        onTap: () => controller.setKpiStatusFilter(1),
                      ),
                      _KpiFilterChip(
                        label: 'Có rủi ro',
                        selected: controller.kpiStatusFilter.value == 2,
                        onTap: () => controller.setKpiStatusFilter(2),
                      ),
                      _KpiFilterChip(
                        label: 'Hoàn thành',
                        selected: controller.kpiStatusFilter.value == 3,
                        onTap: () => controller.setKpiStatusFilter(3),
                      ),
                      _KpiFilterChip(
                        label: 'Chậm tiến độ',
                        selected: controller.kpiStatusFilter.value == 4,
                        onTap: () => controller.setKpiStatusFilter(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SmartCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Danh sách chương trình',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      SmartPill(
                        label: '${items.length} chương trình',
                        tone: SmartTone.neutral,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: _EmptyState(
                      title: 'Chưa có chương trình',
                      note: 'Dữ liệu sẽ hiển thị khi API trả về danh sách KPI.',
                    ),
                  )
                else
                  ...List.generate(items.length, (index) {
                    return _KpiProgramRow(
                      item: items[index],
                      showDivider: index < items.length - 1,
                    );
                  }),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _KpiChartCard extends StatelessWidget {
  final List<KpiMonthlyPoint> points;

  const _KpiChartCard({required this.points});

  @override
  Widget build(BuildContext context) {
    final maxValue = points
        .map((point) => point.maxValue)
        .fold<int>(1, (max, value) => value > max ? value : max);

    return SmartCard(
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _LabelNote(
            label: 'Tiến độ theo tháng',
            note: 'Phân bổ trạng thái chương trình 6 tháng gần nhất',
          ),
          const SizedBox(height: 14),
          if (points.isEmpty)
            const _EmptyState(
              title: 'Chưa có dữ liệu biểu đồ',
              note: 'API biểu đồ chưa trả về dữ liệu.',
            )
          else
            SizedBox(
              height: 164,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: points
                    .map((point) => _KpiMonthBars(point: point, max: maxValue))
                    .toList(),
              ),
            ),
          const SizedBox(height: 10),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _KpiLegend(color: SmartColors.accent, label: 'Hoàn thành'),
              _KpiLegend(color: SmartColors.success, label: 'Đúng tiến độ'),
              _KpiLegend(color: SmartColors.warning, label: 'Có rủi ro'),
              _KpiLegend(color: SmartColors.danger, label: 'Chậm tiến độ'),
            ],
          ),
        ],
      ),
    );
  }
}

class _KpiMonthBars extends StatelessWidget {
  final KpiMonthlyPoint point;
  final int max;

  const _KpiMonthBars({required this.point, required this.max});

  @override
  Widget build(BuildContext context) {
    final values = [
      (point.completed, SmartColors.accent),
      (point.onTrack, SmartColors.success),
      (point.atRisk, SmartColors.warning),
      (point.delayed, SmartColors.danger),
    ];

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: Column(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: values.map((entry) {
                  final height = entry.$1 == 0 ? 0.04 : entry.$1 / max;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 1.5),
                    child: FractionallySizedBox(
                      heightFactor: height.clamp(0.04, 1),
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 8,
                        decoration: BoxDecoration(
                          color: entry.$2,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              point.month,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _KpiLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10.5)),
      ],
    );
  }
}

class _KpiProgramRow extends StatelessWidget {
  final KpiProgramViewItem item;
  final bool showDivider;

  const _KpiProgramRow({required this.item, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    final program = item.program;
    final tone = _kpiStatusTone(program.statusId);
    final ownerName = item.owner?.fullName.trim().isNotEmpty == true
        ? item.owner!.fullName
        : program.ownerName;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SmartIconBadge(label: _initials(ownerName), size: 34),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.kpiName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      program.scopeLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SmartPill(label: ownerName, tone: SmartTone.neutral),
                        SmartPill(
                          label: program.executionLabel,
                          tone: SmartTone.neutral,
                        ),
                        SmartPill(
                          label: _formatDateLabel(program.dateExpired),
                          tone: SmartTone.neutral,
                        ),
                        SmartPill(label: item.processSummary),
                        if (item.processLate > 0)
                          SmartPill(
                            label: '${item.processLate} trễ',
                            tone: SmartTone.danger,
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: SmartProgressBar(
                            value: program.progressPercent / 100,
                            tone: tone,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${_formatPercent(program.progressPercent)}%',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              SmartPill(label: program.statusName, tone: tone),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}

class _KpiFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _KpiFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 7),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        showCheckmark: false,
        onSelected: (_) => onTap(),
        visualDensity: VisualDensity.compact,
        labelStyle: AppTextStyles.caption.copyWith(
          color: selected ? SmartColors.accent : AppColors.textSecondary,
          fontWeight: FontWeight.w800,
        ),
        backgroundColor: SmartColors.soft,
        selectedColor: SmartColors.accentSoft,
        shape: const StadiumBorder(side: BorderSide(color: Colors.transparent)),
      ),
    );
  }
}
