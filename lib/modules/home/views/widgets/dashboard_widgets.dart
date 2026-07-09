part of '../home_screen.dart';

class _DashboardTrendCard extends StatelessWidget {
  final List<DashboardTrendPoint> points;

  const _DashboardTrendCard({required this.points});

  @override
  Widget build(BuildContext context) {
    final visible = points.length > 6
        ? points.sublist(points.length - 6)
        : points;
    final maxValue = visible
        .map(
          (point) => point.kpiPercent > point.processPercent
              ? point.kpiPercent
              : point.processPercent,
        )
        .fold<double>(0, (max, value) => value > max ? value : max)
        .clamp(100, double.infinity);

    return SmartCard(
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(
                child: _LabelNote(
                  label: 'Hiệu suất theo tuần',
                  note: 'KPI và tiến độ xử lý từ dashboard part 2',
                ),
              ),
              SmartPill(label: 'API', tone: SmartTone.accent),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 126,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: visible
                  .map(
                    (point) => _TrendBar(
                      label: point.label,
                      kpiValue: point.kpiPercent / maxValue,
                      processValue: point.processPercent / maxValue,
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendBar extends StatelessWidget {
  final String label;
  final double kpiValue;
  final double processValue;

  const _TrendBar({
    required this.label,
    required this.kpiValue,
    required this.processValue,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      heightFactor: kpiValue.clamp(0.04, 1),
                      alignment: Alignment.bottomCenter,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: SmartColors.accent,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 3),
                  Expanded(
                    child: FractionallySizedBox(
                      heightFactor: processValue.clamp(0.04, 1),
                      alignment: Alignment.bottomCenter,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: SmartColors.success,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
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

class _DepartmentWorkloadChart extends StatelessWidget {
  final List<DepartmentWorkload> departments;
  final int totalDepartments;
  final bool isExpanded;
  final VoidCallback? onToggle;

  const _DepartmentWorkloadChart({
    required this.departments,
    required this.totalDepartments,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final totalCompleted = departments.fold<int>(
      0,
      (sum, item) => sum + item.totalCompleted,
    );
    final totalProcessing = departments.fold<int>(
      0,
      (sum, item) => sum + item.totalProcessing,
    );
    final totalPending = departments.fold<int>(
      0,
      (sum, item) => sum + item.totalPending,
    );
    final totalOverdue = departments.fold<int>(
      0,
      (sum, item) => sum + item.totalOverdue,
    );
    final totalWork =
        totalCompleted + totalProcessing + totalPending + totalOverdue;
    final maxTotal = departments
        .map((item) => item.total)
        .fold<int>(1, (max, value) => value > max ? value : max);

    final overallPercent = totalWork == 0
        ? 0.0
        : totalCompleted / totalWork * 100;

    return SmartCard(
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: SmartColors.accentSoft,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.apartment_rounded,
                  size: 19,
                  color: SmartColors.accent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thống kê theo đơn vị',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Hoàn thành ${_formatPercent(overallPercent)}% · $totalWork việc',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SmartPill(
                label: '$totalDepartments đơn vị',
                tone: totalOverdue > 0 ? SmartTone.danger : SmartTone.neutral,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _DepartmentStatChip(
                label: 'Hoàn thành',
                value: totalCompleted,
                color: SmartColors.success,
              ),
              const SizedBox(width: 8),
              _DepartmentStatChip(
                label: 'Đang xử lý',
                value: totalProcessing,
                color: SmartColors.accent,
              ),
              const SizedBox(width: 8),
              _DepartmentStatChip(
                label: 'Chờ xử lý',
                value: totalPending,
                color: SmartColors.warning,
              ),
              const SizedBox(width: 8),
              _DepartmentStatChip(
                label: 'Quá hạn',
                value: totalOverdue,
                color: SmartColors.danger,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 14),
          ...List.generate(departments.length, (index) {
            return _DepartmentChartLine(
              department: departments[index],
              maxTotal: maxTotal,
              showDivider: index < departments.length - 1,
            );
          }),
          if (onToggle != null) ...[
            const SizedBox(height: 4),
            _LoadMoreRow(isExpanded: isExpanded, onTap: onToggle!),
          ],
        ],
      ),
    );
  }
}

/// Chip thống kê tổng: chấm màu + số + nhãn, xếp thành hàng đều nhau.
class _DepartmentStatChip extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _DepartmentStatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: SmartColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: SmartColors.border),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  value.toString(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                fontSize: 9.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DepartmentChartLine extends StatelessWidget {
  final DepartmentWorkload department;
  final int maxTotal;
  final bool showDivider;

  const _DepartmentChartLine({
    required this.department,
    required this.maxTotal,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final total = department.total;
    final normalizedTotal = total == 0 ? 1 : total;
    final donePercent = total == 0
        ? 0.0
        : department.totalCompleted / total * 100;
    final percentTone = donePercent >= 80
        ? SmartTone.success
        : donePercent >= 50
        ? SmartTone.warning
        : SmartTone.danger;
    final percentColors = _periodToneColors(percentTone);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                department.departmentName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (department.totalOverdue > 0) ...[
              const Icon(
                Icons.error_rounded,
                size: 14,
                color: SmartColors.danger,
              ),
              const SizedBox(width: 3),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: percentColors.background,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${_formatPercent(donePercent)}%',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                  color: percentColors.foreground,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: SizedBox(
            height: 12,
            child: total == 0
                ? Container(color: SmartColors.soft)
                : Row(
                    children: [
                      _WorkloadSegment(
                        flex: department.totalCompleted,
                        total: normalizedTotal,
                        color: SmartColors.success,
                        height: 12,
                      ),
                      _WorkloadSegment(
                        flex: department.totalProcessing,
                        total: normalizedTotal,
                        color: SmartColors.accent,
                        height: 12,
                      ),
                      _WorkloadSegment(
                        flex: department.totalPending,
                        total: normalizedTotal,
                        color: SmartColors.warning,
                        height: 12,
                      ),
                      _WorkloadSegment(
                        flex: department.totalOverdue,
                        total: normalizedTotal,
                        color: SmartColors.danger,
                        height: 12,
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            _DepartmentLegendValue(
              color: SmartColors.success,
              label: 'Hoàn thành',
              value: department.totalCompleted,
            ),
            _DepartmentLegendValue(
              color: SmartColors.accent,
              label: 'Đang xử lý',
              value: department.totalProcessing,
            ),
            _DepartmentLegendValue(
              color: SmartColors.warning,
              label: 'Chờ',
              value: department.totalPending,
            ),
            _DepartmentLegendValue(
              color: SmartColors.danger,
              label: 'Quá hạn',
              value: department.totalOverdue,
            ),
          ],
        ),
        if (showDivider) ...[
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
        ] else
          const SizedBox(height: 4),
      ],
    );
  }
}

/// Chú thích màu + nhãn + số cho từng dòng đơn vị.
class _DepartmentLegendValue extends StatelessWidget {
  final Color color;
  final String label;
  final int value;

  const _DepartmentLegendValue({
    required this.color,
    required this.label,
    required this.value,
  });

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
        Text(
          '$label ',
          style: AppTextStyles.caption.copyWith(
            fontSize: 10.5,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value.toString(),
          style: AppTextStyles.caption.copyWith(
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class DepartmentRow extends StatelessWidget {
  final DepartmentWorkload department;

  const DepartmentRow({super.key, required this.department});

  @override
  Widget build(BuildContext context) {
    final total = department.total == 0 ? 1 : department.total;
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  department.departmentName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SmartPill(
                label: department.total.toString(),
                tone: department.totalOverdue > 0
                    ? SmartTone.danger
                    : SmartTone.neutral,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: Row(
              children: [
                _WorkloadSegment(
                  flex: department.totalCompleted,
                  total: total,
                  color: SmartColors.success,
                ),
                _WorkloadSegment(
                  flex: department.totalProcessing,
                  total: total,
                  color: SmartColors.accent,
                ),
                _WorkloadSegment(
                  flex: department.totalPending,
                  total: total,
                  color: SmartColors.warning,
                ),
                _WorkloadSegment(
                  flex: department.totalOverdue,
                  total: total,
                  color: SmartColors.danger,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hoàn thành ${department.totalCompleted} · Đang xử lý ${department.totalProcessing} · Chờ ${department.totalPending} · Quá hạn ${department.totalOverdue}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

class _WorkloadSegment extends StatelessWidget {
  final int flex;
  final int total;
  final Color color;
  final double height;

  const _WorkloadSegment({
    required this.flex,
    required this.total,
    required this.color,
    this.height = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    final widthFactor = flex == 0 ? 0.04 : flex / total;
    return Expanded(
      flex: (widthFactor * 100).round().clamp(4, 100),
      child: Container(height: height, color: color),
    );
  }
}

class _ActiveUserRow extends StatelessWidget {
  final DashboardUser user;

  const _ActiveUserRow({required this.user});

  @override
  Widget build(BuildContext context) {
    return _CompactRow(
      title: user.fullName.isNotEmpty ? user.fullName : user.userName,
      note: '${user.departmentName} · ${user.phone}',
      leading: SmartIconBadge(label: user.initials, size: 32),
      trailing: SmartPill(
        label: user.statusName.isNotEmpty ? user.statusName : 'Hoạt động',
        tone: SmartTone.success,
      ),
    );
  }
}
