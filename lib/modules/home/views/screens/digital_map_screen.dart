part of '../home_screen.dart';

class _DigitalMapScreen extends StatelessWidget {
  final HomeController controller;

  const _DigitalMapScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.digitalMapBundle.value;
      final offices = _visibleMapOffices(bundle, controller);
      final ward = bundle.wards.wards.isNotEmpty
          ? bundle.wards.wards.first
          : null;
      final boundary = ward?.boundary ?? const <MapCoordinate>[];

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: ward?.wardName ?? 'Bản đồ số trực quan',
            title: 'GIS Maps',
            badge: '${offices.length} địa điểm',
            actionLabel: 'Làm mới',
            onAction: controller.fetchDigitalMap,
          ),
          if (controller.isDigitalMapLoading.value)
            const LinearProgressIndicator(),
          if (controller.digitalMapError.value != null)
            _InlineError(
              message: controller.digitalMapError.value!,
              onRetry: controller.fetchDigitalMap,
            ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height - 176,
            child: _DigitalMapFullView(
              controller: controller,
              bundle: bundle,
              offices: offices,
              boundary: boundary,
            ),
          ),
        ],
      );
    });
  }

  List<OfficeItem> _visibleMapOffices(
    DigitalMapBundle bundle,
    HomeController controller,
  ) {
    final query = controller.mapQuery.value.trim().toLowerCase();
    return bundle.offices.offices.where((office) {
      final location = office.location;
      if (location?.latitude == null || location?.longitude == null) {
        return false;
      }
      if (controller.digitalMapVillageFilter.value != 0 &&
          office.villageId != controller.digitalMapVillageFilter.value) {
        return false;
      }
      if (query.isEmpty) return true;
      final haystack = [
        office.officeName,
        office.officeAddress,
        office.officeDescription,
        office.villageName,
        office.typeOfficeName,
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }
}

class _DigitalMapFullView extends StatelessWidget {
  final HomeController controller;
  final DigitalMapBundle bundle;
  final List<OfficeItem> offices;
  final List<MapCoordinate> boundary;

  const _DigitalMapFullView({
    required this.controller,
    required this.bundle,
    required this.offices,
    required this.boundary,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: _DigitalMapCanvas(
            offices: offices,
            boundary: boundary,
            showBoundary: controller.digitalMapBoundaryVisible.value,
            showOffices: controller.digitalMapOfficesVisible.value,
          ),
        ),
        Positioned(
          left: 12,
          right: 12,
          top: 12,
          child: _DigitalMapFloatingBar(
            controller: controller,
            bundle: bundle,
            offices: offices,
          ),
        ),
        Positioned(
          left: 12,
          bottom: 12,
          child: _DigitalMapMapSummary(bundle: bundle, offices: offices),
        ),
      ],
    );
  }
}

class _DigitalMapFloatingBar extends StatelessWidget {
  final HomeController controller;
  final DigitalMapBundle bundle;
  final List<OfficeItem> offices;

  const _DigitalMapFloatingBar({
    required this.controller,
    required this.bundle,
    required this.offices,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: SmartColors.border),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF263248).withValues(alpha: 0.12),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _MapPopupButton(
                label: 'Bộ lọc',
                icon: Icons.tune_rounded,
                onTap: () => _showMapPopup(
                  context,
                  title: 'Bộ lọc bản đồ',
                  child: _DigitalMapFilters(
                    controller: controller,
                    bundle: bundle,
                  ),
                ),
              ),
              _MapPopupButton(
                label: 'Lớp bản đồ',
                icon: Icons.layers_rounded,
                onTap: () => _showMapPopup(
                  context,
                  title: 'Lớp bản đồ',
                  child: _MapLayerPanel(controller: controller),
                ),
              ),
              _MapPopupButton(
                label: 'Thống kê thôn',
                icon: Icons.bar_chart_rounded,
                onTap: () => _showMapPopup(
                  context,
                  title: 'Thống kê thôn',
                  heightFactor: 0.68,
                  child: _VillageStatsPanel(
                    controller: controller,
                    villages: bundle.villages.villages,
                    offices: bundle.offices.offices,
                  ),
                ),
              ),
              _MapPopupButton(
                label: 'Địa điểm (${offices.length})',
                icon: Icons.location_on_rounded,
                onTap: () => _showMapPopup(
                  context,
                  title: 'Danh sách địa điểm',
                  heightFactor: 0.72,
                  child: _MapOfficeListPanel(offices: offices),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMapPopup(
    BuildContext context, {
    required String title,
    required Widget child,
    double heightFactor = 0.48,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: heightFactor,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: SmartColors.background,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: SmartColors.border),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 10, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
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
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: child,
                      ),
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
}

class _DigitalMapMapSummary extends StatelessWidget {
  final DigitalMapBundle bundle;
  final List<OfficeItem> offices;

  const _DigitalMapMapSummary({required this.bundle, required this.offices});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SmartColors.border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF263248).withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _MapSummaryMetric(
              value: offices.length.toString(),
              label: 'địa điểm',
            ),
            const SizedBox(width: 14),
            _MapSummaryMetric(
              value: bundle.villages.villages.length.toString(),
              label: 'thôn',
            ),
            const SizedBox(width: 14),
            _MapSummaryMetric(
              value: bundle.wards.wards.isEmpty
                  ? '0'
                  : bundle.wards.wards.first.boundary.length.toString(),
              label: 'điểm ranh',
            ),
          ],
        ),
      ),
    );
  }
}

class _MapSummaryMetric extends StatelessWidget {
  final String value;
  final String label;

  const _MapSummaryMetric({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: SmartColors.accent,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
        const SizedBox(height: 3),
        Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
      ],
    );
  }
}

class _MapPopupButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _MapPopupButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        decoration: BoxDecoration(
          color: SmartColors.soft,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: SmartColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 17, color: SmartColors.accent),
            const SizedBox(width: 7),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DigitalMapFilters extends StatelessWidget {
  final HomeController controller;
  final DigitalMapBundle bundle;

  const _DigitalMapFilters({required this.controller, required this.bundle});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          TextField(
            controller: controller.mapSearchController,
            onSubmitted: controller.searchDigitalMap,
            decoration: const InputDecoration(
              hintText: 'Tìm tỉnh thành, địa điểm...',
              prefixIcon: Icon(Icons.search_rounded, size: 20),
              isDense: true,
            ),
          ),
          const SizedBox(height: 10),
          _MapChipScroller(
            children: [
              _MapFilterChip(
                label: 'Tất cả lớp',
                selected: controller.digitalMapTypeFilter.value == 0,
                icon: Icons.layers_rounded,
                onTap: () => controller.setDigitalMapTypeFilter(0),
              ),
              ...bundle.officeTypes.types.map(
                (type) => _MapFilterChip(
                  label: type.typeOfficeName,
                  selected:
                      controller.digitalMapTypeFilter.value ==
                      type.typeOfficeId,
                  icon: _officeTypeIcon(type.typeOfficeName),
                  onTap: () =>
                      controller.setDigitalMapTypeFilter(type.typeOfficeId),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapLayerPanel extends StatelessWidget {
  final HomeController controller;

  const _MapLayerPanel({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lớp bản đồ',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          _MapLayerToggle(
            label: 'Địa giới hành chính',
            icon: Icons.polyline_rounded,
            selected: controller.digitalMapBoundaryVisible.value,
            onTap: controller.toggleDigitalMapBoundary,
          ),
          const SizedBox(height: 8),
          _MapLayerToggle(
            label: 'Danh sách địa điểm',
            icon: Icons.location_on_rounded,
            selected: controller.digitalMapOfficesVisible.value,
            onTap: controller.toggleDigitalMapOffices,
          ),
        ],
      ),
    );
  }
}

class _VillageStatsPanel extends StatelessWidget {
  final HomeController controller;
  final List<VillageItem> villages;
  final List<OfficeItem> offices;

  const _VillageStatsPanel({
    required this.controller,
    required this.villages,
    required this.offices,
  });

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Thống kê thôn',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                _MapMiniButton(
                  label: 'Tất cả',
                  selected: controller.digitalMapVillageFilter.value == 0,
                  onTap: () => controller.setDigitalMapVillageFilter(0),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: villages.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: _EmptyState(
                      title: 'Chưa có dữ liệu thôn',
                      note: 'Dữ liệu sẽ hiển thị sau khi API phản hồi.',
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: villages.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final village = villages[index];
                      final officeCount = offices
                          .where(
                            (office) => office.villageId == village.villageId,
                          )
                          .length;
                      final selected =
                          controller.digitalMapVillageFilter.value ==
                          village.villageId;
                      return InkWell(
                        onTap: () => controller.setDigitalMapVillageFilter(
                          selected ? 0 : village.villageId,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 9,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      village.villageName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.caption.copyWith(
                                        color: selected
                                            ? SmartColors.accent
                                            : AppColors.textPrimary,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${village.totalHouseHold} hộ, ${village.totalMember} nhân khẩu',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.caption.copyWith(
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                officeCount.toString(),
                                style: AppTextStyles.caption.copyWith(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(width: 7),
                              Icon(
                                selected
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_outlined,
                                size: 16,
                                color: selected
                                    ? SmartColors.accent
                                    : AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _MapOfficeListPanel extends StatelessWidget {
  final List<OfficeItem> offices;

  const _MapOfficeListPanel({required this.offices});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Danh sách địa điểm (${offices.length})',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: offices.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: _EmptyState(
                      title: 'Không có địa điểm',
                      note: 'Thử đổi bộ lọc hoặc từ khóa tìm kiếm.',
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: offices.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        child: _MapOfficeListItem(office: offices[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _DigitalMapCanvas extends StatelessWidget {
  final List<OfficeItem> offices;
  final List<MapCoordinate> boundary;
  final bool showBoundary;
  final bool showOffices;

  const _DigitalMapCanvas({
    required this.offices,
    required this.boundary,
    required this.showBoundary,
    required this.showOffices,
  });

  @override
  Widget build(BuildContext context) {
    final center = _mapCenter(offices, boundary);
    final boundaryPoints = boundary
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: SmartColors.border),
          borderRadius: BorderRadius.circular(18),
        ),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: center,
            initialZoom: 12.5,
            minZoom: 9,
            maxZoom: 18,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'vn.gbsoft.lanhdao',
            ),
            if (showBoundary && boundaryPoints.length >= 3)
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: boundaryPoints,
                    color: const Color(0xFF2F80ED).withValues(alpha: 0.12),
                    borderColor: const Color(0xFF2F80ED),
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
            if (showOffices)
              MarkerLayer(
                markers: offices.map((office) {
                  final location = office.location!;
                  return Marker(
                    point: LatLng(location.latitude!, location.longitude!),
                    width: 42,
                    height: 42,
                    child: _MapMarkerBubble(office: office),
                  );
                }).toList(),
              ),
            RichAttributionWidget(
              attributions: [TextSourceAttribution('OpenStreetMap')],
            ),
          ],
        ),
      ),
    );
  }

  LatLng _mapCenter(List<OfficeItem> offices, List<MapCoordinate> boundary) {
    if (boundary.isNotEmpty) {
      final lat =
          boundary.map((point) => point.latitude).reduce((a, b) => a + b) /
          boundary.length;
      final lng =
          boundary.map((point) => point.longitude).reduce((a, b) => a + b) /
          boundary.length;
      return LatLng(lat, lng);
    }
    if (offices.isNotEmpty) {
      final lat =
          offices
              .map((office) => office.location!.latitude!)
              .reduce((a, b) => a + b) /
          offices.length;
      final lng =
          offices
              .map((office) => office.location!.longitude!)
              .reduce((a, b) => a + b) /
          offices.length;
      return LatLng(lat, lng);
    }
    return const LatLng(13.2466965, 109.0938352);
  }
}

class _MapOfficeListItem extends StatelessWidget {
  final OfficeItem office;

  const _MapOfficeListItem({required this.office});

  @override
  Widget build(BuildContext context) {
    final tone = _officeTone(office.typeOfficeName);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SmartIconBadge(
          label: _officeShortLabel(office.typeOfficeName),
          tone: tone,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                office.officeName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                [
                  office.officeAddress,
                  if (office.villageName.isNotEmpty) office.villageName,
                ].where((item) => item.isNotEmpty).join(' · '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(fontSize: 10.5),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        SmartPill(label: office.typeOfficeName, tone: tone),
      ],
    );
  }
}

class _MapMarkerBubble extends StatelessWidget {
  final OfficeItem office;

  const _MapMarkerBubble({required this.office});

  @override
  Widget build(BuildContext context) {
    final color = _officeMarkerColor(office.typeOfficeName);
    return Tooltip(
      message: office.officeName,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.2), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.22),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(
          _officeTypeIcon(office.typeOfficeName),
          color: color,
          size: 20,
        ),
      ),
    );
  }
}

class _MapChipScroller extends StatelessWidget {
  final List<Widget> children;

  const _MapChipScroller({required this.children});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) => children[index],
      ),
    );
  }
}

class _MapFilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _MapFilterChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? SmartColors.accentSoft : SmartColors.soft,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? SmartColors.accent.withValues(alpha: 0.24)
                : SmartColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: selected ? SmartColors.accent : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: selected ? SmartColors.accent : AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapLayerToggle extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _MapLayerToggle({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? SmartColors.accentSoft : SmartColors.soft,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: selected ? SmartColors.accent : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: selected ? SmartColors.accent : AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              size: 17,
              color: selected ? SmartColors.accent : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _MapMiniButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _MapMiniButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? SmartColors.accent : SmartColors.soft,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

IconData _officeTypeIcon(String value) {
  final normalized = value.toLowerCase();
  if (normalized.contains('trường')) return Icons.school_rounded;
  if (normalized.contains('bệnh')) return Icons.local_hospital_rounded;
  if (normalized.contains('cơ quan')) return Icons.account_balance_rounded;
  if (normalized.contains('du lịch') || normalized.contains('di tích')) {
    return Icons.museum_rounded;
  }
  return Icons.location_city_rounded;
}

SmartTone _officeTone(String value) {
  final normalized = value.toLowerCase();
  if (normalized.contains('trường')) return SmartTone.success;
  if (normalized.contains('bệnh')) return SmartTone.danger;
  if (normalized.contains('du lịch') || normalized.contains('di tích')) {
    return SmartTone.warning;
  }
  return SmartTone.accent;
}

Color _officeMarkerColor(String value) {
  switch (_officeTone(value)) {
    case SmartTone.success:
      return SmartColors.success;
    case SmartTone.danger:
      return SmartColors.danger;
    case SmartTone.warning:
      return SmartColors.warning;
    case SmartTone.accent:
      return SmartColors.accent;
    case SmartTone.neutral:
      return AppColors.textSecondary;
  }
}

String _officeShortLabel(String value) {
  final normalized = value.toLowerCase();
  if (normalized.contains('trường')) return 'TH';
  if (normalized.contains('cơ quan')) return 'CQ';
  if (normalized.contains('bệnh')) return 'BV';
  final trimmed = value.trim();
  if (trimmed.isEmpty) return 'ĐĐ';
  return trimmed.characters.take(2).toString().toUpperCase();
}
