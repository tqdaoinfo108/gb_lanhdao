part of '../home_screen.dart';

class _CrimeReportsScreen extends StatelessWidget {
  final HomeController controller;

  const _CrimeReportsScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.crimeReportBundle.value;
      final warnings = bundle.warnings.items;
      final total = bundle.warnings.totals > 0
          ? bundle.warnings.totals
          : warnings.length;

      // Tính stat theo statusId
      final received = warnings.where((w) => w.statusId == 1).length;
      final investigating = warnings.where((w) => w.statusId == 2).length;
      final resolved = warnings.where((w) => w.statusId == 3).length;
      final duplicate = warnings.where((w) => w.statusId == 4).length;

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Tiếp nhận',
            title: 'Tố giác tội phạm',
            actionLabel: controller.isCrimeReportLoading.value
                ? 'Đang tải...'
                : 'Nộp đơn',
            onAction: controller.isCrimeReportLoading.value
                ? null
                : controller.openCrimeReportNew,
          ),
          if (controller.isCrimeReportLoading.value)
            const LinearProgressIndicator(minHeight: 2),
          if (controller.crimeReportError.value != null)
            _InlineError(
              message: controller.crimeReportError.value!,
              onRetry: controller.fetchCrimeReports,
            ),
          // ── Stat cards ──
          SizedBox(
            height: 92,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              children: [
                _CrimeStatCard(
                  stat: SmartStatData(value: '$total', label: 'Tổng đơn'),
                ),
                const SizedBox(width: 10),
                _CrimeStatCard(
                  stat: SmartStatData(
                    value: '$received',
                    label: 'Tiếp nhận',
                    tone: SmartTone.accent,
                  ),
                ),
                const SizedBox(width: 10),
                _CrimeStatCard(
                  stat: SmartStatData(
                    value: '$investigating',
                    label: 'Đang điều tra',
                    tone: SmartTone.warning,
                  ),
                ),
                const SizedBox(width: 10),
                _CrimeStatCard(
                  stat: SmartStatData(
                    value: '$resolved',
                    label: 'Đã xử lý',
                    tone: SmartTone.success,
                  ),
                ),
                const SizedBox(width: 10),
                _CrimeStatCard(
                  stat: SmartStatData(
                    value: '$duplicate',
                    label: 'Đơn trùng',
                    tone: SmartTone.neutral,
                  ),
                ),
              ],
            ),
          ),
          // ── Search + Filter ──
          _CrimeSearchBar(controller: controller),
          // ── List ──
          _CrimeReportList(items: warnings, controller: controller),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat card
// ─────────────────────────────────────────────────────────────────────────────

class _CrimeStatCard extends StatelessWidget {
  final SmartStatData stat;

  const _CrimeStatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    final colors = _periodToneColors(stat.tone);
    return SizedBox(
      width: 130,
      child: SmartCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        radius: 16,
        color: colors.background,
        borderColor: colors.foreground.withValues(alpha: 0.15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
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
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Search + Filter bar
// ─────────────────────────────────────────────────────────────────────────────

class _CrimeSearchBar extends StatelessWidget {
  final HomeController controller;

  const _CrimeSearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.crimeSearchController,
            onSubmitted: controller.searchCrimeReports,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Tìm mã hồ sơ, tiêu đề, người nộp...',
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
        OutlinedButton.icon(
          onPressed: () => _showCrimeFilterSheet(context, controller),
          icon: const Icon(Icons.tune_rounded, size: 20),
          label: const Text(
            'Lọc',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textPrimary,
            backgroundColor: SmartColors.surface,
            minimumSize: const Size(0, 46),
            side: const BorderSide(color: SmartColors.border),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Crime report list
// ─────────────────────────────────────────────────────────────────────────────

class _CrimeReportList extends StatelessWidget {
  final List<WarningItem> items;
  final HomeController controller;

  const _CrimeReportList({required this.items, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              'Danh sách hồ sơ (${items.length})',
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
                title: 'Chưa có đơn tố giác',
                note: 'Thử đổi từ khóa hoặc bộ lọc để xem thêm.',
              ),
            )
          else
            ...items.asMap().entries.map(
              (entry) => Column(
                children: [
                  _CrimeReportRow(item: entry.value, controller: controller),
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

// ─────────────────────────────────────────────────────────────────────────────
// Single crime report row
// ─────────────────────────────────────────────────────────────────────────────

class _CrimeReportRow extends StatelessWidget {
  final WarningItem item;
  final HomeController controller;

  const _CrimeReportRow({required this.item, required this.controller});

  @override
  Widget build(BuildContext context) {
    final deptName = controller.crimeDepartmentName(item.departmentId);
    return InkWell(
      onTap: () => _showCrimeDetail(context, item, controller),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Level icon ──
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: item.levelId >= 3
                    ? SmartColors.dangerSoft
                    : item.levelId == 2
                    ? SmartColors.warningSoft
                    : SmartColors.accentSoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.levelId >= 3 ? Icons.warning_rounded : Icons.gavel_rounded,
                color: item.levelColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            // ── Content ──
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + status pill
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.warningTitle.isNotEmpty
                              ? item.warningTitle
                              : 'Đơn tố giác',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SmartPill(
                        label: item.statusName.isNotEmpty
                            ? item.statusName
                            : 'N/A',
                        tone: item.statusTone,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Code + Type
                  Row(
                    children: [
                      if (item.warningCode.isNotEmpty) ...[
                        Text(
                          item.warningCode,
                          style: AppTextStyles.caption.copyWith(
                            color: SmartColors.accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (item.typeWarningName.isNotEmpty)
                        Expanded(
                          child: Text(
                            item.typeWarningName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Meta row: dept, level, date, sender
                  Wrap(
                    spacing: 14,
                    runSpacing: 6,
                    children: [
                      _CrimeMeta(icon: Icons.apartment_rounded, text: deptName),
                      _CrimeMeta(
                        icon: Icons.flag_rounded,
                        text: item.levelLabel,
                        color: item.levelColor,
                      ),
                      _CrimeMeta(
                        icon: Icons.schedule_rounded,
                        text: _crimeDateLabel(item.dateSent),
                      ),
                      _CrimeMeta(
                        icon: Icons.person_outline_rounded,
                        text: item.userSent.isNotEmpty
                            ? item.userSent
                            : 'Ẩn danh',
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

// ─────────────────────────────────────────────────────────────────────────────
// Meta label (icon + text, NO Flexible/Expanded/IntrinsicWidth)
// ─────────────────────────────────────────────────────────────────────────────

class _CrimeMeta extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const _CrimeMeta({required this.icon, required this.text, this.color});

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

// ─────────────────────────────────────────────────────────────────────────────
// Date formatter
// ─────────────────────────────────────────────────────────────────────────────

String _crimeDateLabel(DateTime? date) {
  if (date == null) return 'Không rõ';
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

void _showCrimeFilterSheet(BuildContext context, HomeController controller) {
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
          child: Obx(() => _CrimeFilterSheetContent(controller: controller)),
        ),
      );
    },
  );
}

class _CrimeFilterSheetContent extends StatelessWidget {
  final HomeController controller;

  const _CrimeFilterSheetContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    final types = controller.crimeReportBundle.value.types.items;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Bộ lọc tố giác',
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
          // ── Status filter ──
          Text(
            'Trạng thái',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _crimeFilterChip(controller, -100, 'Tất cả', isStatus: true),
              _crimeFilterChip(controller, 1, 'Tiếp nhận', isStatus: true),
              _crimeFilterChip(controller, 2, 'Đang điều tra', isStatus: true),
              _crimeFilterChip(controller, 3, 'Đã xử lý', isStatus: true),
              _crimeFilterChip(controller, 5, 'Ngưng', isStatus: true),
            ],
          ),
          const SizedBox(height: 16),
          // ── Type filter ──
          Text(
            'Loại tố giác',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _crimeFilterChip(controller, 0, 'Tất cả', isStatus: false),
              ...types.map(
                (t) => _crimeFilterChip(
                  controller,
                  t.typeWarningId,
                  t.typeWarningName,
                  isStatus: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: SmartPrimaryButton(
                  label: 'Xóa lọc',
                  secondary: true,
                  onTap: () {
                    controller.clearCrimeFilters();
                    Navigator.pop(context);
                  },
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

  Widget _crimeFilterChip(
    HomeController controller,
    int value,
    String label, {
    required bool isStatus,
  }) {
    final selected = isStatus
        ? controller.crimeStatusFilter.value == value
        : controller.crimeTypeFilter.value == value;
    return ChoiceChip(
      label: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 150),
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
      onSelected: (_) {
        if (isStatus) {
          controller.setCrimeStatusFilter(value);
        } else {
          controller.setCrimeTypeFilter(value);
        }
      },
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

// ─────────────────────────────────────────────────────────────────────────────
// Detail bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

void _showCrimeDetail(
  BuildContext context,
  WarningItem item,
  HomeController controller,
) {
  final deptName = controller.crimeDepartmentName(item.departmentId);
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: const BoxDecoration(
          color: SmartColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                // Handle bar
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 16),
                    height: 5,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header section
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: SmartColors.accentSoft,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.assignment_late_rounded,
                                color: SmartColors.accent,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.warningTitle.isNotEmpty
                                        ? item.warningTitle
                                        : 'Đơn tố giác',
                                    style: AppTextStyles.h2.copyWith(
                                      fontWeight: FontWeight.w900,
                                      height: 1.25,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      if (item.warningCode.isNotEmpty)
                                        SmartPill(
                                          label: item.warningCode,
                                          tone: SmartTone.accent,
                                        ),
                                      SmartPill(
                                        label: item.statusName.isNotEmpty
                                            ? item.statusName
                                            : 'N/A',
                                        tone: item.statusTone,
                                      ),
                                      SmartPill(
                                        label: item.levelLabel,
                                        tone: item.levelTone,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Unified Details Container
                        Container(
                          decoration: BoxDecoration(
                            color: SmartColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: SmartColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: SmartColors.border.withValues(
                                  alpha: 0.4,
                                ),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _CrimeDetailRow(
                                label: 'Loại tố giác',
                                value: item.typeWarningName.isNotEmpty
                                    ? item.typeWarningName
                                    : 'Không rõ',
                              ),
                              _CrimeDetailRow(
                                label: 'Phòng ban',
                                value: deptName,
                              ),
                              _CrimeDetailRow(
                                label: 'Người nộp',
                                value: item.userSent.isNotEmpty
                                    ? item.userSent
                                    : 'Ẩn danh',
                              ),
                              _CrimeDetailRow(
                                label: 'Điện thoại',
                                value: item.phone.isNotEmpty
                                    ? item.phone
                                    : 'Không có',
                              ),
                              _CrimeDetailRow(
                                label: 'Ngày nộp',
                                value: _crimeDateLabel(item.dateSent),
                              ),
                              _CrimeDetailRow(
                                label: 'Địa chỉ',
                                value: item.address.isNotEmpty
                                    ? item.address
                                    : 'Không có',
                                isLast: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Description section
                        Text(
                          'Nội dung tố cáo',
                          style: AppTextStyles.h3.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: SmartColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: SmartColors.border),
                            boxShadow: [
                              BoxShadow(
                                color: SmartColors.border.withValues(
                                  alpha: 0.2,
                                ),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            item.description.trim().isNotEmpty
                                ? item.description.trim()
                                : 'Không có nội dung chi tiết.',
                            style: AppTextStyles.bodyMedium.copyWith(
                              height: 1.5,
                              color: AppColors.textPrimary.withValues(
                                alpha: 0.9,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

class _CrimeDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _CrimeDetailRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            thickness: 1,
            color: SmartColors.border,
            indent: 18,
            endIndent: 18,
          ),
      ],
    );
  }
}

class _CrimeReportNewScreen extends StatelessWidget {
  final HomeController controller;

  const _CrimeReportNewScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final analysis = controller.crimeAiAnalysis.value;
      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Tố giác',
            onBack: () => controller.showView(AdminSmartView.crimeReports),
            eyebrow: 'Hồ sơ mới',
            title: 'Nộp đơn tố giác / khiếu nại',
            badge: analysis == null ? 'Bảo mật' : 'Xác nhận',
          ),
          if (controller.crimeFormError.value != null)
            _InlineError(
              message: controller.crimeFormError.value!,
              onRetry: analysis == null
                  ? controller.analyzeCrimeReport
                  : controller.confirmCreateCrimeReport,
            ),
          if (analysis == null)
            _CrimeReportForm(controller: controller)
          else
            _CrimeReportConfirm(controller: controller, analysis: analysis),
        ],
      );
    });
  }
}

class _CrimeReportForm extends StatelessWidget {
  final HomeController controller;

  const _CrimeReportForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      radius: 22,
      padding: const EdgeInsets.all(14),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: SmartColors.soft,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: SmartColors.border),
              ),
              child: SwitchListTile.adaptive(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                secondary: const Icon(
                  Icons.visibility_off_outlined,
                  color: AppColors.textSecondary,
                ),
                title: Text(
                  'Nộp đơn ẩn danh',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                subtitle: Text(
                  'Thông tin cá nhân sẽ được mã hóa, chỉ lãnh đạo có thẩm quyền mới xem được',
                  style: AppTextStyles.caption,
                ),
                value: controller.anonymousReport.value,
                activeThumbColor: SmartColors.danger,
                onChanged: (value) {
                  controller.anonymousReport.value = value;
                  controller.crimeAiAnalysis.value = null;
                },
              ),
            ),
            if (!controller.anonymousReport.value) ...[
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 520;
                  final name = _CrimeFormField(
                    label: 'Họ và tên *',
                    controller: controller.crimeNameController,
                    hint: 'Nguyễn Văn A',
                  );
                  final phone = _CrimeFormField(
                    label: 'Số điện thoại',
                    controller: controller.crimePhoneController,
                    hint: '0901234567',
                    keyboardType: TextInputType.phone,
                  );
                  if (compact) {
                    return Column(
                      children: [name, const SizedBox(height: 10), phone],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: name),
                      const SizedBox(width: 10),
                      Expanded(child: phone),
                    ],
                  );
                },
              ),
            ],
            const SizedBox(height: 12),
            _CrimeFormField(
              label: 'Tiêu đề tố giác *',
              controller: controller.crimeTitleController,
              hint: 'Mô tả ngắn gọn về hành vi vi phạm...',
            ),
            const SizedBox(height: 10),
            _CrimeFormField(
              label: 'Nội dung chi tiết *',
              controller: controller.crimeDescriptionController,
              hint: 'Mô tả chi tiết sự việc, thời gian, đối tượng liên quan...',
              maxLines: 5,
            ),
            const SizedBox(height: 10),
            _CrimeFormField(
              label: 'Địa điểm xảy ra',
              controller: controller.crimeAddressController,
              hint: 'Địa chỉ cụ thể...',
            ),
            const SizedBox(height: 12),
            Text(
              'Bằng chứng đính kèm',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            _CrimeAttachmentList(controller: controller),
            const SizedBox(height: 8),
            _CrimeUploadBox(controller: controller),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SmartPrimaryButton(
                    label: 'Hủy',
                    secondary: true,
                    onTap: () =>
                        controller.showView(AdminSmartView.crimeReports),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SmartPrimaryButton(
                    label: controller.isCrimeAiAnalyzing.value
                        ? 'Đang phân tích...'
                        : 'Phân tích AI',
                    onTap: controller.isCrimeAiAnalyzing.value
                        ? null
                        : controller.analyzeCrimeReport,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CrimeReportConfirm extends StatelessWidget {
  final HomeController controller;
  final WarningAiAnalysis analysis;

  const _CrimeReportConfirm({required this.controller, required this.analysis});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AI Badge header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [SmartColors.accent, Color(0xFF1E48B4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: SmartColors.accent.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI đã phân tích nội dung',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Độ tin cậy: ${analysis.aiAnalysis}%',
                      style: AppTextStyles.h2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Unified Details Container
        Container(
          decoration: BoxDecoration(
            color: SmartColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: SmartColors.border),
            boxShadow: [
              BoxShadow(
                color: SmartColors.border.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              _CrimeConfirmDetailRow(
                label: 'Loại tố giác',
                value: controller.crimeTypeNameForCreate(analysis),
              ),
              _CrimeConfirmDetailRow(
                label: 'Phòng ban xử lý',
                value: controller.crimeDepartmentNameForCreate(analysis),
              ),
              _CrimeConfirmDetailRow(
                label: 'Mức độ',
                value: controller.crimeLevelNameForCreate(analysis),
                tone: _crimeLevelToneForId(analysis.levelId),
              ),
              _CrimeConfirmDetailRow(
                label: 'Mã dự kiến',
                value: 'TG-${DateTime.now().year}-******',
                isLast: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: SmartPrimaryButton(
                label: 'Sửa lại',
                secondary: true,
                onTap: controller.editCrimeReportForm,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SmartPrimaryButton(
                label: controller.isCrimeSubmitting.value
                    ? 'Đang nộp...'
                    : 'Xác nhận nộp',
                onTap: controller.isCrimeSubmitting.value
                    ? null
                    : controller.confirmCreateCrimeReport,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CrimeConfirmDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final SmartTone? tone;
  final bool isLast;

  const _CrimeConfirmDetailRow({
    required this.label,
    required this.value,
    this.tone,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: tone == null
                      ? Text(
                          value,
                          textAlign: TextAlign.right,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        )
                      : SmartPill(label: value, tone: tone!),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            thickness: 1,
            color: SmartColors.border,
            indent: 18,
            endIndent: 18,
          ),
      ],
    );
  }
}

class _CrimeFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;

  const _CrimeFormField({
    required this.label,
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
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
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class _CrimeAttachmentList extends StatelessWidget {
  final HomeController controller;

  const _CrimeAttachmentList({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.crimeAttachmentPaths.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: controller.crimeAttachmentPaths
          .map(
            (path) => Container(
              margin: const EdgeInsets.only(bottom: 7),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: SmartColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: SmartColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.insert_drive_file_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      path.split(RegExp(r'[\\/]')).last,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: () => controller.removeCrimeAttachment(path),
                    icon: const Icon(Icons.delete_outline_rounded, size: 18),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _CrimeUploadBox extends StatelessWidget {
  final HomeController controller;

  const _CrimeUploadBox({required this.controller});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: controller.isUploading.value
          ? null
          : controller.pickAndUploadCrimeAttachment,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          color: SmartColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: SmartColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              controller.isUploading.value
                  ? Icons.cloud_sync_outlined
                  : Icons.cloud_upload_outlined,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                controller.isUploading.value
                    ? 'Đang tải lên...'
                    : 'Bấm để tải tệp hình ảnh, bằng chứng',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CrimeConfirmTile extends StatelessWidget {
  final String label;
  final String value;
  final SmartTone? tone;

  const _CrimeConfirmTile({
    required this.label,
    required this.value,
    this.tone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 66),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SmartColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: SmartColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 7),
          if (tone == null)
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w800,
              ),
            )
          else
            Align(
              alignment: Alignment.centerLeft,
              child: SmartPill(label: value, tone: tone!),
            ),
        ],
      ),
    );
  }
}

SmartTone _crimeLevelToneForId(int levelId) {
  switch (levelId) {
    case 2:
      return SmartTone.warning;
    case 3:
      return SmartTone.danger;
    default:
      return SmartTone.success;
  }
}
