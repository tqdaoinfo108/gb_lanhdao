part of '../home_screen.dart';

class _AgenciesScreen extends StatelessWidget {
  final HomeController controller;

  const _AgenciesScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.agencyBundle.value;
      final page = bundle.agencyPage;
      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Địa bàn',
            title: 'Cơ quan / Sở ban ngành',
            actionLabel: 'Làm mới',
            onAction: controller.fetchAgencies,
          ),
          if (controller.isAgencyLoading.value) const LinearProgressIndicator(),
          if (controller.agencyError.value != null)
            _InlineError(
              message: controller.agencyError.value!,
              onRetry: controller.fetchAgencies,
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
                label: 'Ngưng hoạt động',
                tone: SmartTone.danger,
              ),
              SmartStatData(value: '1/1', label: 'Trang'),
            ],
          ),
          SmartCard(
            padding: const EdgeInsets.all(9),
            child: Column(
              children: [
                TextField(
                  controller: controller.agencySearchController,
                  onSubmitted: controller.searchAgencies,
                  decoration: const InputDecoration(
                    hintText: 'Tìm kiếm sở ban ngành...',
                    prefixIcon: Icon(Icons.search_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    _AgencyFilterChip(
                      label: 'Tất cả',
                      selected: controller.agencyStatusFilter.value == -100,
                      onTap: () => controller.setAgencyStatusFilter(-100),
                    ),
                    const SizedBox(width: 8),
                    _AgencyFilterChip(
                      label: 'Hoạt động',
                      selected: controller.agencyStatusFilter.value == 1,
                      onTap: () => controller.setAgencyStatusFilter(1),
                    ),
                    const SizedBox(width: 8),
                    _AgencyFilterChip(
                      label: 'Ngưng',
                      selected: controller.agencyStatusFilter.value == 0,
                      onTap: () => controller.setAgencyStatusFilter(0),
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
                  padding: const EdgeInsets.fromLTRB(14, 13, 14, 11),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Danh sách sở ban ngành',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Text(
                        '${page.totals} sở ban ngành',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (page.agencies.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: _EmptyState(
                      title: 'Chưa có sở ban ngành',
                      note: 'Thử đổi bộ lọc hoặc từ khóa tìm kiếm.',
                    ),
                  )
                else
                  ...List.generate(page.agencies.length, (index) {
                    return _AgencyRow(
                      agency: page.agencies[index],
                      showDivider: index < page.agencies.length - 1,
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

class _AgencyFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AgencyFilterChip({
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
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _AgencyRow extends StatelessWidget {
  final AgencyItem agency;
  final bool showDivider;

  const _AgencyRow({required this.agency, required this.showDivider});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: SmartColors.border))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: SmartColors.accentSoft,
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(
              Icons.account_balance_rounded,
              size: 18,
              color: SmartColors.accent,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _LabelNote(
              label: agency.agencyName,
              note: agency.description.isNotEmpty
                  ? agency.description
                  : 'Chưa có mô tả',
              large: true,
            ),
          ),
          const SizedBox(width: 10),
          SmartPill(
            label: agency.displayStatus,
            tone: agency.isActive ? SmartTone.success : SmartTone.danger,
          ),
          const SizedBox(width: 6),
          const Icon(
            Icons.edit_outlined,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
