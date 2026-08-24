part of '../home_screen.dart';

class _UrgentAlertsScreen extends StatelessWidget {
  final HomeController controller;

  const _UrgentAlertsScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.urgentAlertBundle.value;
      final items = controller.filteredUrgentInformation();
      final total = bundle.information.totals > 0
          ? bundle.information.totals
          : bundle.information.items.length;
      final read = bundle.information.items.where((item) => item.isRead).length;
      final unread = (total - read).clamp(0, total);
      final urgent = bundle.information.items
          .where((item) => item.isUrgent)
          .length;

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Điều hành',
            title: 'Thông báo',
            actionLabel: controller.isUrgentAlertLoading.value
                ? 'Đang tải...'
                : 'Làm mới',
            onAction: controller.isUrgentAlertLoading.value
                ? null
                : controller.fetchUrgentAlerts,
          ),
          if (controller.isUrgentAlertLoading.value)
            const LinearProgressIndicator(minHeight: 2),
          if (controller.urgentAlertError.value != null)
            _InlineError(
              message: controller.urgentAlertError.value!,
              onRetry: controller.fetchUrgentAlerts,
            ),
          _UrgentStatWrap(
            stats: [
              SmartStatData(value: '$total', label: 'Tổng thông báo'),
              SmartStatData(
                value: '${bundle.notifications.totals}',
                label: 'Thông báo nhận',
                tone: SmartTone.accent,
              ),
              SmartStatData(
                value: '$read',
                label: 'Đã đọc',
                tone: SmartTone.success,
              ),
              SmartStatData(
                value: '$unread',
                label: 'Chưa đọc',
                tone: SmartTone.warning,
              ),
              SmartStatData(
                value: '$urgent',
                label: 'Khẩn cấp',
                tone: SmartTone.danger,
              ),
            ],
          ),
          _UrgentSearchFilterBar(controller: controller),
          _UrgentAlertList(
            items: items,
            groups: bundle.groups.groups,
            onDetail: (item) => _showUrgentDetail(context, item, bundle),
          ),
        ],
      );
    });
  }
}

class _UrgentStatWrap extends StatelessWidget {
  final List<SmartStatData> stats;

  const _UrgentStatWrap({required this.stats});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          92, // Fixed height to prevent layout issues in unconstrained parents
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: stats.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) =>
            SizedBox(width: 140, child: _UrgentStatCard(stat: stats[index])),
      ),
    );
  }
}

class _UrgentStatCard extends StatelessWidget {
  final SmartStatData stat;

  const _UrgentStatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    final colors = _periodToneColors(stat.tone);
    return SmartCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      radius: 16,
      color: colors.background,
      borderColor: colors.foreground.withValues(alpha: 0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.h2.copyWith(
              color: colors.foreground,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _UrgentSearchFilterBar extends StatelessWidget {
  final HomeController controller;

  const _UrgentSearchFilterBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.urgentSearchController,
              onSubmitted: controller.searchUrgentAlerts,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm thông báo...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  size: 22,
                  color: AppColors.textSecondary,
                ),
                filled: true,
                fillColor: SmartColors.surface,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: SmartColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: SmartColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: SmartColors.accent),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 46,
            child: OutlinedButton.icon(
              onPressed: () => _showUrgentFilterSheet(context, controller),
              icon: const Icon(Icons.tune_rounded, size: 20),
              label: const Text(
                'Lọc',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                backgroundColor: SmartColors.surface,
                side: const BorderSide(color: SmartColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UrgentAlertList extends StatelessWidget {
  final List<InformationItem> items;
  final List<AlertGroupItem> groups;
  final ValueChanged<InformationItem> onDetail;

  const _UrgentAlertList({
    required this.items,
    required this.groups,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'Lịch sử thông báo (${items.length})',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const Divider(height: 1, color: SmartColors.border),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.all(24),
              child: _EmptyState(
                title: 'Chưa có thông báo',
                note: 'Thử đổi từ khóa hoặc bộ lọc để xem thêm.',
              ),
            )
          else
            ...items.asMap().entries.map(
              (entry) => Column(
                children: [
                  _UrgentAlertRow(
                    item: entry.value,
                    groups: groups,
                    onDetail: () => onDetail(entry.value),
                  ),
                  if (entry.key < items.length - 1)
                    const Divider(
                      height: 1,
                      color: SmartColors.border,
                      indent: 64,
                      endIndent: 16,
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _UrgentAlertRow extends StatelessWidget {
  final InformationItem item;
  final List<AlertGroupItem> groups;
  final VoidCallback onDetail;

  const _UrgentAlertRow({
    required this.item,
    required this.groups,
    required this.onDetail,
  });

  @override
  Widget build(BuildContext context) {
    final groupLabel = _urgentGroupLabel(item, groups);
    return InkWell(
      onTap: onDetail,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: item.isUrgent
                    ? SmartColors.dangerSoft
                    : SmartColors.accentSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.isUrgent
                    ? Icons.priority_high_rounded
                    : Icons.notifications_outlined,
                color: item.isUrgent ? SmartColors.danger : SmartColors.accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title.isNotEmpty ? item.title : 'Thông báo',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: item.isRead
                                ? FontWeight.w500
                                : FontWeight.w800,
                            color: item.isRead
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (!item.isRead) ...[
                        const SizedBox(width: 12),
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 6),
                          decoration: const BoxDecoration(
                            color: SmartColors.accent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (item.shortDescription.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.shortDescription.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 14,
                    runSpacing: 6,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _UrgentCleanMeta(
                        icon: Icons.schedule_rounded,
                        text: _urgentDateLabel(item.timeSet),
                      ),
                      _UrgentCleanMeta(
                        icon: Icons.groups_2_outlined,
                        text: groupLabel,
                      ),
                      if (item.numberRemind > 0)
                        _UrgentCleanMeta(
                          icon: Icons.alarm_rounded,
                          text: '${item.numberRemind} phút',
                          color: SmartColors.warning,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UrgentCleanMeta extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const _UrgentCleanMeta({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: effectiveColor),
        const SizedBox(width: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 140),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: effectiveColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _UrgentMeta extends StatelessWidget {
  final IconData icon;
  final String text;

  const _UrgentMeta({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: SmartColors.soft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 150),
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UrgentFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double maxWidth;

  const _UrgentFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.maxWidth = 150,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w800,
            height: 1.05,
          ),
        ),
      ),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
      backgroundColor: SmartColors.soft,
      selectedColor: SmartColors.accentSoft,
      side: BorderSide(
        color: selected
            ? SmartColors.accent.withValues(alpha: 0.18)
            : Colors.transparent,
      ),
      shape: const StadiumBorder(),
    );
  }
}

void _showUrgentFilterSheet(BuildContext context, HomeController controller) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: SmartColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
          child: Obx(
            () => _UrgentFilterSheetContent(
              controller: controller,
              groups: controller.urgentAlertBundle.value.groups.groups,
            ),
          ),
        ),
      );
    },
  );
}

class _UrgentFilterSheetContent extends StatelessWidget {
  final HomeController controller;
  final List<AlertGroupItem> groups;

  const _UrgentFilterSheetContent({
    required this.controller,
    required this.groups,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Bộ lọc thông báo',
                  style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _UrgentFilterGroup(
            title: 'Loại hiển thị',
            children: ['all', 'urgent', 'unread']
                .map(
                  (value) => _UrgentFilterChip(
                    label: _urgentFilterLabel(value),
                    selected: controller.urgentFilter.value == value,
                    onTap: () => controller.urgentFilter.value = value,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          _UrgentFilterGroup(
            title: 'Trạng thái API',
            children: [
              _statusChip(controller, -100, 'Tất cả'),
              _statusChip(controller, 1, 'Đã xem'),
              _statusChip(controller, 0, 'Chưa xem'),
            ],
          ),
          const SizedBox(height: 12),
          _UrgentFilterGroup(
            title: 'Nhóm nhận',
            children: [
              _UrgentFilterChip(
                label: 'Tất cả nhóm',
                selected: controller.urgentGroupFilter.value == 0,
                onTap: () => controller.setUrgentGroupFilter(0),
              ),
              ...groups.map(
                (group) => _UrgentFilterChip(
                  label: group.groupName,
                  selected: controller.urgentGroupFilter.value == group.groupId,
                  onTap: () => controller.setUrgentGroupFilter(group.groupId),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SmartPrimaryButton(
                  label: 'Xóa lọc',
                  secondary: true,
                  onTap: controller.clearUrgentFilters,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SmartPrimaryButton(
                  label: 'Áp dụng',
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(HomeController controller, int value, String label) {
    return _UrgentFilterChip(
      label: label,
      selected: controller.urgentStatusFilter.value == value,
      onTap: () => controller.setUrgentStatusFilter(value),
      maxWidth: 110,
    );
  }
}

class _UrgentFilterGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _UrgentFilterGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 6, runSpacing: 6, children: children),
      ],
    );
  }
}

void _showUrgentDetail(
  BuildContext context,
  InformationItem item,
  UrgentAlertBundle bundle,
) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: SmartColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title.isNotEmpty ? item.title : 'Thông báo',
                        style: AppTextStyles.h2.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SmartPill(
                      label: item.isRead ? 'Đã đọc' : 'Chưa đọc',
                      tone: item.isRead ? SmartTone.success : SmartTone.warning,
                    ),
                    if (item.isUrgent)
                      const SmartPill(
                        label: 'Khẩn cấp',
                        tone: SmartTone.danger,
                      ),
                    SmartPill(
                      label: _urgentDateLabel(item.timeSet),
                      tone: SmartTone.neutral,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _UrgentDetailLine(
                  label: 'Nhóm nhận',
                  value: _urgentGroupLabel(item, bundle.groups.groups),
                ),
                _UrgentDetailLine(
                  label: 'Nhắc trước',
                  value: item.numberRemind > 0
                      ? '${item.numberRemind} phút'
                      : 'Không nhắc',
                ),
                _UrgentDetailLine(
                  label: 'Mô tả ngắn',
                  value: item.shortDescription.trim().isNotEmpty
                      ? item.shortDescription.trim()
                      : 'Không có',
                ),
                const SizedBox(height: 10),
                Text(
                  'Nội dung',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description.trim().isNotEmpty
                      ? item.description.trim()
                      : 'Không có nội dung chi tiết.',
                  style: AppTextStyles.body.copyWith(height: 1.35),
                ),
                if (item.filePaths.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    'Tệp đính kèm',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...item.filePaths.map(
                    (path) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _UrgentMeta(
                        icon: Icons.attach_file_rounded,
                        text: path,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _UrgentDetailLine extends StatelessWidget {
  final String label;
  final String value;

  const _UrgentDetailLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 94,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _urgentDateLabel(DateTime? value) {
  if (value == null) return 'Chưa đặt lịch';
  final day = value.day.toString().padLeft(2, '0');
  final month = value.month.toString().padLeft(2, '0');
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$day/$month/${value.year} $hour:$minute';
}

String _urgentGroupLabel(InformationItem item, List<AlertGroupItem> groups) {
  if (item.groupIds.isEmpty) return 'Chưa chọn nhóm';
  final names = groups
      .where((group) => item.groupIds.contains(group.groupId))
      .map((group) => group.groupName)
      .where((name) => name.trim().isNotEmpty)
      .toList();
  if (names.isEmpty) return '${item.groupIds.length} nhóm';
  if (names.length <= 2) return names.join(', ');
  return '${names.take(2).join(', ')} +${names.length - 2}';
}

class _TasksScreen extends StatelessWidget {
  final HomeController controller;

  const _TasksScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final processes = _filteredTaskProcesses(
        controller.kpiBundle.value.processes,
        controller.taskQuery.value,
        controller.taskStatus.value,
      );
      final all = controller.kpiBundle.value.processes;

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Nghiệp vụ',
            title: 'Quản lý công việc',
            badge: '${processes.length} việc',
            actionLabel: 'Tạo mới',
            onAction: controller.openProcessCreate,
          ),
          if (controller.processCreateMessage.value != null)
            _InlineSuccess(message: controller.processCreateMessage.value!),
          if (controller.isKpiLoading.value) const LinearProgressIndicator(),
          if (controller.kpiError.value != null)
            _InlineError(
              message: controller.kpiError.value!,
              onRetry: controller.fetchKpiPrograms,
            ),
          SmartStatGrid(
            stats: [
              SmartStatData(value: all.length.toString(), label: 'Tổng việc'),
              SmartStatData(
                value: all
                    .where((item) => !item.isDone && !item.isLate)
                    .length
                    .toString(),
                label: 'Đang xử lý',
                tone: SmartTone.accent,
              ),
              SmartStatData(
                value: all.where((item) => item.isLate).length.toString(),
                label: 'Quá hạn',
                tone: SmartTone.danger,
              ),
              SmartStatData(
                value: all.where((item) => item.isDone).length.toString(),
                label: 'Hoàn thành',
                tone: SmartTone.success,
              ),
            ],
          ),
          SmartSearchPanel(
            controller: controller.taskSearchController,
            hint: 'Tìm tiêu đề, mã việc, trạng thái...',
            onChanged: (value) => controller.taskQuery.value = value,
            chips: const ['all', 'overdue', 'doing', 'complete'],
            activeChip: controller.taskStatus.value,
            chipLabelBuilder: _taskStatusLabel,
            onChipSelected: (value) => controller.taskStatus.value = value,
          ),
          SmartCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 13, 14, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Danh sách giao việc',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Text(
                        '${processes.length} / ${all.length}',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (processes.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(18),
                    child: _EmptyState(
                      title: 'Không có giao việc phù hợp',
                      note: 'Thử đổi từ khóa hoặc bộ lọc trạng thái.',
                    ),
                  )
                else
                  ...processes.asMap().entries.map((entry) {
                    return Column(
                      children: [
                        _TaskProcessCard(
                          item: entry.value,
                          onTap: () =>
                              _showTaskProcessDetail(context, entry.value),
                        ),
                        if (entry.key < processes.length - 1)
                          const Divider(height: 1, indent: 70),
                      ],
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

class _TaskProcessCard extends StatelessWidget {
  final KpiProcessItem item;
  final VoidCallback onTap;

  const _TaskProcessCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmartIconBadge(
              label: item.processId > 0 ? '#${item.processId}' : 'GV',
              tone: item.statusTone,
              size: 42,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title.trim().isEmpty
                              ? 'Giao việc chưa đặt tiêu đề'
                              : item.title.trim(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w900,
                            height: 1.25,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SmartPill(
                        label: item.displayStatus,
                        tone: item.statusTone,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      _TaskMeta(
                        icon: Icons.event_available_outlined,
                        text: _formatDateLabel(item.dateExpired),
                        color: item.isLate
                            ? SmartColors.danger
                            : AppColors.textSecondary,
                      ),
                      if (item.kpiId > 0)
                        _TaskMeta(
                          icon: Icons.query_stats_rounded,
                          text: 'KPI #${item.kpiId}',
                        ),
                      _TaskMeta(
                        icon: Icons.flag_outlined,
                        text: item.displayLevel,
                        color: item.isUrgent
                            ? SmartColors.warning
                            : AppColors.textSecondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.kpiId > 0
                        ? 'Liên kết KPI #${item.kpiId}'
                        : 'Nguồn giao việc',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskMeta extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const _TaskMeta({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? AppColors.textSecondary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: effectiveColor),
        const SizedBox(width: 4),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            fontSize: 11,
            color: effectiveColor,
            fontWeight: color == null ? FontWeight.w500 : FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

void _showTaskProcessDetail(BuildContext context, KpiProcessItem item) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: SmartColors.background,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: SmartColors.border),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title.trim().isEmpty
                              ? 'Giao việc chưa đặt tiêu đề'
                              : item.title.trim(),
                          style: AppTextStyles.h3.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Đóng',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      SmartPill(
                        label: item.displayStatus,
                        tone: item.statusTone,
                      ),
                      SmartPill(
                        label: item.displayLevel,
                        tone: SmartTone.neutral,
                      ),
                      if (item.kpiId > 0)
                        SmartPill(
                          label: 'KPI #${item.kpiId}',
                          tone: SmartTone.accent,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _TaskDetailRow(
                    label: 'Mã giao việc',
                    value: '#${item.processId}',
                    icon: Icons.tag_outlined,
                  ),
                  _TaskDetailRow(
                    label: 'Hạn xử lý',
                    value: _formatDateLabel(item.dateExpired),
                    icon: Icons.event_available_outlined,
                  ),
                  _TaskDetailRow(
                    label: 'Trạng thái',
                    value: item.displayStatus,
                    icon: Icons.verified_outlined,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _TaskDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _TaskDetailRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: SmartColors.soft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: SmartColors.accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.trim().isEmpty ? 'Chưa cập nhật' : value.trim(),
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

List<KpiProcessItem> _filteredTaskProcesses(
  List<KpiProcessItem> items,
  String query,
  String status,
) {
  final normalizedQuery = query.trim().toLowerCase();
  return items.where((item) {
    final matchesStatus = switch (status) {
      'overdue' => item.isLate,
      'doing' => !item.isDone && !item.isLate,
      'complete' => item.isDone,
      _ => true,
    };
    if (!matchesStatus) return false;
    if (normalizedQuery.isEmpty) return true;
    final searchable = [
      item.processId.toString(),
      item.title,
      item.statusName,
      item.kpiId.toString(),
    ].join(' ').toLowerCase();
    return searchable.contains(normalizedQuery);
  }).toList();
}

extension _TaskProcessUi on KpiProcessItem {
  SmartTone get statusTone {
    if (isLate) return SmartTone.danger;
    if (isDone) return SmartTone.success;
    if (statusId == 2) return SmartTone.warning;
    return SmartTone.accent;
  }

  String get displayStatus {
    if (isLate && !isDone) return 'Quá hạn';
    if (statusName.trim().isNotEmpty) return statusName.trim();
    if (isDone) return 'Hoàn thành';
    return 'Đang xử lý';
  }

  bool get isUrgent => false;

  String get displayLevel => 'Thường';
}

class _ProcessCreateScreen extends StatelessWidget {
  final HomeController controller;

  const _ProcessCreateScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final dropdowns = controller.processDropdowns.value;
      final source = controller.selectedProcessSourceType.value;
      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Nghiệp vụ',
            title: 'Tạo giao việc',
          ),
          if (controller.processCreateMessage.value != null)
            _InlineSuccess(message: controller.processCreateMessage.value!),
          if (controller.isProcessDropdownLoading.value)
            const LinearProgressIndicator(),
          if (controller.processFormError.value != null)
            _InlineError(
              message: controller.processFormError.value!,
              onRetry: controller.fetchProcessDropdowns,
            ),
          SmartCard(
            radius: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FormTextField(
                  label: 'Tiêu đề *',
                  controller: controller.processTitleController,
                  hint: 'Nhập tiêu đề giao việc',
                ),
                const SizedBox(height: 12),
                _FormTextField(
                  label: 'Mô tả',
                  controller: controller.processDescriptionController,
                  hint: 'Nội dung chi tiết cần xử lý',
                  maxLines: 4,
                ),
                const SizedBox(height: 12),
                _FormDropdown<ProcessUserOption>(
                  label: 'Người xử lý *',
                  value: controller.selectedProcessUser.value,
                  items: dropdowns.users,
                  emptyText: 'Không có cán bộ hoạt động',
                  itemLabel: (item) =>
                      '${item.displayName} · ${item.departmentName}',
                  onChanged: (value) =>
                      controller.selectedProcessUser.value = value,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _FormDropdown<ProcessLevelOption>(
                        label: 'Mức độ *',
                        value: controller.selectedProcessLevel.value,
                        items: ProcessLevelOption.all,
                        itemLabel: (item) => item.name,
                        onChanged: (value) =>
                            controller.selectedProcessLevel.value = value,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: _DueDateField(controller: controller)),
                  ],
                ),
                const SizedBox(height: 12),
                _FormDropdown<ProcessSourceTypeOption>(
                  label: 'Nguồn giao việc *',
                  value: source,
                  items: ProcessSourceTypeOption.all,
                  itemLabel: (item) => item.name,
                  onChanged: (value) {
                    controller.selectedProcessSourceType.value = value;
                    if (value == ProcessSourceTypeOption.kpi &&
                        controller.selectedProcessKpi.value == null &&
                        dropdowns.kpis.isNotEmpty) {
                      controller.selectedProcessKpi.value =
                          dropdowns.kpis.first;
                    }
                    if (value == ProcessSourceTypeOption.document &&
                        controller.selectedProcessDocument.value == null &&
                        dropdowns.documents.isNotEmpty) {
                      controller.selectedProcessDocument.value =
                          dropdowns.documents.first;
                    }
                  },
                ),
                const SizedBox(height: 12),
                _ProcessSourceFields(controller: controller),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: _FormTextField(
                        label: 'File đính kèm',
                        controller: controller.processAttachmentController,
                        hint: 'Đường dẫn file (mỗi dòng một file)',
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 104,
                      child: Obx(
                        () => SmartPrimaryButton(
                          label: controller.isUploading.value
                              ? 'Đang tải...'
                              : 'Tải file',
                          secondary: true,
                          onTap: controller.isUploading.value
                              ? null
                              : controller.pickAndUploadProcessAttachment,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: SmartPrimaryButton(
                  label: 'Hủy',
                  secondary: true,
                  onTap: () => controller.showView(AdminSmartView.tasks),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: SmartPrimaryButton(
                  label: controller.isProcessCreating.value
                      ? 'Đang tạo...'
                      : 'Tạo giao việc',
                  onTap: controller.isProcessCreating.value
                      ? null
                      : controller.createProcess,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _ProcessSourceFields extends StatelessWidget {
  final HomeController controller;

  const _ProcessSourceFields({required this.controller});

  @override
  Widget build(BuildContext context) {
    final dropdowns = controller.processDropdowns.value;
    final source = controller.selectedProcessSourceType.value;

    if (source == ProcessSourceTypeOption.document) {
      return _FormDropdown<ProcessDocumentOption>(
        label: 'Văn bản liên quan *',
        value: controller.selectedProcessDocument.value,
        items: dropdowns.documents,
        emptyText: 'Chưa có văn bản từ API document/get-list',
        itemLabel: (item) => '${item.title} · ${item.codeReference}',
        onChanged: (value) => controller.selectedProcessDocument.value = value,
      );
    }

    if (source == ProcessSourceTypeOption.kpi) {
      return _FormDropdown<ProcessKpiOption>(
        label: 'KPI liên quan *',
        value: controller.selectedProcessKpi.value,
        items: dropdowns.kpis,
        emptyText: 'Không có KPI',
        itemLabel: (item) => '${item.kpiName} · ${item.departmentName}',
        onChanged: (value) => controller.selectedProcessKpi.value = value,
      );
    }

    final booking = controller.selectedProcessBooking.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FormDropdown<ProcessBookingOption>(
          label: 'Cuộc họp *',
          value: booking,
          items: dropdowns.bookings,
          emptyText: 'Không có cuộc họp',
          itemLabel: (item) =>
              '${item.title} · ${_formatDateLabel(item.dateStart)}',
          onChanged: controller.selectProcessBooking,
        ),
        const SizedBox(height: 12),
        _FormDropdown<ProcessConclusionOption>(
          label: 'Kết luận',
          value: controller.selectedProcessConclusion.value,
          items: booking?.conclusions ?? const [],
          emptyText: 'Cuộc họp này chưa có kết luận, sẽ gửi ConclusionID = 0',
          itemLabel: (item) => '${item.codeReference} · ${item.title}',
          onChanged: (value) =>
              controller.selectedProcessConclusion.value = value,
        ),
      ],
    );
  }
}

class _DueDateField extends StatelessWidget {
  final HomeController controller;

  const _DueDateField({required this.controller});

  @override
  Widget build(BuildContext context) {
    final date = controller.selectedProcessDueDate.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hạn xử lý *',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: DateTime(2024),
              lastDate: DateTime(2035),
            );
            if (picked != null) {
              controller.selectedProcessDueDate.value = picked;
            }
          },
          child: InputDecorator(
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.calendar_today_rounded, size: 18),
            ),
            child: Text(
              _formatDateLabel(date),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body,
            ),
          ),
        ),
      ],
    );
  }
}

class _FormDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final ValueChanged<T?> onChanged;
  final String emptyText;

  const _FormDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.emptyText = 'Không có dữ liệu',
  });

  @override
  Widget build(BuildContext context) {
    final effectiveValue = items.contains(value) ? value : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        if (items.isEmpty)
          InputDecorator(
            decoration: const InputDecoration(),
            child: Text(
              emptyText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          )
        else
          DropdownButtonFormField<T>(
            initialValue: effectiveValue,
            isExpanded: true,
            items: items
                .map(
                  (item) => DropdownMenuItem<T>(
                    value: item,
                    child: Text(
                      itemLabel(item),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
      ],
    );
  }
}

class _FormTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _FormTextField({
    required this.label,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}
