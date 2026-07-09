part of '../home_screen.dart';

class _WorkCalendarScreen extends StatelessWidget {
  final HomeController controller;

  const _WorkCalendarScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bundle = controller.workCalendar.value;
      final bookings = controller.visibleBookings();
      final grouped = _groupBookingsByDate(bookings);

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Ứng dụng',
            onBack: () => controller.showView(AdminSmartView.apps),
            eyebrow: 'Nghiệp vụ',
            title: 'Lịch công tác chung',
            badge: '${bookings.length} booking',
            actionLabel: 'Làm mới',
            onAction: controller.fetchWorkCalendar,
          ),
          if (controller.isWorkCalendarLoading.value)
            const LinearProgressIndicator(),
          if (controller.workCalendarError.value != null)
            _InlineError(
              message: controller.workCalendarError.value!,
              onRetry: controller.fetchWorkCalendar,
            ),
          _WorkCalendarToolbar(controller: controller, bundle: bundle),
          if (bookings.isEmpty)
            const _EmptyState(
              title: 'Chưa có lịch công tác',
              note: 'Thử đổi ngày, tuần, tháng hoặc bộ lọc.',
            )
          else
            ...grouped.entries.map(
              (entry) => _WorkCalendarDayCard(
                date: entry.key,
                bookings: entry.value,
                bundle: bundle,
                onOpen: controller.openBookingDetail,
              ),
            ),
        ],
      );
    });
  }
}

class _WorkCalendarToolbar extends StatelessWidget {
  final HomeController controller;
  final WorkCalendarBundle bundle;

  const _WorkCalendarToolbar({required this.controller, required this.bundle});

  @override
  Widget build(BuildContext context) {
    final range = controller.workCalendarRange;
    return SmartCard(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => controller.moveWorkCalendar(-1),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Text(
                  _workCalendarRangeLabel(
                    controller.workCalendarViewMode.value,
                    range,
                  ),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => controller.moveWorkCalendar(1),
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _CalendarChip(
                label: 'Ngày',
                selected:
                    controller.workCalendarViewMode.value ==
                    WorkCalendarViewMode.day,
                onTap: () => controller.setWorkCalendarViewMode(
                  WorkCalendarViewMode.day,
                ),
              ),
              _CalendarChip(
                label: 'Tuần',
                selected:
                    controller.workCalendarViewMode.value ==
                    WorkCalendarViewMode.week,
                onTap: () => controller.setWorkCalendarViewMode(
                  WorkCalendarViewMode.week,
                ),
              ),
              _CalendarChip(
                label: 'Tháng',
                selected:
                    controller.workCalendarViewMode.value ==
                    WorkCalendarViewMode.month,
                onTap: () => controller.setWorkCalendarViewMode(
                  WorkCalendarViewMode.month,
                ),
              ),
              _CalendarChip(
                label: 'Hôm nay',
                icon: Icons.today_rounded,
                onTap: controller.goToToday,
              ),
              _CalendarChip(
                label: controller.workCalendarActiveFilterCount == 0
                    ? 'Bộ lọc'
                    : 'Bộ lọc (${controller.workCalendarActiveFilterCount})',
                icon: Icons.tune_rounded,
                onTap: () =>
                    _showCalendarFilterPopup(context, controller, bundle),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCalendarFilterPopup(
    BuildContext context,
    HomeController controller,
    WorkCalendarBundle bundle,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.72,
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
                            'Bộ lọc lịch công tác',
                            style: AppTextStyles.h4.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: controller.clearWorkCalendarFilters,
                          child: const Text('Xóa lọc'),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(14),
                      child: Obx(
                        () => _CalendarFilterContent(
                          controller: controller,
                          bundle: bundle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarFilterContent extends StatelessWidget {
  final HomeController controller;
  final WorkCalendarBundle bundle;

  const _CalendarFilterContent({
    required this.controller,
    required this.bundle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CalendarFilterGroup(
          title: 'Loại booking',
          children: [
            _CalendarFilterChip(
              label: 'Tất cả',
              selected: controller.workCalendarTypeFilter.value == 0,
              onTap: () => controller.setWorkCalendarTypeFilter(0),
            ),
            ...bundle.types.map(
              (type) => _CalendarFilterChip(
                label: type.typeBookingName,
                selected:
                    controller.workCalendarTypeFilter.value ==
                    type.typeBookingId,
                onTap: () =>
                    controller.setWorkCalendarTypeFilter(type.typeBookingId),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _CalendarFilterGroup(
          title: 'Phòng họp',
          children: [
            _CalendarFilterChip(
              label: 'Tất cả',
              selected: controller.workCalendarRoomFilter.value == 0,
              onTap: () => controller.setWorkCalendarRoomFilter(0),
            ),
            ...bundle.rooms.map(
              (room) => _CalendarFilterChip(
                label: room.roomBookingName,
                selected:
                    controller.workCalendarRoomFilter.value ==
                    room.roomBookingId,
                onTap: () =>
                    controller.setWorkCalendarRoomFilter(room.roomBookingId),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _CalendarFilterGroup(
          title: 'Trạng thái',
          children: [
            _CalendarFilterChip(
              label: 'Tất cả',
              selected: controller.workCalendarStatusFilter.value == -100,
              onTap: () => controller.setWorkCalendarStatusFilter(-100),
            ),
            ...const [0, 1, 2, 3, 4, 5].map(
              (status) => _CalendarFilterChip(
                label: _bookingStatusLabelById(status),
                selected: controller.workCalendarStatusFilter.value == status,
                onTap: () => controller.setWorkCalendarStatusFilter(status),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CalendarFilterGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _CalendarFilterGroup({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: children),
        ],
      ),
    );
  }
}

class _CalendarFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CalendarFilterChip({
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
      backgroundColor: SmartColors.soft,
      selectedColor: SmartColors.accentSoft,
      labelStyle: AppTextStyles.caption.copyWith(
        color: selected ? SmartColors.accent : AppColors.textPrimary,
        fontWeight: FontWeight.w800,
      ),
      shape: StadiumBorder(
        side: BorderSide(
          color: selected
              ? SmartColors.accent.withValues(alpha: 0.28)
              : SmartColors.border,
        ),
      ),
    );
  }
}

class _CalendarChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _CalendarChip({
    required this.label,
    this.icon,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? SmartColors.accent : SmartColors.soft,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? SmartColors.accent : SmartColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? Colors.white : SmartColors.accent,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkCalendarDayCard extends StatelessWidget {
  final DateTime date;
  final List<BookingModel> bookings;
  final WorkCalendarBundle bundle;
  final ValueChanged<BookingModel> onOpen;

  const _WorkCalendarDayCard({
    required this.date,
    required this.bookings,
    required this.bundle,
    required this.onOpen,
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
                    _calendarDayTitle(date),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SmartPill(label: '${bookings.length} lịch'),
              ],
            ),
          ),
          const Divider(height: 1),
          ...bookings.map(
            (booking) => _WorkCalendarBookingTile(
              booking: booking,
              roomName: bundle.roomName(booking.roomBookingID),
              typeName: bundle.typeName(
                booking.typeBookingID,
                booking.typeBookingName,
              ),
              onTap: () => onOpen(booking),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkCalendarBookingTile extends StatelessWidget {
  final BookingModel booking;
  final String roomName;
  final String typeName;
  final VoidCallback onTap;

  const _WorkCalendarBookingTile({
    required this.booking,
    required this.roomName,
    required this.typeName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 58,
              child: Column(
                children: [
                  Text(
                    booking.formattedStartTime.isNotEmpty
                        ? booking.formattedStartTime
                        : '--:--',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: SmartColors.accent,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    '${booking.durationInMinutes}p',
                    style: AppTextStyles.caption.copyWith(fontSize: 10),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.bookingTitle.isNotEmpty
                        ? booking.bookingTitle
                        : 'Lịch công tác chưa đặt tên',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$roomName · $typeName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: [
                      SmartPill(
                        label: _bookingStatusLabel(booking),
                        tone: _bookingStatusTone(booking.statusID),
                      ),
                      SmartPill(
                        label: '${booking.lstUserJoin.length} người tham gia',
                        tone: SmartTone.neutral,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkCalendarDetailScreen extends StatelessWidget {
  final HomeController controller;

  const _WorkCalendarDetailScreen({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final booking = controller.selectedBooking.value;
      final bundle = controller.workCalendar.value;

      if (booking == null) {
        return _ScreenStack(
          children: [
            SmartScreenHeader(
              backLabel: 'Lịch công tác',
              onBack: () => controller.showView(AdminSmartView.workCalendar),
              title: 'Chi tiết booking',
            ),
            const _EmptyState(
              title: 'Chưa chọn booking',
              note: 'Quay lại danh sách để chọn lịch cần xem.',
            ),
          ],
        );
      }

      final roomName = bundle.roomName(booking.roomBookingID);
      final typeName = bundle.typeName(
        booking.typeBookingID,
        booking.typeBookingName,
      );

      return _ScreenStack(
        children: [
          SmartScreenHeader(
            backLabel: 'Lịch công tác',
            onBack: () => controller.showView(AdminSmartView.workCalendar),
            eyebrow: typeName,
            title: booking.bookingTitle.isNotEmpty
                ? booking.bookingTitle
                : 'Chi tiết booking',
            badge: _bookingStatusLabel(booking),
          ),
          SmartCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _BookingDetailLine(
                  icon: Icons.schedule_rounded,
                  label: 'Thời gian',
                  value:
                      '${_formatDateTimeLabel(booking.dateStart)} - ${_formatTimeOnly(booking.dateEnd)}',
                ),
                _BookingDetailLine(
                  icon: Icons.meeting_room_rounded,
                  label: 'Phòng họp',
                  value: roomName,
                ),
                _BookingDetailLine(
                  icon: Icons.category_rounded,
                  label: 'Loại booking',
                  value: typeName,
                ),
                _BookingDetailLine(
                  icon: Icons.groups_rounded,
                  label: 'Người tham gia',
                  value: '${booking.lstUserJoin.length} người',
                ),
                _BookingDetailLine(
                  icon: Icons.person_rounded,
                  label: 'Người tạo',
                  value: booking.userCreated.isNotEmpty
                      ? booking.userCreated
                      : 'Chưa xác định',
                ),
              ],
            ),
          ),
          SmartSectionHeader(title: 'Nội dung'),
          SmartCard(
            child: Text(
              booking.description.isNotEmpty
                  ? booking.description
                  : 'Booking chưa có mô tả.',
              style: AppTextStyles.body.copyWith(height: 1.45),
            ),
          ),
          SmartSectionHeader(
            title: 'Tệp đính kèm',
            actionLabel: '${booking.lstBookingAttachment.length}',
          ),
          if (booking.lstBookingAttachment.isEmpty)
            const _EmptyState(
              title: 'Không có tệp đính kèm',
              note: 'Tài liệu của booking sẽ hiển thị tại đây.',
            )
          else
            ...booking.lstBookingAttachment.map(
              (file) => SmartCard(
                child: Row(
                  children: [
                    const SmartIconBadge(label: 'FILE', tone: SmartTone.accent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        file.filePath,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }
}

class _BookingDetailLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _BookingDetailLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: SmartColors.accent),
          const SizedBox(width: 10),
          SizedBox(
            width: 104,
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
