part of '../home_screen.dart';

class _DocumentsScreen extends StatelessWidget {
  final HomeController controller;

  const _DocumentsScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.documentBundle.value;
      final page = bundle.documents;

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Tiếp nhận, luân chuyển và theo dõi',
            title: 'Văn bản / Công văn',
            badge: '${page.documents.length} văn bản',
            actionLabel: 'Làm mới',
            onAction: controller.fetchDocuments,
          ),
          if (controller.isDocumentLoading.value)
            const LinearProgressIndicator(),
          if (controller.documentError.value != null)
            _InlineError(
              message: controller.documentError.value!,
              onRetry: controller.fetchDocuments,
            ),
          _DocumentStats(page: page),
          _DocumentMonthBar(controller: controller),
          _DocumentSearchAndFilters(controller: controller, bundle: bundle),
          _DocumentList(
            bundle: bundle,
            onItemTap: (item) => _showDocumentDetail(context, bundle, item),
          ),
          if (bundle.notifications.items.isNotEmpty) ...[
            SmartSectionHeader(
              title: 'Thông báo gần đây',
              actionLabel: '${bundle.notifications.totals}',
            ),
            ...bundle.notifications.items
                .take(3)
                .map((item) => _NotificationCard(item: item)),
          ],
        ],
      );
    });
  }
}

class _DocumentStats extends StatelessWidget {
  final DocumentPage page;

  const _DocumentStats({required this.page});

  @override
  Widget build(BuildContext context) {
    return SmartStatGrid(
      compact: true,
      stats: [
        SmartStatData(
          value: page.totalByMonth.toString(),
          label: 'Trong tháng',
          tone: SmartTone.accent,
        ),
        SmartStatData(
          value: page.totalReceived.toString(),
          label: 'Công văn đến',
        ),
        SmartStatData(
          value: page.totalSent.toString(),
          label: 'Công văn đi',
          tone: SmartTone.success,
        ),
        SmartStatData(
          value: page.totalNeedView.toString(),
          label: 'Chờ xử lý',
          tone: SmartTone.warning,
        ),
      ],
    );
  }
}

class _DocumentMonthBar extends StatelessWidget {
  final HomeController controller;

  const _DocumentMonthBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          _DocumentIconButton(
            tooltip: 'Tháng trước',
            icon: Icons.chevron_left_rounded,
            onTap: () => controller.moveDocumentMonth(-1),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  _documentMonthLabel(controller.documentMonth.value),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Kỳ văn bản đang xem',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(fontSize: 10.5),
                ),
              ],
            ),
          ),
          _DocumentIconButton(
            tooltip: 'Tháng sau',
            icon: Icons.chevron_right_rounded,
            onTap: () => controller.moveDocumentMonth(1),
          ),
        ],
      ),
    );
  }
}

class _DocumentSearchAndFilters extends StatelessWidget {
  final HomeController controller;
  final DocumentBundle bundle;

  const _DocumentSearchAndFilters({
    required this.controller,
    required this.bundle,
  });

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller.documentSearchController,
                  onSubmitted: controller.searchDocuments,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Tìm tiêu đề, số hiệu, đơn vị...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: controller.documentQuery.value.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Xóa tìm kiếm',
                            onPressed: () {
                              controller.documentQuery.value = '';
                              controller.documentSearchController.clear();
                              controller.fetchDocuments();
                            },
                            icon: const Icon(Icons.close_rounded, size: 18),
                          ),
                    isDense: true,
                    filled: true,
                    fillColor: SmartColors.soft,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: SmartColors.accent),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 9),
              _DocumentFilterButton(
                active: _activeDocumentFilterCount(controller),
                onTap: () => _showDocumentFilterSheet(
                  context,
                  controller: controller,
                  bundle: bundle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _DocumentSegment(
                label: 'Tất cả',
                selected: controller.documentTypeFilter.value == -100,
                onTap: () => controller.setDocumentTypeFilter(-100),
              ),
              const SizedBox(width: 8),
              _DocumentSegment(
                label: 'Đến',
                selected: controller.documentTypeFilter.value == 1,
                onTap: () => controller.setDocumentTypeFilter(1),
              ),
              const SizedBox(width: 8),
              _DocumentSegment(
                label: 'Đi',
                selected: controller.documentTypeFilter.value == 2,
                onTap: () => controller.setDocumentTypeFilter(2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _activeDocumentFilterCount(HomeController controller) {
    var count = 0;
    if (controller.documentTypeFilter.value != -100) count++;
    if (controller.documentStatusFilter.value != -100) count++;
    if (controller.documentFieldFilter.value != 0) count++;
    if (controller.documentQuery.value.trim().isNotEmpty) count++;
    return count;
  }
}

class _DocumentList extends StatelessWidget {
  final DocumentBundle bundle;
  final ValueChanged<DocumentItem> onItemTap;

  const _DocumentList({required this.bundle, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    final documents = bundle.documents.documents;
    return SmartCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 13, 14, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Danh sách văn bản',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  '${documents.length} / ${bundle.documents.totals}',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (documents.isEmpty)
            const Padding(
              padding: EdgeInsets.all(18),
              child: _EmptyState(
                title: 'Không có văn bản phù hợp',
                note: 'Thử đổi tháng, từ khóa hoặc bộ lọc.',
              ),
            )
          else
            ...documents.asMap().entries.map((entry) {
              return Column(
                children: [
                  _DocumentCard(
                    document: entry.value,
                    fieldName: bundle.fieldName(entry.value.fieldId),
                    onTap: () => onItemTap(entry.value),
                  ),
                  if (entry.key < documents.length - 1)
                    const Divider(height: 1, indent: 70),
                ],
              );
            }),
        ],
      ),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  final DocumentItem document;
  final String fieldName;
  final VoidCallback onTap;

  const _DocumentCard({
    required this.document,
    required this.fieldName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: document.isOutgoing
                    ? SmartColors.successSoft
                    : SmartColors.accentSoft,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                document.isOutgoing
                    ? Icons.north_east_rounded
                    : Icons.south_west_rounded,
                color: document.isOutgoing
                    ? SmartColors.success
                    : SmartColors.accent,
                size: 19,
              ),
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
                          document.documentTitle.isEmpty
                              ? 'Văn bản chưa đặt tên'
                              : document.documentTitle,
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
                        label: document.displayStatus,
                        tone: document.statusTone,
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 8,
                    runSpacing: 7,
                    children: [
                      SmartPill(
                        label: document.documentCode.isEmpty
                            ? '#${document.documentId}'
                            : document.documentCode,
                        tone: SmartTone.neutral,
                      ),
                      SmartPill(
                        label: document.typeLabel,
                        tone: document.typeTone,
                      ),
                      if (document.isUrgent)
                        const SmartPill(label: 'Khẩn', tone: SmartTone.warning),
                      if (document.isSignature)
                        const SmartPill(
                          label: 'Chữ ký số',
                          tone: SmartTone.accent,
                        ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      _DocumentMeta(
                        icon: Icons.calendar_today_outlined,
                        text: _formatDocumentDate(document.dateIssuance),
                      ),
                      _DocumentMeta(
                        icon: Icons.timer_outlined,
                        text: _formatDocumentDate(document.dateExpired),
                        color: document.isExpired
                            ? SmartColors.danger
                            : AppColors.textSecondary,
                      ),
                      _DocumentMeta(
                        icon: Icons.person_outline_rounded,
                        text: document.fullNameProcess.isEmpty
                            ? 'Chưa phân công'
                            : document.fullNameProcess,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Từ: ${_fallbackText(document.agencyNameFrom)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Đến: ${_fallbackText(document.agencyNameTo)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fieldName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(fontSize: 10.5),
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

class _DocumentFilterButton extends StatelessWidget {
  final int active;
  final VoidCallback onTap;

  const _DocumentFilterButton({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: active > 0 ? 86 : 72,
      height: 46,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.tune_rounded, size: 18),
        label: Text(active > 0 ? 'Lọc $active' : 'Lọc'),
        style: OutlinedButton.styleFrom(
          foregroundColor: active > 0
              ? SmartColors.accent
              : AppColors.textPrimary,
          backgroundColor: active > 0
              ? SmartColors.accentSoft
              : SmartColors.surface,
          side: BorderSide(
            color: active > 0
                ? SmartColors.accent.withValues(alpha: 0.28)
                : SmartColors.border,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          textStyle: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _DocumentSegment extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DocumentSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? SmartColors.accent : SmartColors.soft,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: selected ? Colors.white : AppColors.textSecondary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _DocumentIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  const _DocumentIconButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onTap,
      icon: Icon(icon, color: SmartColors.accent),
      style: IconButton.styleFrom(
        backgroundColor: SmartColors.accentSoft,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _DocumentMeta extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const _DocumentMeta({required this.icon, required this.text, this.color});

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

void _showDocumentFilterSheet(
  BuildContext context, {
  required HomeController controller,
  required DocumentBundle bundle,
}) {
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
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Bộ lọc văn bản',
                          style: AppTextStyles.h4.copyWith(
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
                  Text('Trạng thái', style: _documentFilterTitleStyle()),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _DocumentSheetChip(
                        label: 'Tất cả',
                        selected: controller.documentStatusFilter.value == -100,
                        onTap: () {
                          controller.setDocumentStatusFilter(-100);
                          Navigator.of(context).pop();
                        },
                      ),
                      _DocumentSheetChip(
                        label: 'Chờ xử lý',
                        selected: controller.documentStatusFilter.value == 1,
                        onTap: () {
                          controller.setDocumentStatusFilter(1);
                          Navigator.of(context).pop();
                        },
                      ),
                      _DocumentSheetChip(
                        label: 'Hoàn thành',
                        selected: controller.documentStatusFilter.value == 4,
                        onTap: () {
                          controller.setDocumentStatusFilter(4);
                          Navigator.of(context).pop();
                        },
                      ),
                      _DocumentSheetChip(
                        label: 'Đã ký số',
                        selected: controller.documentStatusFilter.value == 3,
                        onTap: () {
                          controller.setDocumentStatusFilter(3);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Lĩnh vực', style: _documentFilterTitleStyle()),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _DocumentSheetChip(
                        label: 'Tất cả lĩnh vực',
                        selected: controller.documentFieldFilter.value == 0,
                        onTap: () {
                          controller.setDocumentFieldFilter(0);
                          Navigator.of(context).pop();
                        },
                      ),
                      ...bundle.fields.fields.map((field) {
                        return _DocumentSheetChip(
                          label: field.fieldName,
                          selected:
                              controller.documentFieldFilter.value ==
                              field.fieldId,
                          onTap: () {
                            controller.setDocumentFieldFilter(field.fieldId);
                            Navigator.of(context).pop();
                          },
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SmartPrimaryButton(
                    label: 'Xóa bộ lọc',
                    secondary: true,
                    onTap: () {
                      controller.clearDocumentFilters();
                      Navigator.of(context).pop();
                    },
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

class _DocumentSheetChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _DocumentSheetChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      selectedColor: SmartColors.accentSoft,
      backgroundColor: SmartColors.surface,
      side: BorderSide(
        color: selected
            ? SmartColors.accent.withValues(alpha: 0.28)
            : SmartColors.border,
      ),
      shape: const StadiumBorder(),
      labelStyle: AppTextStyles.caption.copyWith(
        color: selected ? SmartColors.accent : AppColors.textPrimary,
        fontWeight: FontWeight.w900,
      ),
    );
  }
}

void _showDocumentDetail(
  BuildContext context,
  DocumentBundle bundle,
  DocumentItem document,
) {
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
                          document.documentTitle.isEmpty
                              ? 'Văn bản chưa đặt tên'
                              : document.documentTitle,
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
                        label: document.displayStatus,
                        tone: document.statusTone,
                      ),
                      SmartPill(
                        label: document.typeLabel,
                        tone: document.typeTone,
                      ),
                      SmartPill(
                        label: document.levelLabel,
                        tone: document.isUrgent
                            ? SmartTone.warning
                            : SmartTone.neutral,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _DocumentDetailRow(
                    label: 'Số hiệu',
                    value: document.documentCode,
                    icon: Icons.tag_outlined,
                  ),
                  _DocumentDetailRow(
                    label: 'Lĩnh vực',
                    value: bundle.fieldName(document.fieldId),
                    icon: Icons.folder_open_outlined,
                  ),
                  _DocumentDetailRow(
                    label: 'Đơn vị gửi',
                    value: document.agencyNameFrom,
                    icon: Icons.outbox_outlined,
                  ),
                  _DocumentDetailRow(
                    label: 'Đơn vị nhận',
                    value: document.agencyNameTo,
                    icon: Icons.move_to_inbox_outlined,
                  ),
                  _DocumentDetailRow(
                    label: 'Ngày ban hành',
                    value: _formatDocumentDate(document.dateIssuance),
                    icon: Icons.event_available_outlined,
                  ),
                  _DocumentDetailRow(
                    label: 'Hạn xử lý',
                    value: _formatDocumentDate(document.dateExpired),
                    icon: Icons.timer_outlined,
                  ),
                  _DocumentDetailRow(
                    label: 'Người xử lý',
                    value: document.fullNameProcess,
                    icon: Icons.person_outline_rounded,
                  ),
                  _DocumentDetailRow(
                    label: 'Số trang',
                    value: '${document.numberPage} trang',
                    icon: Icons.description_outlined,
                  ),
                  if (document.description.trim().isNotEmpty)
                    _DocumentDetailRow(
                      label: 'Ghi chú',
                      value: document.description.trim(),
                      icon: Icons.notes_outlined,
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

class _DocumentDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DocumentDetailRow({
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

TextStyle _documentFilterTitleStyle() {
  return AppTextStyles.caption.copyWith(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w900,
  );
}

String _documentMonthLabel(DateTime value) {
  return 'Tháng ${value.month.toString().padLeft(2, '0')}/${value.year}';
}

String _formatDocumentDate(DateTime? value) {
  if (value == null) return 'Chưa cập nhật';
  return '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/${value.year}';
}

String _fallbackText(String value) {
  return value.trim().isEmpty ? 'Chưa cập nhật' : value.trim();
}
