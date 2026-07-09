part of '../home_screen.dart';

class _EmptyState extends StatelessWidget {
  final String title;
  final String note;

  const _EmptyState({required this.title, required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 130),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: SmartColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: SmartColors.border, style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: AppTextStyles.bodyMedium),
          const SizedBox(height: 6),
          Text(note, style: AppTextStyles.caption, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _LoadMoreRow extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;

  const _LoadMoreRow({required this.isExpanded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SmartTextButton(
        label: isExpanded ? 'Thu gọn' : 'Xem thêm',
        icon: isExpanded
            ? Icons.expand_less_rounded
            : Icons.expand_more_rounded,
        onTap: onTap,
      ),
    );
  }
}

class _MeetingBookingCard extends StatelessWidget {
  final BookingModel booking;
  final String roomName;

  const _MeetingBookingCard({required this.booking, required this.roomName});

  @override
  Widget build(BuildContext context) {
    final statusTone = switch (booking.statusID) {
      1 => SmartTone.warning,
      2 => SmartTone.success,
      3 => SmartTone.accent,
      4 => SmartTone.neutral,
      5 => SmartTone.danger,
      _ => SmartTone.neutral,
    };

    return SmartCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SmartPill(
                label: booking.formattedStartTime.isNotEmpty
                    ? booking.formattedStartTime
                    : '--:--',
                tone: SmartTone.accent,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  booking.bookingTitle.isNotEmpty
                      ? booking.bookingTitle
                      : 'Cuộc họp',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              SmartPill(
                label: booking.statusID == 1
                    ? 'Mới'
                    : booking.statusID == 2
                    ? 'Xác nhận'
                    : booking.statusID == 3
                    ? 'Đang diễn ra'
                    : booking.statusID == 4
                    ? 'Kết thúc'
                    : 'Hủy',
                tone: statusTone,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$roomName · ${booking.formattedDate}',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 4),
          Text(
            booking.description.isNotEmpty
                ? booking.description
                : 'Không có mô tả',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

class _MeetingRoomCard extends StatelessWidget {
  final MeetingRoomItem item;

  const _MeetingRoomCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final isActive = item.statusId == 1;
    return SmartCard(
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isActive ? SmartColors.successSoft : SmartColors.soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.meeting_room_rounded,
              color: isActive ? SmartColors.success : AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _LabelNote(
              label: item.roomBookingName,
              note: item.description,
              large: true,
            ),
          ),
          const SizedBox(width: 8),
          SmartPill(
            label: isActive ? 'Hoạt động' : 'Tạm dừng',
            tone: isActive ? SmartTone.success : SmartTone.neutral,
          ),
        ],
      ),
    );
  }
}
