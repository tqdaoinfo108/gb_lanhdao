part of '../home_screen.dart';

class _OverviewScreen extends StatelessWidget {
  final HomeController controller;

  const _OverviewScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.dashboard.value;
      final summary = bundle.summary;
      final kpiPercent = summary.percentCompleteKpi.clamp(0, 100).toDouble();
      final overdueKpi = bundle.kpis.where((item) => item.statusId == 4).length;

      // Gom các vấn đề cần chú ý theo mức độ.
      final attentions = <_AttentionData>[
        if (summary.totalProcessPriority > 0)
          _AttentionData(
            label: 'Việc ưu tiên',
            value: summary.totalProcessPriority,
            hint: 'Cần xử lý ngay hôm nay',
            icon: Icons.priority_high_rounded,
            tone: SmartTone.danger,
            onTap: () => controller.showView(AdminSmartView.tasks),
          ),
        if (overdueKpi > 0)
          _AttentionData(
            label: 'KPI trễ hạn',
            value: overdueKpi,
            hint: 'Chỉ tiêu chậm tiến độ',
            icon: Icons.trending_down_rounded,
            tone: SmartTone.danger,
            onTap: () => controller.showView(AdminSmartView.kpiPrograms),
          ),
        if (summary.totalProcessUndone > 0)
          _AttentionData(
            label: 'Chưa xử lý',
            value: summary.totalProcessUndone,
            hint:
                '${_formatSigned(summary.totalProcessUndoneLastWeek)} so với tuần trước',
            icon: Icons.pending_actions_rounded,
            tone: SmartTone.warning,
            onTap: () => controller.showView(AdminSmartView.tasks),
          ),
        if (summary.totalBookingToday > 0)
          _AttentionData(
            label: 'Họp hôm nay',
            value: summary.totalBookingToday,
            hint: 'Chuẩn bị tài liệu trước giờ',
            icon: Icons.event_available_rounded,
            tone: SmartTone.accent,
            onTap: () => controller.showView(AdminSmartView.meetingSchedule),
          ),
      ];
      final hasUrgentWork = summary.totalProcessPriority > 0 || overdueKpi > 0;

      return _ScreenStack(
        children: [
          if (controller.isDashboardLoading.value)
            const LinearProgressIndicator(),
          if (controller.dashboardError.value != null)
            _InlineError(
              message: controller.dashboardError.value!,
              onRetry: controller.fetchDashboard,
            ),
          _OverviewHeroCard(
            kpiPercent: kpiPercent,
            kpiPercentLast: summary.percentCompleteKpiLast,
            totalKpi: summary.totalKpi,
            totalKpiDone: summary.totalKpiDone,
            undone: summary.totalProcessUndone,
            priority: summary.totalProcessPriority,
            overdueKpi: overdueKpi,
            nextBooking: summary.nextBooking,
            hasUrgentWork: hasUrgentWork,
            onRefresh: controller.fetchDashboard,
          ),
          if (attentions.isNotEmpty) _AttentionPanel(items: attentions),
          _OverviewMetricGrid(summary: summary),
          _OverviewActionsRow(controller: controller),
          if (bundle.departments.isNotEmpty)
            _DepartmentWorkloadChart(
              departments: bundle.departments
                  .take(
                    controller.visibleCount(
                      'overview_departments',
                      bundle.departments.length,
                    ),
                  )
                  .toList(),
              totalDepartments: bundle.departments.length,
              isExpanded: controller.isExpanded(
                'overview_departments',
                bundle.departments.length,
              ),
              onToggle: bundle.departments.length > 3
                  ? () => controller.toggleLoadMore(
                      'overview_departments',
                      bundle.departments.length,
                    )
                  : null,
            ),
          if (bundle.trends.isNotEmpty)
            _DashboardTrendCard(points: bundle.trends),
          _PriorityKpiPanel(controller: controller, kpis: bundle.kpis),
          if (bundle.activeUsers.users.isNotEmpty)
            _ActiveUsersPanel(controller: controller, bundle: bundle),
        ],
      );
    });
  }
}

/// Thẻ chủ đạo (hero) của trang tổng quan — gradient, nêu bật tình hình và KPI.
class _OverviewHeroCard extends StatelessWidget {
  final double kpiPercent;
  final double kpiPercentLast;
  final int totalKpi;
  final int totalKpiDone;
  final int undone;
  final int priority;
  final int overdueKpi;
  final String nextBooking;
  final bool hasUrgentWork;
  final VoidCallback onRefresh;

  const _OverviewHeroCard({
    required this.kpiPercent,
    required this.kpiPercentLast,
    required this.totalKpi,
    required this.totalKpiDone,
    required this.undone,
    required this.priority,
    required this.overdueKpi,
    required this.nextBooking,
    required this.hasUrgentWork,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = hasUrgentWork
        ? const [Color(0xFF7A2C22), Color(0xFFC0392B)]
        : const [Color(0xFF1D3A8A), Color(0xFF2F65ED)];
    final kpiDelta = kpiPercent - kpiPercentLast;

    final headline = hasUrgentWork
        ? 'Có việc cần xử lý ngay'
        : 'Tình hình đang ổn định';
    final subline = hasUrgentWork
        ? '$priority việc ưu tiên · $overdueKpi KPI trễ hạn · $undone việc chưa xử lý'
        : 'Không có cảnh báo ưu tiên. Tiếp tục theo dõi KPI và lịch công tác.';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: gradient.last.withValues(alpha: 0.32),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hasUrgentWork
                          ? Icons.warning_amber_rounded
                          : Icons.verified_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      hasUrgentWork ? 'Cần chú ý' : 'Ổn định',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: onRefresh,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.refresh_rounded,
                    size: 17,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headline,
                      style: AppTextStyles.h3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subline,
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              _HeroKpiRing(percent: kpiPercent, delta: kpiDelta),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  icon: Icons.flag_rounded,
                  label: 'KPI hoàn thành',
                  value: '$totalKpiDone/$totalKpi',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _HeroMetric(
                  icon: Icons.event_note_rounded,
                  label: 'Họp kế tiếp',
                  value: nextBooking,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroKpiRing extends StatelessWidget {
  final double percent;
  final double delta;

  const _HeroKpiRing({required this.percent, required this.delta});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 86,
      height: 86,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 86,
            height: 86,
            child: CircularProgressIndicator(
              value: percent / 100,
              strokeWidth: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_formatPercent(percent)}%',
                style: AppTextStyles.h4.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (delta != 0)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      delta > 0
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 11,
                      color: Colors.white,
                    ),
                    Text(
                      '${_formatPercent(delta.abs())}%',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  'KPI',
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 9.5,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HeroMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 62),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: Colors.white.withValues(alpha: 0.85)),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 10.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dữ liệu một mục "cần chú ý".
class _AttentionData {
  final String label;
  final int value;
  final String hint;
  final IconData icon;
  final SmartTone tone;
  final VoidCallback onTap;

  const _AttentionData({
    required this.label,
    required this.value,
    required this.hint,
    required this.icon,
    required this.tone,
    required this.onTap,
  });
}

/// Khu vực nêu bật những việc cần chú ý ngay.
class _AttentionPanel extends StatelessWidget {
  final List<_AttentionData> items;

  const _AttentionPanel({required this.items});

  @override
  Widget build(BuildContext context) {
    final hasDanger = items.any((item) => item.tone == SmartTone.danger);
    return SmartCard(
      radius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                hasDanger
                    ? Icons.notifications_active_rounded
                    : Icons.checklist_rounded,
                size: 18,
                color: hasDanger ? SmartColors.danger : SmartColors.accent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Cần chú ý',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              SmartPill(
                label: '${items.length} mục',
                tone: hasDanger ? SmartTone.danger : SmartTone.neutral,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: items
                .map(
                  (item) => SizedBox(
                    width:
                        (MediaQuery.sizeOf(context).width - 28 - 24 - 10) / 2,
                    child: _AttentionCard(item: item),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _AttentionCard extends StatelessWidget {
  final _AttentionData item;

  const _AttentionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colors = _periodToneColors(item.tone);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colors.foreground.withValues(alpha: 0.22)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: colors.foreground.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, size: 17, color: colors.foreground),
                ),
                const Spacer(),
                Text(
                  item.value.toString(),
                  style: AppTextStyles.h2.copyWith(
                    color: colors.foreground,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.hint,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontSize: 10.5,
                color: AppColors.textSecondary,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lưới chỉ số tổng hợp có so sánh với kỳ trước.
class _OverviewMetricGrid extends StatelessWidget {
  final DashboardSummary summary;

  const _OverviewMetricGrid({required this.summary});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      radius: 22,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _MetricTrendTile(
                  label: 'Việc chưa xử lý',
                  value: summary.totalProcessUndone.toString(),
                  delta: summary.totalProcessUndoneLastWeek,
                  deltaLabel: 'so với tuần trước',
                  lowerIsBetter: true,
                  icon: Icons.pending_actions_rounded,
                  tone: SmartTone.warning,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricTrendTile(
                  label: 'Lịch họp',
                  value: summary.totalBooking.toString(),
                  delta: summary.totalBookingLast,
                  deltaLabel: 'so với kỳ trước',
                  lowerIsBetter: false,
                  icon: Icons.event_note_rounded,
                  tone: SmartTone.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _MetricTrendTile(
                  label: 'Hộ dân cư',
                  value: summary.totalHouseHold.toString(),
                  delta: summary.totalHouseHold - summary.totalHouseHoldLast,
                  deltaLabel: 'biến động',
                  lowerIsBetter: false,
                  icon: Icons.groups_rounded,
                  tone: SmartTone.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _MetricTrendTile(
                  label: 'Tạm trú / vắng',
                  value:
                      '${summary.totalHouseHoldIn}/${summary.totalHouseHoldOut}',
                  delta: 0,
                  deltaLabel: 'đến · đi',
                  lowerIsBetter: false,
                  icon: Icons.swap_horiz_rounded,
                  tone: SmartTone.neutral,
                  hideDelta: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTrendTile extends StatelessWidget {
  final String label;
  final String value;
  final int delta;
  final String deltaLabel;
  final bool lowerIsBetter;
  final IconData icon;
  final SmartTone tone;
  final bool hideDelta;

  const _MetricTrendTile({
    required this.label,
    required this.value,
    required this.delta,
    required this.deltaLabel,
    required this.lowerIsBetter,
    required this.icon,
    required this.tone,
    this.hideDelta = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _periodToneColors(tone);
    final isGood = delta == 0 ? true : (lowerIsBetter ? delta < 0 : delta > 0);
    final deltaColor = delta == 0
        ? AppColors.textSecondary
        : (isGood ? SmartColors.success : SmartColors.danger);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SmartColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SmartColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 15, color: colors.foreground),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.h3.copyWith(
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              if (!hideDelta && delta != 0) ...[
                Icon(
                  delta > 0
                      ? Icons.arrow_upward_rounded
                      : Icons.arrow_downward_rounded,
                  size: 12,
                  color: deltaColor,
                ),
                Text(
                  delta.abs().toString(),
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: deltaColor,
                  ),
                ),
                const SizedBox(width: 4),
              ],
              Expanded(
                child: Text(
                  deltaLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 9.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewActionsRow extends StatelessWidget {
  final HomeController controller;

  const _OverviewActionsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _QuickAction(
          label: 'KPI',
          icon: Icons.query_stats_rounded,
          onTap: () => controller.showView(AdminSmartView.kpiPrograms),
        ),
        _QuickAction(
          label: 'Giao việc',
          icon: Icons.task_alt_rounded,
          onTap: () => controller.showView(AdminSmartView.tasks),
        ),
        _QuickAction(
          label: 'Địa điểm',
          icon: Icons.place_outlined,
          onTap: () => controller.showView(AdminSmartView.digitalMap),
        ),
        _QuickAction(
          label: 'Ứng dụng',
          icon: Icons.apps_rounded,
          onTap: () => controller.showView(AdminSmartView.apps),
        ),
      ],
    );
  }
}

class _PriorityKpiPanel extends StatelessWidget {
  final HomeController controller;
  final List<DashboardKpiItem> kpis;

  const _PriorityKpiPanel({required this.controller, required this.kpis});

  @override
  Widget build(BuildContext context) {
    final visible = kpis.take(3).toList();
    return SmartCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'KPI cần theo dõi',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SmartTextButton(
                  label: 'Xem tất cả',
                  onTap: () => controller.showView(AdminSmartView.kpiPrograms),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (visible.isEmpty)
            const Padding(
              padding: EdgeInsets.all(12),
              child: _EmptyState(
                title: 'Chưa có KPI ưu tiên',
                note: 'Dữ liệu sẽ hiển thị khi API trả về danh sách KPI.',
              ),
            )
          else
            ...List.generate(visible.length, (index) {
              final kpi = visible[index];
              return _KpiCompactRow(
                kpi: kpi,
                showDivider: index < visible.length - 1,
              );
            }),
        ],
      ),
    );
  }
}

class _KpiCompactRow extends StatelessWidget {
  final DashboardKpiItem kpi;
  final bool showDivider;

  const _KpiCompactRow({required this.kpi, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    final tone = _kpiStatusTone(kpi.statusId);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SmartIconBadge(label: _initials(kpi.userProcessName), size: 34),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kpi.kpiName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${kpi.departmentName} · ${_formatDateLabel(kpi.dateExpired)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 8),
                    SmartProgressBar(value: kpi.progress / 100, tone: tone),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatPercent(kpi.progress)}%',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  SmartPill(label: kpi.statusName, tone: tone),
                ],
              ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}

class _ActiveUsersPanel extends StatelessWidget {
  final HomeController controller;
  final DashboardBundle bundle;

  const _ActiveUsersPanel({required this.controller, required this.bundle});

  @override
  Widget build(BuildContext context) {
    final users = bundle.activeUsers.users
        .take(
          controller.visibleCount(
            'overview_users',
            bundle.activeUsers.users.length,
          ),
        )
        .toList();
    return Column(
      children: [
        SmartSectionHeader(
          title: 'Cán bộ hoạt động',
          actionLabel: '${bundle.activeUsers.totals}',
        ),
        ...users.map((user) => _ActiveUserRow(user: user)),
        if (bundle.activeUsers.users.length > 3)
          _LoadMoreRow(
            isExpanded: controller.isExpanded(
              'overview_users',
              bundle.activeUsers.users.length,
            ),
            onTap: () => controller.toggleLoadMore(
              'overview_users',
              bundle.activeUsers.users.length,
            ),
          ),
      ],
    );
  }
}
