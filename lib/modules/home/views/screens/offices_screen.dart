part of '../home_screen.dart';

class _OfficesScreen extends StatelessWidget {
  final HomeController controller;

  const _OfficesScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.officeBundle.value;
      final page = bundle.officePage;

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Địa bàn',
            title: 'Địa điểm số',
            badge: '${page.offices.length} địa điểm',
            actionLabel: 'Làm mới',
            onAction: controller.fetchOffices,
          ),
          if (controller.isOfficeLoading.value) const LinearProgressIndicator(),
          if (controller.officeError.value != null)
            _InlineError(
              message: controller.officeError.value!,
              onRetry: controller.fetchOffices,
            ),
          SmartStatGrid(
            stats: [
              SmartStatData(value: page.totalAll.toString(), label: 'Tổng số'),
              SmartStatData(
                value: page.totalActive.toString(),
                label: 'Hoạt động',
                tone: SmartTone.success,
              ),
              SmartStatData(
                value: page.inactiveCount.toString(),
                label: 'Ngưng',
                tone: SmartTone.danger,
              ),
              SmartStatData(
                value: page.offices
                    .where((item) => item.location?.latitude != null)
                    .length
                    .toString(),
                label: 'Có tọa độ',
                tone: SmartTone.accent,
              ),
            ],
          ),
          SmartCard(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                TextField(
                  controller: controller.officeSearchController,
                  onSubmitted: controller.searchOffices,
                  decoration: const InputDecoration(
                    hintText: 'Tìm tên địa điểm, địa chỉ, thôn...',
                    prefixIcon: Icon(Icons.search_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    _OfficeFilterChip(
                      label: 'Tất cả',
                      selected: controller.officeStatusFilter.value == -100,
                      onTap: () => controller.setOfficeStatusFilter(-100),
                    ),
                    const SizedBox(width: 8),
                    _OfficeFilterChip(
                      label: 'Hoạt động',
                      selected: controller.officeStatusFilter.value == 1,
                      onTap: () => controller.setOfficeStatusFilter(1),
                    ),
                    const SizedBox(width: 8),
                    _OfficeFilterChip(
                      label: 'Ngưng',
                      selected: controller.officeStatusFilter.value == 0,
                      onTap: () => controller.setOfficeStatusFilter(0),
                    ),
                  ],
                ),
              ],
            ),
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
                          'Danh sách địa điểm',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Text(
                        '${page.totals} địa điểm',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (page.offices.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(18),
                    child: _EmptyState(
                      title: 'Không có địa điểm phù hợp',
                      note: 'Thử đổi từ khóa hoặc bộ lọc trạng thái.',
                    ),
                  )
                else
                  ...page.offices.asMap().entries.map((entry) {
                    return Column(
                      children: [
                        _OfficeRow(
                          office: entry.value,
                          onTap: () => _showOfficeDetail(context, entry.value),
                        ),
                        if (entry.key < page.offices.length - 1)
                          const Divider(height: 1, indent: 70),
                      ],
                    );
                  }),
              ],
            ),
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

class _OfficeFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _OfficeFilterChip({
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

class _OfficeRow extends StatelessWidget {
  final OfficeItem office;
  final VoidCallback onTap;

  const _OfficeRow({required this.office, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tone = _officeTone(office.typeOfficeName);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SmartIconBadge(
              label: _officeShortLabel(office.typeOfficeName),
              tone: tone,
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
                          office.officeName,
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
                        label: office.displayStatus,
                        tone: office.isActive
                            ? SmartTone.success
                            : SmartTone.danger,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 7,
                    children: [
                      SmartPill(label: office.typeOfficeName, tone: tone),
                      if (office.villageName.trim().isNotEmpty)
                        SmartPill(
                          label: office.villageName.trim(),
                          tone: SmartTone.neutral,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    office.officeAddress.trim().isEmpty
                        ? 'Chưa cập nhật địa chỉ'
                        : office.officeAddress.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
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

void _showOfficeDetail(BuildContext context, OfficeItem office) {
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
                          office.officeName,
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
                        label: office.displayStatus,
                        tone: office.isActive
                            ? SmartTone.success
                            : SmartTone.danger,
                      ),
                      SmartPill(
                        label: office.typeOfficeName,
                        tone: _officeTone(office.typeOfficeName),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _OfficeDetailRow(
                    label: 'Địa chỉ',
                    value: office.officeAddress,
                    icon: Icons.place_outlined,
                  ),
                  _OfficeDetailRow(
                    label: 'Thôn',
                    value: office.villageName,
                    icon: Icons.location_city_outlined,
                  ),
                  _OfficeDetailRow(
                    label: 'Tỉnh / Thành',
                    value: office.cityName,
                    icon: Icons.apartment_outlined,
                  ),
                  _OfficeDetailRow(
                    label: 'Tọa độ',
                    value: _officeCoordinateLabel(office.location),
                    icon: Icons.my_location_outlined,
                  ),
                  if (office.officeDescription.trim().isNotEmpty)
                    _OfficeDetailRow(
                      label: 'Mô tả',
                      value: office.officeDescription.trim(),
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

class _OfficeDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _OfficeDetailRow({
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

String _officeCoordinateLabel(OfficeLocation? location) {
  if (location?.latitude == null || location?.longitude == null) {
    return 'Chưa cập nhật';
  }
  return '${location!.latitude!.toStringAsFixed(6)}, '
      '${location.longitude!.toStringAsFixed(6)}';
}
