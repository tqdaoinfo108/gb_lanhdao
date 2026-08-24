part of '../home_screen.dart';

class _ResidenceScreen extends StatelessWidget {
  final HomeController controller;

  const _ResidenceScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.residenceBundle.value;
      final households = bundle.households.households;

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Quản lý hộ khẩu và nhân khẩu',
            title: 'Hộ dân cư',
            badge: '${households.length} hộ',
            actionLabel: 'Làm mới',
            onAction: controller.fetchResidence,
          ),
          if (controller.isResidenceLoading.value)
            const LinearProgressIndicator(),
          if (controller.residenceError.value != null)
            _InlineError(
              message: controller.residenceError.value!,
              onRetry: controller.fetchResidence,
            ),
          _ResidenceStats(bundle: bundle, visibleCount: households.length),
          _ResidenceSearchAndFilters(controller: controller, bundle: bundle),
          _ResidenceVillageStrip(controller: controller, bundle: bundle),
          _ResidenceList(
            households: households,
            total: bundle.households.totals,
            onItemTap: (item) => _showHouseholdDetail(context, item),
          ),
        ],
      );
    });
  }
}

class _ResidenceStats extends StatelessWidget {
  final ResidenceBundle bundle;
  final int visibleCount;

  const _ResidenceStats({required this.bundle, required this.visibleCount});

  @override
  Widget build(BuildContext context) {
    return SmartStatGrid(
      compact: true,
      stats: [
        SmartStatData(
          value: bundle.totalHouseholds.toString(),
          label: 'Tổng hộ',
          tone: SmartTone.accent,
        ),
        SmartStatData(
          value: bundle.totalMembers.toString(),
          label: 'Nhân khẩu',
        ),
        SmartStatData(
          value: bundle.totalVillages.toString(),
          label: 'Thôn',
          tone: SmartTone.success,
        ),
        SmartStatData(
          value: visibleCount.toString(),
          label: 'Đang xem',
          tone: SmartTone.warning,
        ),
      ],
    );
  }
}

class _ResidenceSearchAndFilters extends StatelessWidget {
  final HomeController controller;
  final ResidenceBundle bundle;

  const _ResidenceSearchAndFilters({
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
                  controller: controller.residenceSearchController,
                  onSubmitted: controller.searchResidence,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Tìm hộ gia đình, số điện thoại, địa chỉ...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: controller.residenceQuery.value.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Xóa tìm kiếm',
                            onPressed: () {
                              controller.residenceQuery.value = '';
                              controller.residenceSearchController.clear();
                              controller.fetchResidence();
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
              _ResidenceFilterButton(
                active: _activeFilterCount(controller),
                onTap: () => _showResidenceFilterSheet(
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
              _ResidenceSegment(
                label: 'Tất cả',
                selected: controller.residenceStatusFilter.value == -100,
                onTap: () => controller.setResidenceStatusFilter(-100),
              ),
              const SizedBox(width: 8),
              _ResidenceSegment(
                label: 'Hoạt động',
                selected: controller.residenceStatusFilter.value == 1,
                onTap: () => controller.setResidenceStatusFilter(1),
              ),
              const SizedBox(width: 8),
              _ResidenceSegment(
                label: 'Ngưng',
                selected: controller.residenceStatusFilter.value == 0,
                onTap: () => controller.setResidenceStatusFilter(0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _activeFilterCount(HomeController controller) {
    var count = 0;
    if (controller.residenceVillageFilter.value != 0) count++;
    if (controller.residenceTypeFilter.value != 0) count++;
    if (controller.residenceStatusFilter.value != -100) count++;
    if (controller.residenceQuery.value.trim().isNotEmpty) count++;
    return count;
  }
}

class _ResidenceVillageStrip extends StatelessWidget {
  final HomeController controller;
  final ResidenceBundle bundle;

  const _ResidenceVillageStrip({
    required this.controller,
    required this.bundle,
  });

  @override
  Widget build(BuildContext context) {
    if (bundle.villages.villages.isEmpty) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: bundle.villages.villages.length + 1,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            return _ResidenceVillageCard(
              title: 'Tất cả thôn',
              subtitle: '${bundle.totalHouseholds} hộ',
              selected: controller.residenceVillageFilter.value == 0,
              onTap: () => controller.setResidenceVillageFilter(0),
            );
          }
          final village = bundle.villages.villages[index - 1];
          return _ResidenceVillageCard(
            title: village.villageName,
            subtitle:
                '${village.totalHouseHold} hộ, ${village.totalMember} người',
            selected:
                controller.residenceVillageFilter.value == village.villageId,
            onTap: () =>
                controller.setResidenceVillageFilter(village.villageId),
          );
        },
      ),
    );
  }
}

class _ResidenceList extends StatelessWidget {
  final List<HouseholdItem> households;
  final int total;
  final ValueChanged<HouseholdItem> onItemTap;

  const _ResidenceList({
    required this.households,
    required this.total,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
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
                    'Danh sách hộ gia đình',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Text(
                  '$total hộ',
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (households.isEmpty)
            const Padding(
              padding: EdgeInsets.all(18),
              child: _EmptyState(
                title: 'Không có hộ phù hợp',
                note: 'Thử đổi từ khóa, thôn hoặc phân loại hộ.',
              ),
            )
          else
            ...households.asMap().entries.map((entry) {
              return Column(
                children: [
                  _HouseholdCard(
                    household: entry.value,
                    onTap: () => onItemTap(entry.value),
                  ),
                  if (entry.key < households.length - 1)
                    const Divider(height: 1, indent: 70),
                ],
              );
            }),
        ],
      ),
    );
  }
}

class _HouseholdCard extends StatelessWidget {
  final HouseholdItem household;
  final VoidCallback onTap;

  const _HouseholdCard({required this.household, required this.onTap});

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
                color: SmartColors.accentSoft,
                borderRadius: BorderRadius.circular(15),
              ),
              alignment: Alignment.center,
              child: Text(
                _householdInitials(household.headHouseHold),
                style: AppTextStyles.caption.copyWith(
                  color: SmartColors.accent,
                  fontWeight: FontWeight.w900,
                ),
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
                          household.headHouseHold.isEmpty
                              ? 'Hộ gia đình'
                              : household.headHouseHold,
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
                        label: household.displayStatus,
                        tone: household.statusTone,
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Wrap(
                    spacing: 8,
                    runSpacing: 7,
                    children: [
                      _ResidenceMeta(
                        icon: Icons.location_on_outlined,
                        text: household.villageName.isEmpty
                            ? 'Chưa rõ thôn'
                            : household.villageName,
                      ),
                      _ResidenceMeta(
                        icon: Icons.groups_2_outlined,
                        text: '${household.numberPerson} nhân khẩu',
                      ),
                      if (household.phone.trim().isNotEmpty)
                        _ResidenceMeta(
                          icon: Icons.phone_outlined,
                          text: household.phone.trim(),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    household.address.trim().isEmpty
                        ? 'Chưa cập nhật địa chỉ'
                        : household.address.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: [
                      SmartPill(
                        label: household.displayType,
                        tone: household.typeTone,
                      ),
                      if (household.hasChildren)
                        const SmartPill(
                          label: 'Trẻ em',
                          tone: SmartTone.accent,
                        ),
                      if (household.hasElderly)
                        const SmartPill(
                          label: 'Người cao tuổi',
                          tone: SmartTone.warning,
                        ),
                    ],
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

class _ResidenceFilterButton extends StatelessWidget {
  final int active;
  final VoidCallback onTap;

  const _ResidenceFilterButton({required this.active, required this.onTap});

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

class _ResidenceSegment extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ResidenceSegment({
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

class _ResidenceVillageCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _ResidenceVillageCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 148,
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: selected ? SmartColors.accent : SmartColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? SmartColors.accent : SmartColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: selected
                    ? Colors.white.withValues(alpha: 0.82)
                    : AppColors.textSecondary,
                fontSize: 10.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResidenceMeta extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ResidenceMeta({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(fontSize: 11),
        ),
      ],
    );
  }
}

void _showResidenceFilterSheet(
  BuildContext context, {
  required HomeController controller,
  required ResidenceBundle bundle,
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
                          'Bộ lọc hộ gia đình',
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
                  Text('Phân loại', style: _filterTitleStyle()),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _ResidenceSheetChip(
                        label: 'Tất cả',
                        selected: controller.residenceTypeFilter.value == 0,
                        onTap: () {
                          controller.setResidenceTypeFilter(0);
                          Navigator.of(context).pop();
                        },
                      ),
                      ...bundle.types.types.map((type) {
                        return _ResidenceSheetChip(
                          label: type.typeHouseHoldName,
                          selected:
                              controller.residenceTypeFilter.value ==
                              type.typeHouseHoldId,
                          onTap: () {
                            controller.setResidenceTypeFilter(
                              type.typeHouseHoldId,
                            );
                            Navigator.of(context).pop();
                          },
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Thôn', style: _filterTitleStyle()),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _ResidenceSheetChip(
                        label: 'Tất cả thôn',
                        selected: controller.residenceVillageFilter.value == 0,
                        onTap: () {
                          controller.setResidenceVillageFilter(0);
                          Navigator.of(context).pop();
                        },
                      ),
                      ...bundle.villages.villages.map((village) {
                        return _ResidenceSheetChip(
                          label: village.villageName,
                          selected:
                              controller.residenceVillageFilter.value ==
                              village.villageId,
                          onTap: () {
                            controller.setResidenceVillageFilter(
                              village.villageId,
                            );
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
                      controller.clearResidenceFilters();
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

class _ResidenceSheetChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ResidenceSheetChip({
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

void _showHouseholdDetail(BuildContext context, HouseholdItem household) {
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
                          household.headHouseHold.isEmpty
                              ? 'Hộ gia đình'
                              : household.headHouseHold,
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
                        label: household.displayStatus,
                        tone: household.statusTone,
                      ),
                      SmartPill(
                        label: household.displayType,
                        tone: household.typeTone,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _ResidenceDetailRow(
                    label: 'Người phụ trách',
                    value: household.userNameLeader,
                    icon: Icons.person_outline_rounded,
                  ),
                  _ResidenceDetailRow(
                    label: 'Thôn',
                    value: household.villageName,
                    icon: Icons.location_city_outlined,
                  ),
                  _ResidenceDetailRow(
                    label: 'Địa chỉ',
                    value: household.address,
                    icon: Icons.place_outlined,
                  ),
                  _ResidenceDetailRow(
                    label: 'Điện thoại',
                    value: household.phone.isEmpty
                        ? 'Chưa cập nhật'
                        : household.phone,
                    icon: Icons.phone_outlined,
                  ),
                  _ResidenceDetailRow(
                    label: 'Nhân khẩu',
                    value: '${household.numberPerson} người',
                    icon: Icons.groups_2_outlined,
                  ),
                  _ResidenceDetailRow(
                    label: 'Ngày đăng ký',
                    value: _formatResidenceDate(household.dateRegister),
                    icon: Icons.event_available_outlined,
                  ),
                  if (household.description.trim().isNotEmpty)
                    _ResidenceDetailRow(
                      label: 'Ghi chú',
                      value: household.description.trim(),
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

class _ResidenceDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ResidenceDetailRow({
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

TextStyle _filterTitleStyle() {
  return AppTextStyles.caption.copyWith(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w900,
  );
}

String _householdInitials(String value) {
  final words = value
      .trim()
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .toList();
  if (words.isEmpty) return 'H';
  if (words.length == 1) return words.first.characters.take(2).toString();
  return '${words.first.characters.first}${words.last.characters.first}'
      .toUpperCase();
}

String _formatResidenceDate(DateTime? value) {
  if (value == null) return 'Chưa cập nhật';
  return '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/${value.year}';
}
